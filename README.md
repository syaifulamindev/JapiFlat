# JapiFlat
JapiFlat Converter from JSON-API to ordinary JSON.

## Usage

```swift
let dictionary: [String: Any] = sampleData
let json = JapiFlat.flatJson(from: dictionary)

let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
let pretyJson = String(data: data, encoding: .utf8)!
print(pretyJson)
```

## Features

### Document
- [x] single data decoding
- [x] array data decoding
- [x] included decoding
- [ ] errors decoding
- [ ] meta decoding
- [ ] links decoding

### Resource Object
- [x] id decoding
- [x] type decoding
- [x] attributes decoding
- [x] relationships decoding
- [ ] links decoding
- [ ] meta decoding

### Relationship Object
- [x] single data decoding
- [x] array data decoding
- [ ] links decoding
- [ ] meta decoding

### Links Object
- [ ] href decoding
- [ ] meta decoding
