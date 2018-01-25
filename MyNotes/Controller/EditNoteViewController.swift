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
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    editNote()
  }
  
  //MARK: - Helpers
  private func showNote() {
    guard let title = note?.title else { return }
    titleTextField.text = title
    
    if let body = note?.body {
      bodyTextView.attributedText = body
    }
  }
  
  private func editNote() {
    let body = bodyTextView.attributedText
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
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      let attachment = NSTextAttachment()
      attachment.image = image
      
      let oldWidth = attachment.image?.size.width
      let scaleFactor = oldWidth! / (bodyTextView.frame.width - 10)
      attachment.image = UIImage(cgImage: (attachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
      let attiributedString = NSAttributedString(attachment: attachment)
      let temp = NSMutableAttributedString(attributedString: bodyTextView.attributedText)
      temp.append(attiributedString)
      bodyTextView.attributedText = temp
      
    }
    picker.dismiss(animated: true)
  }
}
