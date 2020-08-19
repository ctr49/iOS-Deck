// Created for iOS Deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

class DataManager {
    struct SavedData: Codable {
        let boards: [NCCommunicationDeckBoards]
        let stacks: [Int:[NCCommunicationDeckStacks]]
    }
    
    private var boards: [NCCommunicationDeckBoards]
    private var stacks: [Int:[NCCommunicationDeckStacks]]
    
    private let filePath: URL
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true
            ).appendingPathComponent("Data")
        } catch let error {
            fatalError(error.localizedDescription)
        }
        self.boards = []
        self.stacks = [:]
    }
    
    public func resetData() -> DataManager {
        self.boards = []
        self.stacks = [:]
//        print("reset data")
        return self
    }
    
    public func deleteDataFile() {
        do {
            try FileManager.default.removeItem(at: filePath)
            print("Disk Data Reset")
        } catch let error {
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
    private func readData() {
        let decoder = JSONDecoder()
        do {
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                let savedData = try decoder.decode(SavedData.self, from: data)
//                print("Data: \(savedData)")
                self.boards = savedData.boards
                self.stacks = savedData.stacks
            }
        } catch let error {
            print(error.localizedDescription)
            deleteDataFile()
            let _ = resetData().save() // delete data
        }
    }
    
    private func save() {
        let encoder = JSONEncoder()
        do {
            let savedData = SavedData(boards: self.boards, stacks: self.stacks)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
            let _ = resetData()
        } catch let error {
            print("Error while saving datas: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
    
}

// MARK: - public methods getting and setting data on the disk
extension DataManager {
    public func setBoards(_ boards: [NCCommunicationDeckBoards]) {
        readData()
        for board in boards {
            if let i = self.boards.firstIndex(where: { $0.id == board.id }) {
                self.boards[i] = board
            } else {
                self.boards.append(board)
            }
        }
        save()
    }
    
    public func getBoards() -> [NCCommunicationDeckBoards] {
        readData()
        //        let foundBoards = boards
        //        resetData()
        return boards
    }
    
    public func setStacks(_ stacks: [NCCommunicationDeckStacks]) {
        readData()
        let boardID = stacks[0].boardId // all stacks in list should have same boardID
        self.stacks[boardID] = stacks
        save()
    }
    
    public func setStack(_ stack: NCCommunicationDeckStacks) {
        let boardID = stack.boardId
        let index = getStacks(boardID).firstIndex(where: { $0.id == stack.id })!
        self.stacks[boardID]?[index] = stack
        save()
    }
    
    public func getStacks(_ board: Int) -> [NCCommunicationDeckStacks] {
        readData()
        let boardStacks = self.stacks.first(where: { $0.key == board})?.value
        return boardStacks ?? []
    }
}
