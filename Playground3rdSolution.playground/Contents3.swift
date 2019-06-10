import Foundation
import XCTest

extension String {
    private var reducedWhitespace: String {
        return self.components(separatedBy: .whitespacesAndNewlines)
                    .filter { $0 != "" }
                    .joined(separator: " ")
    }

    func split(withLimitOf limitChars: Int = 50) -> [String] {
        let message =  self.reducedWhitespace
        let error = "Cannot split => longer than \(limitChars)"
        guard message.count > limitChars else { return [message] }

        let extraTotal = message.count % limitChars != 0 ? 1 : 0
        let total = message.count / limitChars + extraTotal
        let subMessages = message.components(separatedBy: .whitespacesAndNewlines)
        
        for item in subMessages {
            guard item.count <= limitChars else { return [error] } 
        }

        return createdMessages(subMessages, total: total, limitChars: limitChars)
    }

    private func createdMessages(_ subMessages: [String], total: Int, limitChars: Int) -> [String] {
        var messages: [String] = []
        var currentIndex = -1
        let suffix = (length: 1, value: " ")
        for i in 0..<total {
            var part = "\(i + 1)/\(total)" + suffix.value
            let indicatorLength = part.count
            var calculatedPartLength = part.count

            for (index, item) in subMessages.enumerated() where index > currentIndex {
                guard item.count + indicatorLength <= limitChars else { return [] }
                
                calculatedPartLength += item.count + suffix.length
                if calculatedPartLength > limitChars { break }

                part += item + suffix.value
                currentIndex = index
            }

            part.removeLast()
            messages.append(part)
        }

        if currentIndex < subMessages.count - 1 {
            let fixedTotal = total + 1
            return createdMessages(subMessages, total: fixedTotal, limitChars: limitChars)
        }

        return messages
    }
}

let mess1 = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
let mess2 = "Message less than 50"
let mess3 = "abcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcbcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabcabc"
var messLongThan10: String {
    var mess = ""
    (0..<5).forEach { _ in
        let msg = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        mess += msg
    }
    return mess
}
let mess1WithItem51 = "chunkingmymessageschunkingmymessageschunkingmymess ageschunkingmymessages"

let res = mess3.split()
res.forEach { item in print(item) }
