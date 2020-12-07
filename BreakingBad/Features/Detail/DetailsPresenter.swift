//
//  DetailsPresenter.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 03/12/2020.
//

public protocol DetailsViewProtocol: class {
  func populate(_ viewModel: DetailsViewModel)
}

public protocol DetailsPresenterProtocol: class {
  var managedView: DetailsViewProtocol? { get set }
  func viewDidLoad()
}

final class DetailsPresenter: DetailsPresenterProtocol {
  
  weak var managedView: DetailsViewProtocol?
  let character: BBCharacter
  
  public init(character: BBCharacter) {
    self.character = character
  }
  
  func viewDidLoad() {
    // use a model as passing an API object into a view controller is never a good idea
    let model = DetailsViewModel(name: character.name, occupation: character.occupation, imageUrl: character.img, status: character.status, nickname: character.nickname, appearance: character.appearance)
    
    managedView?.populate(model)
  }
}
