//
//  Note.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 23.09.17.
//  Copyright © 2017 Vladimir Orlov. All rights reserved.
//

import Foundation

class Note {
  
  let id: Int
  let title: String
  let body: String?
  let createDate: Date
  var isLocked: Bool
  
  var lastUpdate: String {
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = Calendar.current
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: now)
  }
    
  init(title: String, body: String?, createDate: Date) {
    self.id = Int(arc4random_uniform(UInt32.max))
    self.title = title
    self.body = body
    self.createDate = createDate
    self.isLocked = false
  }
}
