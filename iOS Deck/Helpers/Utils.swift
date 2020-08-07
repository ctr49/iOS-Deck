// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation

//MARK: Get Document Directory Paths

//func getDocumentsDirectory(_ fileName: String) -> URL {
//    let documentPath = getDocumentsDirectory().appendingPathComponent(fileName)
//    return documentPath
//}

func getDocumentsDirectory(_ append: String? = nil) -> String {
//    var path = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    var path: URL
    do {
        try path = FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        guard let append = append else {
            return path.path
        }
        path = path.appendingPathComponent(append)
        return path.path
    } catch {
        return ""
    }
}
