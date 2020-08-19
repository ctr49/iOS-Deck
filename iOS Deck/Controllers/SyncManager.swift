// Created for iOS Deck in 2020
// Using Swift 5.0

import Foundation
import NCCommunication

class SyncManager {
    public static let shared: SyncManager = {
        let instance = SyncManager()
        return instance
    }()
    
    private var queue: [QueuableCard] = []
    private var looping: Bool = false
    
    private struct QueuableCard {
        var boardID: Int
        var cardID: Int
        var card: NCCommunicationDeckCards
    }
    
    private func loop() {
        if (self.queue.count > 0) {
            self.looping = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                let queued = self.queue[0]
                debugPrint("Updating \(queued.card)")
                debugPrint("Queue: \(queued)")
                Nextcloud.shared.updateCard(queued.boardID, queued.card) {
                    (success) in
                    if (success) {
                        self.queue.removeFirst()
                    } else {
                        /// todo: dispatch a notification that boobity bops an alert about request failing or no internet connection or something
                    }
                    self.loop()
                }
            }
        } else {
            self.looping = false
        }
    }
    
    /// at the start of looping (mayb inside syncstackcards?) need to get fresh data and store it in class mem
    /// before running NC.updatecard() need to check that the card is actually different, if its the same (params are the same, timestamp, or both?)) don't update it
    /// on that note - go ahead and figure out how NC timestamps and add timestamp maniuplation to the model manipulations in viewmodel
    
    public func SyncStackCards(_ stack: NCCommunicationDeckStacks) {
        stack.cards?.forEach() {
            (card) in
            let queueIndex = queue.firstIndex(where: { $0.cardID == card.id })
            if (queueIndex != nil) {
                queue[queueIndex!] = QueuableCard(boardID: stack.boardId, cardID: card.id, card: card)
            } else {
                queue.append(QueuableCard(boardID: stack.boardId, cardID: card.id, card: card))
            }
        }
        if (!looping) {
            loop()
        }
    }
}
