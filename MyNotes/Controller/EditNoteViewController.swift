//
//  EditNoteViewController.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 24.01.2018.
//  Copyright © 2018 Vladimir Orlov. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

protocol EditNoteViewControllerDelegate: class {
  func editNoteViewController(_ controller: EditNoteViewController, didEditNote note: Note, at indexPath: IndexPath)
}

class EditNoteViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var bodyTextView: UITextView!
  
  var note: Note?
  var indexPath: IndexPath?
  weak var delegate: EditNoteViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(addAttachment))
    
    bodyTextView.layer.borderWidth = 1.0
    bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
    bodyTextView.layer.cornerRadius = 10.0
    
    showNote()
  }
  
  //MARK: - Helpers
  private func showNote() {
    guard let title = note?.title else { return }
    titleTextField.text = title
    
    if let body = note?.body {
      bodyTextView.text = body
    }
  }
  
  private func editNote() {
    let body = bodyTextView.text
    let title = titleTextField.text
    delegate?.editNoteViewController(self, didEditNote: Note(title: title!, body: body, createDate: Date()), at: indexPath!)
  }
  
  @objc private func addAttachment() {
    let picker = UIImagePickerController()
    picker.sourceType = .photoLibrary
    picker.delegate = self
    present(picker, animated: true)
  }
  
}

extension EditNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      let attachment = NSTextAttachment()
      attachment.image = UIImage(cgImage: image.cgImage!, scale: 1.0, orientation: .up)
      
    }
    
  }
}
