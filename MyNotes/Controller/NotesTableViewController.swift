//
//  NotesTableViewController.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 23.09.17.
//  Copyright © 2017 Vladimir Orlov. All rights reserved.
//

import UIKit
import SwipeCellKit

class NotesTableViewController: UITableViewController {

  var filteredNotes: [Note] = []
  var sortedNotes: [Note] = []
  var isSorted = false
  var index: IndexPath?
  
  let manager = NoteManager()
  let searchController = UISearchController(searchResultsController: nil)
  
  var isSearchBarEmpty: Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  var isFiltering: Bool {
    return searchController.isActive && !isSearchBarEmpty
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: "NoteCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: NoteCell.reuseId)
    
    setupNavigationBar()
    
    manager.append(Note(title: "First note", body: NSAttributedString(string: "First body"), createDate: Date()))
  }
  
  //MARK: - Actions
  @IBAction func sortNotes(_ sender: UIBarButtonItem) {
    isSorted = !isSorted
    if isSorted {
      sortedNotes = manager.sort()
    }
    tableView.reloadData()
  }
  
  // MARK: - Helpers
  func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "Поиск"
    searchController.searchBar.searchBarStyle = .minimal
    searchController.searchBar.showsCancelButton = false
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering {
      return filteredNotes.count
    } else if isSorted {
      return sortedNotes.count
    }
    return manager.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.reuseId, for: indexPath) as! NoteCell
    let note: Note
    
    if isFiltering {
      note = filteredNotes[indexPath.row]
    } else if isSorted {
      note = sortedNotes[indexPath.row]
    } else {
      note = manager.note(at: indexPath.row)
    }
      
    cell.titleLabel.text          = note.title == "" ? "[Нет заголовка]" : note.title
    cell.lastUpdateLabel.text     = note.createDate.stringFromDate()
    cell.bodyLabel.attributedText = (note.body?.containsAttachments(in: NSRange(location: 0, length: (note.body?.length)!)))!
      ? NSAttributedString(string: "[Вложение]")
      : note.body
    cell.delegate = self
    
    return cell
  }

  // MARK: - Table view delegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if manager.note(at: indexPath.row).isLocked {
      if let password = UserDefaults.standard.string(forKey: "password \(self.manager.note(at: indexPath.row).id)") {
        let alert = UIAlertController(title: "Заметка заблокирована",
                                      message: "Введите пароль, чтобы разблокировать заметку",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: { textField in
          textField.keyboardType = .default
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
          if alert.textFields?.first?.text == password {
            self.manager.unlock(at: indexPath.row)
            self.performSegue(withIdentifier: Segue.editNote, sender: indexPath)
          } else {
            return
          }
        }))
        present(alert, animated: true, completion: nil)
      }
    } else {
      performSegue(withIdentifier: Segue.editNote, sender: indexPath)
    }
  }

  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? EditNoteViewController, segue.identifier == Segue.editNote {
      if isFiltering {
        destination.note = filteredNotes[(sender as! IndexPath).row]
      } else if isSorted {
        destination.note = sortedNotes[(sender as! IndexPath).row]
      } else {
        destination.note = manager.notes[(sender as! IndexPath).row]
      }
      destination.indexPath = sender as? IndexPath
      destination.delegate = self
    }
    if let destination = segue.destination as? AddNoteViewController, segue.identifier == Segue.addNote {
      destination.delegate = self
    }
  }
}

extension NotesTableViewController: AddNoteViewControllerDelegate {
  func addNoteViewController(_ controller: AddNoteViewController, didAddNote note: Note) {
    if note.title != "" || !(note.body?.isEqual(to: NSAttributedString(string: "")))! {
      manager.append(note)
      if isSorted {
        sortedNotes = manager.sort()
      }
      tableView.reloadData()
    } else {
      let alert = UIAlertController(title: "Ошибка", message: "Пустая заметка не может быть создана", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
      present(alert, animated: true)
    }
  }

}

extension NotesTableViewController: EditNoteViewControllerDelegate {
  func editNoteViewController(_ controller: EditNoteViewController, didEditNote note: Note, at indexPath: IndexPath) {
    manager.remove(at: indexPath.row)
    manager.insert(note, at: indexPath.row)
    tableView.reloadData()
  }
}

extension NotesTableViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
      if self.isSorted {
        self.sortedNotes.remove(at: indexPath.row)
      } else if self.isFiltering {
        self.filteredNotes.remove(at: indexPath.row)
      } //else {
        self.manager.remove(at: indexPath.row)
      //}
      self.tableView.deleteRows(at: [indexPath], with: .right)
      self.tableView.reloadData()
    }
    deleteAction.image = UIImage(named: "garbage")
    
    let lockAction = SwipeAction(style: .default, title: nil) { action, indexPath in
      
      let alert = UIAlertController(title: nil,
                                    message: "Для блокировки этой заметки введите пароль",
                                    preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: "Ввод пароля",
                                    style: .default,
                                    handler: { _ in
                                      let passwordAlert = UIAlertController(title: "Блокировка заметки",
                                                                            message: "Введите пароль для блокировки этой заметки",
                                                                            preferredStyle: .alert)
                                      
                                      passwordAlert.addTextField(configurationHandler: { textField in
                                        textField.returnKeyType = .done
                                      })
                                      passwordAlert.addAction(UIAlertAction(title: "Ok",
                                                                            style: .default,
                                                                            handler: { _ in
                                                                              self.manager.lock(at: indexPath.row, password: passwordAlert.textFields?.first?.text)
                                      }))
                                      passwordAlert.addAction(UIAlertAction(title: "Отмена",
                                                                            style: .cancel,
                                                                            handler: nil))
                                      self.present(passwordAlert, animated: true, completion: nil)
      }))
      
      alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
      
      self.present(alert, animated: true, completion: nil)
    }
    lockAction.image = manager.note(at: indexPath.row).isLocked ? UIImage(named: "unlocked") : UIImage(named: "locked")
    
    return [deleteAction, lockAction]
  }

}

extension NotesTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
  func updateSearchResults(for searchController: UISearchController) {
    filteredNotes = manager.filter(text: searchController.searchBar.text!)
    tableView.reloadData()
  }
  
  func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    searchController.searchBar.showsCancelButton = true
    return true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    self.view.endEditing(true)
  }
}
