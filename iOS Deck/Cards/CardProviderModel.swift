//// Created for iOS Deck in 2020
//// Using Swift 5.0
//
//final class CardProviderModel: NSObject, NSItemProviderReading, NSItemProviderWriting {
//    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> CardProviderModel {
//        let decoder = JSONDecoder()
//        let decodedCard = try decoder.decode(CardProviderModel.self, from: data)
//        return decodedCard
//    }
//    
//    static var writableTypeIdentifiersForItemProvider: [String] {
//        return ["com.cback.cards"]
//    }
//    
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//        let progress = Progress(totalUnitCount: 100)
//        // Here the object is encoded to a JSON data object and sent to the completion handler
//        do {
//            let data = try JSONEncoder().encode(self)
//            progress.completedUnitCount = 100
//            completionHandler(data, nil)
//        } catch {
//            completionHandler(nil, error)
//        }
//
//        return progress
//        
//    }
//    
//    static var readableTypeIdentifiersForItemProvider: [String] {
//        return ["com.cback.cards"]
//    }
//    
//    var card: NCCommunicationDeckCards
//
//    init(card: NCCommunicationDeckCards) {
//        self.card = card
//    }
//}
