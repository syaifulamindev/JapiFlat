//
//  JapiFlat.swift
//  JapiFlat
//
//  Created by Saminos on 13/08/19.
//  Copyright © 2019 Style Theory Technologies. All rights reserved.
//

import Foundation

fileprivate enum Keys: String {
    case data, included, id, type, attributes, relationships, meta
}

fileprivate struct TypeIdPair {
    let id: String
    let type: String
}

extension TypeIdPair: Hashable, Equatable {
    static func == (lhs: TypeIdPair, rhs: TypeIdPair) -> Bool {
        return lhs.type == rhs.type && lhs.id == rhs.id
    }
}

public class JapiFlat {
    
    private init() {}
    
    public static func flatJson(from object: [String: Any]) -> [String: Any]? {
        var result: [String: Any] = [:]
        
        let japiFlat = JapiFlat()
        let included = japiFlat.resolveIncludes(object: object)
        let resourceRaw = object[Keys.data.rawValue]
        
        result[Keys.data.rawValue] = japiFlat.resolveResource(raw: resourceRaw, included: included)
        result[Keys.meta.rawValue] = object[Keys.meta.rawValue]
        return result
    }
    
    private func resolveResource(raw: Any?, included: [TypeIdPair: [String: Any]]?, solving: Set<TypeIdPair> = [], isRootData: Bool = true) -> Any? {
        var solving = solving
        
        if let arrayResourceRaw = raw as? [[String: Any]] {
            var resolvedArrayRelationship = [[String: Any]]()
            for resourceRaw in arrayResourceRaw {
                guard let resolvedResource = resource(from: resourceRaw, included: included, solving: &solving) else { return nil }
                resolvedArrayRelationship.append(resolvedResource)
            }
            return resolvedArrayRelationship
        } else if let resourceRaw = raw as? [String: Any] {
            let resolvedResource = resource(from: resourceRaw, included: included, solving: &solving)
            return resolvedResource
        }
        return nil
    }
    
    private func resource(from resourceRaw: [String: Any]?, included: [TypeIdPair: [String: Any]]?, solving: inout Set<TypeIdPair>) -> [String: Any]? {
        var result: [String: Any]?
        let attributes = resolveAttributes(resourceRaw: resourceRaw)
        
        result = attributes
        guard
            let id = resourceRaw?[Keys.id.rawValue] as? String,
            let type = resourceRaw?[Keys.type.rawValue] as? String else { return result }
        
        solving.insert(TypeIdPair(id: id, type: type))
        guard let relationships = resolveRelationship(resourceRaw: resourceRaw, included: included, solving: &solving) else { return result }
        
        result?.merge(relationships) { (current, new) -> Any in new }
        
        return result
    }
    
    private func resolveAttributes(resourceRaw: [String: Any]?) -> [String: Any]? {
        var attributesObject = resourceRaw?[Keys.attributes.rawValue] as? [String: Any]
        let id = resourceRaw?[Keys.id.rawValue] as? String
        attributesObject?[Keys.id.rawValue] = id
        return attributesObject
    }
    
    private func resolveRelationship(resourceRaw: [String: Any]?, included: [TypeIdPair: [String: Any]]?, solving: inout Set<TypeIdPair> = []) -> [String: Any]? {
        guard
            let id = resourceRaw?[Keys.id.rawValue] as? String,
            let type = resourceRaw?[Keys.type.rawValue] as? String else { return nil }

        let typeIdPair = TypeIdPair(id: id, type: type)
        
        
        guard let relationshipsRaw = resourceRaw?[Keys.relationships.rawValue] as? [String: [String: Any]] else { return nil }
        
        var resolvedAllRelationship: [String: Any] = [:]
        for tuple in relationshipsRaw {
            var resourceRaw: Any?
            if let relationshipRaw = tuple.value["data"] as? [String: Any]? {
                resourceRaw = relationship(relationshipRaw: relationshipRaw, included: included, solving: &solving)
            } else if let arrayRelationshipData = tuple.value["data"] as? [[String: Any]]? {
                resourceRaw = arrayRelationshipData?.compactMap { relationshipRaw -> [String: Any]? in
                    return relationship(relationshipRaw: relationshipRaw, included: included, solving: &solving)
                }
            }
            resolvedAllRelationship[tuple.key] = resolveResource(raw: resourceRaw, included: included, solving: solving, isRootData: false)
        }
        
        solving.remove(typeIdPair)
        return resolvedAllRelationship
    }
    
    private func relationship(relationshipRaw: [String: Any]?, included: [TypeIdPair: [String: Any]]?, solving: inout Set<TypeIdPair> = []) -> [String: Any]? {
        guard
            let id = relationshipRaw?[Keys.id.rawValue] as? String,
            let type = relationshipRaw?[Keys.type.rawValue] as? String else { return nil }
        let typeIdPair = TypeIdPair(id: id, type: type)
        if solving.contains(typeIdPair) { return nil }
        return included?[typeIdPair]
    }

    private func resolveIncludes(object: [String: Any]?) -> [TypeIdPair: [String: Any]]? {
        let includedObject = object?[Keys.included.rawValue]  as? [[String: Any]] ?? []
        
        var includedResolved: [TypeIdPair: [String: Any]] = [:]
        for value in includedObject {
            var relationship = value
            guard let id = relationship[Keys.id.rawValue] as? String,
                let type = relationship[Keys.type.rawValue] as? String else { continue }
            
            let key = TypeIdPair(id: id, type: type)
            includedResolved.updateValue(relationship, forKey: key)
        }
        
        return includedResolved
    }
    
}
