//
//  NoteCell.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 23.09.17.
//  Copyright © 2017 Vladimir Orlov. All rights reserved.
//

import UIKit
import SwipeCellKit

class NoteCell: SwipeTableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var lastUpdateLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  
  public static let reuseId = "NoteCell"
  
}
