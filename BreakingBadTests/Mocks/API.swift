//
//  API.swift
//  BreakingBadTests
//
//  Created by Saville, Jonathan on 02/12/2020.
//

import Foundation
@testable import BreakingBad

extension Mocks {
  
  class API: ApiProtocol {

    public var errorToReturn: NSError? = nil
    public var loadCharactersToReturn: Characters = []
  
    public func loadCharacters(completion: @escaping (Result<Characters, NSError>) -> Void) {
    
      if let error = errorToReturn {
        completion(.failure(error))
      }
      else {
        completion(.success(loadCharactersToReturn))
      }
    }
  }
}
