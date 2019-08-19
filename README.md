# JapiFlat
JapiFlat Converter from JSON-API to ordinary JSON.

## How to install

to integrate JapiFlat into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby
pod 'JapiFlat', :git => 'https://github.com/saminos/JapiFlat.git'
```

## Usage

```swift
import JapiFlat

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
