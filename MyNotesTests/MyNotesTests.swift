//
//  MyNotesTests.swift
//  MyNotesTests
//
//  Created by Vladimir Orlov on 25.01.2018.
//  Copyright © 2018 Vladimir Orlov. All rights reserved.
//

import XCTest
@testable import MyNotes

class MyNotesTests: XCTestCase {
  var notes: [Note] = []
  var expectedNotes: [Note] = []
  let manager = NoteManager()
  
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    super.tearDown()
    notes = []
    expectedNotes = []
    manager.clear()
  }
  
  func testSorting() {
    notes         = [Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    expectedNotes = [Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    notes.forEach { manager.append($0) }
    
    let sorted = manager.sort()
    XCTAssertEqual(sorted[0].title, expectedNotes[0].title)
    XCTAssertEqual(sorted[1].title, expectedNotes[1].title)
    XCTAssertEqual(sorted[2].title, expectedNotes[2].title)
    XCTAssertEqual(sorted[3].title, expectedNotes[3].title)
  }
  
  func testSortingAppend() {
    notes         = [Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    expectedNotes = [Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    notes.forEach { manager.append($0) }
    
    let newNote = Note.init(title: "K", body: NSAttributedString.init(string: "_"), createDate: Date())
    manager.append(newNote)
    let sorted = manager.sort()
    expectedNotes.append(newNote)
    XCTAssertEqual(sorted[0].title, expectedNotes[0].title)
    XCTAssertEqual(sorted[1].title, expectedNotes[1].title)
    XCTAssertEqual(sorted[2].title, expectedNotes[2].title)
    XCTAssertEqual(sorted[3].title, expectedNotes[3].title)
    XCTAssertEqual(sorted[4].title, expectedNotes[4].title)
  }
  
  func testSortingInsert() {
    notes         = [Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    expectedNotes = [Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    notes.forEach { manager.append($0) }
    
    let newNote = Note.init(title: "K", body: NSAttributedString.init(string: "_"), createDate: Date())
    let index = 0
    manager.insert(newNote, at: index)
    var sorted = manager.sort()
    //добавляем в конец, потому что К после сортировки окажется в конце
    expectedNotes.append(newNote)
    XCTAssertEqual(sorted[0].title, expectedNotes[0].title)
    XCTAssertEqual(sorted[1].title, expectedNotes[1].title)
    XCTAssertEqual(sorted[2].title, expectedNotes[2].title)
    XCTAssertEqual(sorted[3].title, expectedNotes[3].title)
    XCTAssertEqual(sorted[4].title, expectedNotes[4].title)
  }
  
  func testSortingRemove() {
    notes         = [Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    expectedNotes = [Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    notes.forEach { manager.append($0) }
    
    let index = 0
    var sorted = manager.sort()
    sorted.remove(at: index)
    expectedNotes.remove(at: index)
    XCTAssertEqual(sorted[0].title, expectedNotes[0].title)
    XCTAssertEqual(sorted[1].title, expectedNotes[1].title)
    XCTAssertEqual(sorted[2].title, expectedNotes[2].title)
  }
  
  func testFiltering() {
    notes         = [Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    expectedNotes = [Note.init(title: "A", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "B", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "C", body: NSAttributedString.init(string: "_"), createDate: Date()),
                     Note.init(title: "D", body: NSAttributedString.init(string: "_"), createDate: Date())]
    
    notes.forEach { manager.append($0) }
    
    let filtered = manager.filter(text: "A")
    XCTAssertEqual(filtered[0].title, "A")
  }
}

