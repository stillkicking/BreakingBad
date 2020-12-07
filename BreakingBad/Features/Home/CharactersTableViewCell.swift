//
//  CharactersTableViewCell.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 03/12/2020.
//

import UIKit
import Kingfisher

class CharactersTableViewCell: UITableViewCell {
  
  public static let identifier = CharactersTableViewCell.self
  public static let identifierString = String(describing: identifier)
  public static var cellNib: UINib {
    return UINib(nibName: identifierString, bundle: Bundle(for: identifier))
  }

  @IBOutlet private weak var name: UILabel!
  @IBOutlet private weak var icon: UIImageView!
  
  func configure(imageUrl: String, name: String) {
    self.name.text = name
    icon.kf.setImage(with: URL(string: imageUrl))
    separatorInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
  }
}
