//
//  FruitsDetail.swift
//  SAPDemoApp
//
//  Created by Dipak Pandey on 03/05/21.
//


struct FruitsDetail: Decodable {
    
    var fruits = [Fruit]()
    var list = [String]()
    
    
    enum CodingKeys: CodingKey {
       case fruits
       case list

   }
    // Define DynamicCodingKeys type needed for creating
       // decoding container from JSONDecoder
    
       private struct DynamicCodingKeys: CodingKey {

           // Use for string-keyed dictionary
           var stringValue: String
           init?(stringValue: String) {
               self.stringValue = stringValue
           }

           // Use for integer-keyed dictionary
           var intValue: Int?
           init?(intValue: Int) {
               // We are not using this, thus just return nil
               return nil
           }
       }

    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        list = try container.decodeIfPresent(Array.self, forKey: .list) ?? []
        // 1
        // Create a decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let nestedContainer = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .fruits)
        
        var tempArray = [Fruit]()
        
        // 2
        // Loop through each key (student ID) in container
        for key in nestedContainer.allKeys {
            // Decode Student using key & keep decoded Student object in tempArray
            let decodedObject = try nestedContainer.decode(Fruit.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        
        // 3
        // Finish decoding all Student objects. Thus assign tempArray to array.
        fruits = tempArray
    }
    
}

struct Fruit: Decodable {
    var name: String
    var url : String
    
     enum FruitKeys: CodingKey {
        case url
    }
        
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: FruitKeys.self)
        url = try container.decodeIfPresent(String.self, forKey: FruitKeys.url) ?? ""
        name = container.codingPath.first?.stringValue ?? ""
    }
    
}
