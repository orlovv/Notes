//
//  Extensions.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 02.10.2017.
//  Copyright © 2017 Vladimir Orlov. All rights reserved.
//

import Foundation

extension String {
  
  subscript(index: Int) -> Character {
    guard let index = self.index(startIndex, offsetBy: index, limitedBy: endIndex) else {
      fatalError("String index out of bounds")
    }
    return self[index]
  }
  
  func substring(pattern: String) -> [Int] {
    var array = [Int]()
    let selfLength = self.count
    let ptrnLength = pattern.count
    var count = 0
    
    for i in 0...selfLength - ptrnLength {
      count = 0
      while count < ptrnLength && pattern[count] == self[i + count] {
        count += 1
      }
      if count == ptrnLength {
        array.append(i)
      }
    }
    return array
  }
}

public extension Date {
  
  public func stringFromDate() -> String {
    let df = DateFormatter()
    df.calendar = Calendar.current
    df.dateFormat = "HH:mm"
    return df.string(from: self)
  }
}
