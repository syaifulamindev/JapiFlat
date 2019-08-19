# JapiFlat
JapiFlat Converter from JSON-API to ordinary JSON.

# Usage

```swift
let dictionary: [String: Any] = sampleData
let json = JapiFlat.flatJson(from: dictionary)

let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
let pretyJson = String(data: data, encoding: .utf8)!
print(pretyJson)
```
