// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation

//MARK: Get Document Directory Paths

//func getDocumentsDirectory(_ fileName: String) -> URL {
//    let documentPath = getDocumentsDirectory().appendingPathComponent(fileName)
//    return documentPath
//}

func getDocumentsDirectory() -> String {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
    return path
}
