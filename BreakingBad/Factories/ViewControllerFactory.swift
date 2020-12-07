//
//  ViewControllerFactory.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 03/12/2020.
//

import UIKit

public class ViewControllerFactory {

  public func getCharactersViewController() -> UIViewController {
    let presenter = CharactersPresenter()
    return CharactersViewController(presenter: presenter)
  }

  public func getDetailsViewController(character: BBCharacter) -> UIViewController {
    let presenter = DetailsPresenter(character: character)
    return DetailsViewController(presenter: presenter)
  }
}
