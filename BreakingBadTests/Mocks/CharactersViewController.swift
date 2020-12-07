//
//  CharactersViewController.swift
//  BreakingBadTests
//
//  Created by Saville, Jonathan on 02/12/2020.
//

//import XCTest
@testable import BreakingBad

extension Mocks {
  
  class CharactersViewController: CharactersViewProtocol {
    var reloadCalled = false
    
    func reload() {
      reloadCalled = true
    }
  }
}
