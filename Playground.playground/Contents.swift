import Foundation
import XCTest

print("Hello World")
extension String { 
    subscript(_ range: CountableRange<Int>) -> String { 
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }

    // get specific index
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }    
}      

class TweeterMessager {

    func splitMessage(_ message: String) -> [String] {
        var messages: [String] = []
        let chars = (limit: 50, limitWithPart: 46)
        let extraPart = message.count % chars.limit == 0 ? 0 : 1
        let partIndicator = message.count / chars.limit + extraPart
        let lastIndicator = partIndicator - 1

        guard message.count > chars.limit else {
            messages.append(message[0..<chars.limit])
            return messages
        }

        for i in 0..<partIndicator {
            let index = (   start: i*chars.limitWithPart, 
                            end: (i + 1)*chars.limitWithPart)
   
            messages.append("\(i+1)/\(partIndicator) " + message[index.start..<index.end])
            
            let isNotAllowSplit = messages[i].last != " " && i != lastIndicator
            if isNotAllowSplit {
                print("Error: non-whitespace character => cannot split!!!")
                return []
            }

            if i != lastIndicator {
                messages[i].removeLast()
            }  
        }
        
        return messages
    }

}

let tweet: TweeterMessager = TweeterMessager() 
var messageToPrint:[String] = []
messageToPrint = tweet.splitMessage("I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself.")
messageToPrint.forEach { item in 
    print(item)
}

messageToPrint = tweet.splitMessage("I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself. , so I don't have to do it myself.")
messageToPrint.forEach { item in 
    print(item)
}

messageToPrint = tweet.splitMessage("This is less than 50 characters")
messageToPrint.forEach { item in 
    print(item)
}

messageToPrint = tweet.splitMessage("I can't believe Tweeter now supports chunkingaaaaaa")
messageToPrint.forEach { item in 
    print(item)
}


// Unit Test
class TweeterTests: XCTestCase {
  var tweeterMessager: TweeterMessager!
  
  override func setUp() {
    super.setUp()
    tweeterMessager = TweeterMessager()
  }

  override func tearDown() {
    tweeterMessager = nil
    super.tearDown()
  }
  
  func testMessageGreaterThan50() {
    let userMessage = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
    let splitedMessage = tweet.splitMessage(userMessage)
    let result = ["1/2 I can't believe Tweeter now supports chunking", 
                    "2/2 my messages, so I don't have to do it myself."]

    XCTAssertEqual(splitedMessage, result, "message splited from user message is wrong")
  }
  
  func testMessageSmallerThan50() {
    let userMessage = "This is less than 50 characters"
    let splitedMessage = tweet.splitMessage(userMessage)
    let result = ["This is less than 50 characters"]
    
    XCTAssertEqual(splitedMessage, result, "single message result is wrong")
  }

  func testMessagCannotSplit() {
    let userMessage = "I can't believe Tweeter now supports chunkingaaaaaa"
    let splitedMessage = tweet.splitMessage(userMessage)
    let result: [String] = []
    
    XCTAssertEqual(splitedMessage, result, "error result is wrong")
  }
}

