//
//  API.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 02/12/2020.
//

import Foundation
import Alamofire

public typealias Characters = [BBCharacter]

public struct BBCharacter: Decodable {
  let char_id: Int
  let name: String
  let birthday: String
  let occupation: [String]
  let img: String
  let status: String
  let nickname: String
  let appearance: [Int]?
  let portrayed: String
  let category: String
  let better_call_saul_appearance: [Int]

  enum CodingKeys: String, CodingKey {
    case char_id
    case name
    case birthday
    case occupation
    case img
    case status
    case nickname
    case appearance
    case portrayed
    case category
    case better_call_saul_appearance
  }
}

public protocol ApiProtocol {
  func loadCharacters(completion: @escaping (Result<Characters, NSError>) -> Void)
}

public class Api: ApiProtocol {
  
  private enum Endpoint {
    static let load = "https://breakingbadapi.com/api/characters"
  }
 
  public init() {}
  
  public func loadCharacters(completion: @escaping (Result<Characters, NSError>) -> Void) {
    
    AF.request(Endpoint.load).validate().responseDecodable(of: Characters.self) { (response) in
     
    guard let characters = response.value else {
      completion(.failure(NSError()))
      return
    }
    completion(.success(characters))
    }
  }
}
