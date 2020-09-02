// Created for iOS Deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

class SyncManager {
    public static let shared: SyncManager = {
        let instance = SyncManager()
        return instance
    }()
    
    private var inQueue: [QueuableCard] = []
    
    private var timerActive: Bool = false
    private var timeRemaining: Int = 2
    
    private var processing: Bool = false
    
    private struct QueuableCard {
        var boardID: Int
        var cardID: Int
        var card: NCCommunicationDeckCards
    }
    
    
    private var processingTimerActive: Bool = false
    private var processingTimerRemaining: Int = 1
    private func Sync() {
        if (processing) {
            if (processingTimerActive) {
                self.processingTimerRemaining = 1
                return
            }
            
            processingTimerActive = true
            let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ t in
                if (self.processingTimerRemaining == 0) {
                    t.invalidate()
                    self.processingTimerRemaining = 1
                    self.processingTimerActive = false
                    DispatchQueue.main.async {
                        self.Sync()
                    }
                }
                self.processingTimerRemaining -= 1
            }
        } else {
            if (timerActive) {
                self.timeRemaining = 2
                print("Reset - Counting down")
                return
            }
            
            if (inQueue.count == 0) {
                return
            }
            
            timerActive = true
            var _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ t in
                if (self.timeRemaining == 0) {
                    t.invalidate()
                    self.processing = true
                    self.timerActive = false
                    self.timeRemaining = 2
                    
                    Nextcloud.shared.getStacks(boardID: self.inQueue.first!.boardID) {
                        stacks in
                        if let currentStack = stacks.first(where: { $0.id == self.inQueue.first!.card.stackId }) {
                            self.processQueue(currentStack) {
                                self.processing = false
                            }
                        }
                    }
                } else {
                    print(self.timeRemaining)
                    self.timeRemaining -= 1
                }
            }
        }
    }
    
    private func processQueue(_ currentStack: NCCommunicationDeckStacks, closure: @escaping () -> Void) {
        var queue = self.inQueue
        self.inQueue = []
        
        func nextIteration() {
            if (queue.count == 0) {
                closure()
                return
            }
            
            if (queue.count > 0) {
                let queued = queue[0]
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if let currentCard = currentStack.cards?.first(where: { $0.id == queued.card.id }) {
                        print(currentCard == queued.card)
                        if (currentCard != queued.card) {
                            Nextcloud.shared.updateCard(queued.boardID, queued.card) {
                                (success) in
                                if (success) {
                                    queue.removeFirst()
                                } else {
                                    /// todo: dispatch a notification that boobity bops an alert about request failing or no internet connection or something
                                }
                                nextIteration()
                            }
                        } else { // dont update the card if it hasn't actually changed
                            queue.removeFirst()
                            nextIteration()
                        }
                    } else {
                        Nextcloud.shared.updateCard(queued.boardID, queued.card) {
                            (success) in
                            if (success) {
                                queue.removeFirst()
                            } else {
                                /// todo: dispatch a notification that boobity bops an alert about request failing or no internet connection or something
                            }
                            nextIteration()
                        }
                    }
                }
            }
        }
        nextIteration()
    }
    
    public func SyncStackCards(_ stack: NCCommunicationDeckStacks) {
        stack.cards?.forEach() {
            (card) in
            if let queueIndex = self.inQueue.firstIndex(where: { $0.cardID == card.id }) {
                self.inQueue[queueIndex] = QueuableCard(boardID: stack.boardId, cardID: card.id, card: card)
            } else {
                self.inQueue.append(QueuableCard(boardID: stack.boardId, cardID: card.id, card: card))
            }
        }
        self.Sync()
    }
    
    public func SyncCard(_ card: NCCommunicationDeckCards, boardID: Int) {
        if let queueIndex = inQueue.firstIndex(where: { $0.cardID == card.id }) {
            inQueue[queueIndex] = QueuableCard(boardID: boardID, cardID: card.id, card: card)
        } else {
            inQueue.append(QueuableCard(boardID: boardID, cardID: card.id, card: card))
        }
        Sync()
    }
}

