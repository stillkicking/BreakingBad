//
//  SearchView.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 03/12/2020.
//

import UIKit

protocol SearchViewDelegate: class {
  func searchChanged(_ value: String?) // nil means search is disabled
  func stepperChanged(_ value: Int?) // nil means stepper is disabled
}

class SearchView: UIView {
  
  public weak var delegate: SearchViewDelegate?
  public var stepperMaximumValue: Int = 0 { didSet { stepper.maximumValue = Double(stepperMaximumValue) } }
  public var stepperTitle: String = "" { didSet { stepperLabel.text = stepperTitle } }
  public var searchBarPlaceholder: String = "" { didSet { searchBar.placeholder =  searchBarPlaceholder } }

  private let identifier = SearchView.self

  @IBOutlet private weak var contentView: UIView!
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var stepperLabel: UILabel!
  @IBOutlet private weak var stepperValueLabel: UILabel!
  @IBOutlet private weak var stepper: UIStepper!

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  @IBAction func stepperValue(sender: UIStepper) {
    let value: Int? = sender.value == 0 ? nil : Int(sender.value)
    stepperValueLabel.text = (value == nil ? "" : "\(value!)")
    delegate?.stepperChanged(value)
  }
  
  private func commonInit() {
    let bundle = Bundle(for: identifier)
    bundle.loadNibNamed(String(describing: identifier), owner: self, options: nil)
    addSubview(contentView)
    
    contentView.frame = self.bounds
    contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
 
    searchBar.delegate = self
    searchBar.autocapitalizationType = .none
    searchBar.backgroundImage = UIImage() // remove top and bottom border (do not leave it as nil)

    stepper.value = 0 // 0 means stepper selection is off
    stepper.minimumValue = 0
  }
}

// MARK: - UISearchBarDelegate
extension SearchView: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let text: String? = searchText.isEmpty ? nil : searchText
    delegate?.searchChanged(text)
  }
}
