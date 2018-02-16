//
//  NoteViewController.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 23.09.17.
//  Copyright © 2017 Vladimir Orlov. All rights reserved.
//

import UIKit

protocol AddNoteViewControllerDelegate: class {
  func addNoteViewController(_ controller: AddNoteViewController, didAddNote note: Note)
}

class AddNoteViewController: UIViewController {
  
  @IBOutlet weak var bodyTextView: UITextView!
  @IBOutlet weak var titleTextField: UITextField!
  
  weak var delegate: AddNoteViewControllerDelegate?
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    bodyTextView.layer.borderWidth = 1.0
    bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
    bodyTextView.layer.cornerRadius = 10.0
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    makeNote()
  }
  
  private func makeNote() {
    if let title = titleTextField.text {
      if let body = bodyTextView.attributedText {
        delegate?.addNoteViewController(self, didAddNote: Note(title: title, body: body, createDate: Date()))
      } else {
        delegate?.addNoteViewController(self, didAddNote: Note(title: title, body: nil, createDate: Date()))
      }
    } else {
      delegate?.addNoteViewController(self, didAddNote: Note(title: "", body: nil, createDate: Date()))
    }
  }

}

