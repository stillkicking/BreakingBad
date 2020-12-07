//
//  CharactersPresenter.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 03/12/2020.
//

public protocol CharactersViewProtocol: class {
  func reload()
}

public protocol CharactersPresenterProtocol: class {
  var searchFilter: String? { get set }
  var seasonFilter: Int? { get set }
  var characterCount: Int { get }
  var seasonCount: Int { get }
  var managedView: CharactersViewProtocol? { get set }
  func character(at row:Int) -> BBCharacter?
  func start()
}

final class CharactersPresenter: CharactersPresenterProtocol {
  
  var searchFilter: String? { didSet { applyFilters() } }
  var seasonFilter: Int? { didSet { applyFilters() } }
  
  var characterCount: Int {
    guard let characters = characters else { return 0 }
    let array = filteredCharacters ?? characters
    return array.count
  }
  
  var seasonCount: Int {
    guard let characters = characters else { return 0 }
    let array = filteredCharacters ?? characters
    var latestSeason = 0
    for character in array {
      latestSeason = max(latestSeason, character.appearance?.max() ?? 0)
    }
    return latestSeason
  }
  
  weak var managedView: CharactersViewProtocol?

  private let api: ApiProtocol
  private var characters: Characters?
  var filteredCharacters: Characters? // internal to allow Unit Testing

  public init(api: ApiProtocol = Api()) {
    self.api = api
  }
  
  public func start() {

    api.loadCharacters() { result in
      switch result {
      case .success(let characters):
        self.characters = characters
        self.managedView?.reload()
      case .failure(let error):
        print(error.localizedDescription)
        // further error handling...
      }
    }
  }
  
  func character(at row:Int) -> BBCharacter? {
    guard let characters = characters else { return nil }
    let array = filteredCharacters ?? characters
    return array.indices.contains(row) ? array[row] : nil
  }
  
  private func applyFilters() {
    guard searchFilter != nil || seasonFilter != nil  else {
      filteredCharacters = nil
      return
    }

    typealias FilterClosure = ((BBCharacter) -> Bool)
    
    var searchClosure: FilterClosure = { _ in return true }
    var seasonClosure: FilterClosure = { _ in return true }
    
    if let searchText = searchFilter {
      searchClosure = { $0.name.range(of: searchText, options: .caseInsensitive) != nil }
    }
    
    if let season = seasonFilter {
      seasonClosure = { $0.appearance?.contains(season) ?? false }
    }

    filteredCharacters = characters?.compactMap( { return searchClosure($0) && seasonClosure($0) ? $0 : nil } )
  }
}
