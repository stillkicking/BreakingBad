//
//  CharactersViewController.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 02/12/2020.
//

import UIKit

class CharactersViewController: UIViewController, CharactersViewProtocol {

  @IBOutlet weak var tableView: UITableView!

  private static let identifier = CharactersViewController.self
  private static let identifierString = String(describing: identifier)
  
  private let presenter: CharactersPresenterProtocol
  private var searchView: SearchView!

  private enum Constants {
    static let screenTitle = "Breaking Bad"
    static let searchBarPlaceholder = "Search"
    static let stepperTitle = "Season:"
    static let searchViewHeight: CGFloat = 75
  }
  
  public init(presenter: CharactersPresenterProtocol) {
    self.presenter = presenter
    super.init(nibName: CharactersViewController.identifierString, bundle: Bundle(for: CharactersViewController.identifier))
    presenter.managedView = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    presenter.start()
  }

  func reload() {
    tableView.reloadData()
    searchView.stepperMaximumValue = presenter.seasonCount
  }
  
  private func setup() {
    navigationItem.title = Constants.screenTitle
    searchView = SearchView()
    searchView.delegate = self
    searchView.stepperTitle = Constants.stepperTitle
    searchView.searchBarPlaceholder = Constants.searchBarPlaceholder
 
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CharactersTableViewCell.cellNib, forCellReuseIdentifier: CharactersTableViewCell.identifierString)

    // remove the last table row separator
    tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
  }
}

// MARK: - SearchViewDelegate
extension CharactersViewController: SearchViewDelegate {
  
  func searchChanged(_ value: String?) {
    presenter.searchFilter = value
    tableView.reloadData()
  }

  func stepperChanged(_ value: Int?) {
    presenter.seasonFilter = value
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension CharactersViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection: Int) -> CGFloat {
    return Constants.searchViewHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection: Int) -> UIView? {
    return searchView
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.characterCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CharactersTableViewCell.identifier)) as! CharactersTableViewCell
    let character = presenter.character(at: indexPath.row)
    cell.configure(imageUrl: character?.img ?? "", name: character?.name ?? "") // character should never be nil
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CharactersViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
    guard let character = presenter.character(at: indexPath.row) else { return }
    let vc = ViewControllerFactory().getDetailsViewController(character: character)
    navigationController?.pushViewController(vc, animated: true)
  }
}
