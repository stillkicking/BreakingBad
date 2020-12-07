//
//  DetailsViewController.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 02/12/2020.
//

import UIKit
import Kingfisher

class DetailsViewController: UIViewController, DetailsViewProtocol {

  @IBOutlet weak private var name: UILabel!
  @IBOutlet weak private var nickname: UILabel!
  @IBOutlet weak private var imageView: UIImageView!
  @IBOutlet weak private var occupation: UILabel!
  @IBOutlet weak private var status: UILabel!
  @IBOutlet weak private var appearances: UILabel!

  private static let identifier = DetailsViewController.self
  private static let identifierString = String(describing: identifier)
  
  private let presenter: DetailsPresenterProtocol
 
  private enum Constants {
    static let screenTitle = "Character Detail"
    static let backButtonTitle = "back"

    enum Formats {
      static let hasAppearedIn = "%@ has appeared in season%@ %@"
      static let noAppearances = "There is no record of %@ appearing in any of the seasons"
    }
  }
  
  public init(presenter: DetailsPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: DetailsViewController.identifierString, bundle: Bundle(for: DetailsViewController.identifier))
    presenter.managedView = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    presenter.viewDidLoad()
  }

  public func populate(_ viewModel: DetailsViewModel) {
    name.text = viewModel.name
    nickname.text = viewModel.nickname
    imageView.kf.setImage(with: URL(string: viewModel.imageUrl))
    occupation.text = viewModel.occupation.joined(separator: ", ")
    status.text = viewModel.status
    
    if let stringArray = viewModel.appearance?.map(String.init) {
      let appearancesText = stringArray.joined(separator: ", ").replacingLastOccurrenceOfString(",", with: " and")
      let plural = stringArray.count > 1 ? "s" : ""
      appearances.text = String(format: Constants.Formats.hasAppearedIn, viewModel.nickname, plural, appearancesText)
    }
    else {
      appearances.text = String(format: Constants.Formats.noAppearances, viewModel.nickname)
    }
  }
  
  private func setup() {
    navigationItem.title = Constants.screenTitle
    let backButton = UIBarButtonItem()
    backButton.title = Constants.backButtonTitle
    navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
  }
}
