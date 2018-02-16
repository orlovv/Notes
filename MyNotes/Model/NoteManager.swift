//
//  NoteManager.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 17.01.2018.
//  Copyright © 2018 Vladimir Orlov. All rights reserved.
//

import Foundation

class NoteManager {
  
  private(set) var notes: [Note] = []
  
  public var count: Int {
    return notes.count
  }
  
//  static let shared = NoteManager()
  
  public init() {
    notes = []
  }
  
  public func note(at index: Int) -> Note {
    return notes[index]
  }
  
  public func clear() {
    notes.removeAll()
  }
  
  public func append(_ note: Note) {
    notes.append(note)
  }
  
  public func insert(_ note: Note, at index: Int) {
    notes.insert(note, at: index)
  }
  
  public func remove(at index: Int) {
    notes.remove(at: index)
  }

  public func filter(text: String, scope: String = "All") -> [Note] {
    return notes.filter { $0.title.lowercased().contains(text.lowercased()) }
  }

  public func sort() -> [Note] {
    return notes.sorted { $0.title < $1.title }
  }
  
  public func lock(at index: Int, password: String? = nil) {
    notes[index].isLocked = !notes[index].isLocked
    if let password = password {
      UserDefaults.standard.set(password, forKey: "password \(notes[index].id)")
    }
  }
  
  public func unlock(at index: Int) {
    notes[index].isLocked = !notes[index].isLocked
  }
}
