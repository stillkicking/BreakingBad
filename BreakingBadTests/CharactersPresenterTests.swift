//
//  CharactersPresenterTests.swift
//  BreakingBadTests
//
//  Created by Saville, Jonathan on 02/12/2020.
//

import XCTest
@testable import BreakingBad

class CharactersPresenterTests: XCTestCase {

  var mockApi: Mocks.API!
  var mockCharactersVC: Mocks.CharactersViewController!
  
  override func setUpWithError() throws {
    mockApi = Mocks.API()
    mockCharactersVC = Mocks.CharactersViewController()
  }

  override func tearDownWithError() throws {
    mockApi = nil
    mockCharactersVC = nil
  }

  func test_noFilter_characterCount_0() {
    checkCharacterCount(0)
  }
  
  func test_noFilter_characterCount_2() {
    checkCharacterCount(2)
  }
  
  func test_noFilter_characterCount_10() {
    checkCharacterCount(10)
  }
  
  func test_searchFilter_multiple_success_scenarios() {
    // multiple tests here, naming the tests individually would be messy...
    checkSearchFilter("b", names: ["abc"], expectedNames: ["abc"])
    checkSearchFilter("b", names: ["abc","abc"], expectedNames: ["abc","abc"])
    checkSearchFilter("b", names: ["abc","abc", "def"], expectedNames: ["abc","abc"])
    checkSearchFilter("d", names: ["abc","def", "ghi"], expectedNames: ["def"])

    checkSearchFilter("ab", names: ["abc"], expectedNames: ["abc"])
    checkSearchFilter("ab", names: ["abc","abc"], expectedNames: ["abc","abc"])
    checkSearchFilter("ab", names: ["abc","abc", "def"], expectedNames: ["abc","abc"])
    checkSearchFilter("de", names: ["abc","def", "ghi"], expectedNames: ["def"])

    checkSearchFilter("abc", names: ["abc"], expectedNames: ["abc"])
    checkSearchFilter("abc", names: ["abc","abc"], expectedNames: ["abc","abc"])
    checkSearchFilter("abc", names: ["abc","abc", "def"], expectedNames: ["abc","abc"])
    checkSearchFilter("def", names: ["abc","def", "ghi"], expectedNames: ["def"])
    // etc, etc...
  }
  
  func test_searchFilter_fail_0_characters() {
    checkSearch(filter: "b", names: [], expectedNames: [])
  }
  
  func test_searchFilter_fail_1_character() {
    checkSearch(filter: "b", names: ["acd"], expectedNames: [])
  }
  
  func test_searchFilter_fail_3_characters() {
    checkSearch(filter: "b", names: ["acd", "efg", "hij"], expectedNames: [])
  }
  
  func test_noFilter_seasonCount_1_Character() {
    // multiple tests here, naming the tests individually would be messy...
    checkSeasonCount([[]], expectedSeasonCount: 0)
    checkSeasonCount([[1]], expectedSeasonCount: 1)
    checkSeasonCount([[3]], expectedSeasonCount: 3)
    checkSeasonCount([[1,2,5]], expectedSeasonCount: 5)
    checkSeasonCount([[5,2,1]], expectedSeasonCount: 5)
    checkSeasonCount([[1,5,2]], expectedSeasonCount: 5)
    // etc, etc...
  }
  
  func test_noFilter_seasonCount_2_Characters() {
    // multiple tests here, naming the tests individually would be messy...
    checkSeasonCount([[],[]], expectedSeasonCount: 0)
    checkSeasonCount([[],[1]], expectedSeasonCount: 1)
    checkSeasonCount([[1],[1]], expectedSeasonCount: 1)
    checkSeasonCount([[1],[3]], expectedSeasonCount: 3)
    checkSeasonCount([[1],[1,2,5]], expectedSeasonCount: 5)
    checkSeasonCount([[1],[5,2,1]], expectedSeasonCount: 5)
    checkSeasonCount([[1],[1,5,2]], expectedSeasonCount: 5)
    // etc, etc...
  }
  
  func test_noFilter_seasonCount_3_Characters() {
    // multiple tests here, naming the tests individually would be messy...
    checkSeasonCount([[],[],[]], expectedSeasonCount: 0)
    checkSeasonCount([[],[],[1]], expectedSeasonCount: 1)
    checkSeasonCount([[1],[1],[1]], expectedSeasonCount: 1)
    checkSeasonCount([[3],[1],[3]], expectedSeasonCount: 3)
    checkSeasonCount([[5],[1],[1,2,5]], expectedSeasonCount: 5)
    checkSeasonCount([[5],[1],[5,2,1]], expectedSeasonCount: 5)
    checkSeasonCount([[5],[1],[1,5,2]], expectedSeasonCount: 5)
    // etc, etc...
  }
  
  func test_seasonFilter_success() {
    // multiple tests here, naming the tests individually would be messy...
    checkSeasonFilter(2, namesAndSeasons: [("a",[1,3,4]), ("b",[1]), ("c",[3])], expectedNames: [])
    checkSeasonFilter(2, namesAndSeasons: [("a",[1,2,3]), ("b",[1]), ("c",[3])], expectedNames: ["a"])
    checkSeasonFilter(2, namesAndSeasons: [("a",[1,2,3]), ("b",[2,3,4]), ("c",[3])], expectedNames: ["a","b"])
    // etc, etc...
  }
  
  func test_seasonFilter_fail() {
    // multiple tests here, naming the tests individually would be messy...
    checkSeasonFilter(4, namesAndSeasons: [], expectedNames: [])
    checkSeasonFilter(4, namesAndSeasons: [("a",[])], expectedNames: [])
    checkSeasonFilter(4, namesAndSeasons: [("a",[1,2,3])], expectedNames: [])
    checkSeasonFilter(4, namesAndSeasons: [("a",[1,2,3]), ("b",[1])], expectedNames: [])
    checkSeasonFilter(4, namesAndSeasons: [("a",[1,2,3]), ("b",[2,3]), ("c",[3])], expectedNames: [])
    // etc, etc...
  }
  
  private func checkCharacterCount(_ count: Int,
                                   file: StaticString = #file, line: UInt = #line) {
    var characters: Characters = []
    for i in 0..<count { characters.append(getCharacter(char_id: i))}
    mockApi.loadCharactersToReturn = characters
    
    let presenter = CharactersPresenter(api: mockApi)
    presenter.managedView = mockCharactersVC
    presenter.start()
    
    XCTAssertEqual(presenter.characterCount, count, file: file, line: line)
  }

  private func checkSeasonCount(_ seasons: [[Int]],
                                expectedSeasonCount: Int,
                                file: StaticString = #file, line: UInt = #line) {
    var characters: Characters = []
    for i in 0..<seasons.count { characters.append(getCharacter(char_id: i, appearance: seasons[i]))}
    mockApi.loadCharactersToReturn = characters
    
    let presenter = CharactersPresenter(api: mockApi)
    presenter.managedView = mockCharactersVC
    presenter.start()
    
    XCTAssertEqual(presenter.seasonCount, expectedSeasonCount, file: file, line: line)
  }

  private func checkSearchFilter(_ searchFilter: String,
                                 names: [String],
                                 expectedNames: [String],
                                 file: StaticString = #file, line: UInt = #line) {
    var characters: Characters = []
    for i in 0..<names.count { characters.append(getCharacter(char_id: i, name: names[i]))}
    mockApi.loadCharactersToReturn = characters
    
    let presenter = CharactersPresenter(api: mockApi)
    presenter.managedView = mockCharactersVC
    presenter.start()
    
    presenter.searchFilter = searchFilter
    
    let filteredNames: [String] = presenter.filteredCharacters?.compactMap{$0.name} ?? []
    XCTAssertEqual(filteredNames, expectedNames, file: file, line: line)
  }

  private func checkSeasonFilter(_ seasonFilter: Int,
                                 namesAndSeasons: [(name: String, seasons: [Int])],
                                 expectedNames: [String],
                                 file: StaticString = #file, line: UInt = #line) {
    var characters: Characters = []
    for i in 0..<namesAndSeasons.count { characters.append(getCharacter(char_id: i, name: namesAndSeasons[i].name, appearance: namesAndSeasons[i].seasons))}
    mockApi.loadCharactersToReturn = characters
    
    let presenter = CharactersPresenter(api: mockApi)
    presenter.managedView = mockCharactersVC
    presenter.start()
    
    presenter.seasonFilter = seasonFilter
    
    let filteredNames: [String] = presenter.filteredCharacters?.compactMap{$0.name} ?? []
    XCTAssertEqual(filteredNames, expectedNames, file: file, line: line)
  }

  private func checkSearch(filter searchFilter: String,
                           names: [String],
                           expectedNames: [String],
                           file: StaticString = #file, line: UInt = #line) {
    var characters: Characters = []
    for i in 0..<names.count { characters.append(getCharacter(char_id: i, name: names[i]))}
    mockApi.loadCharactersToReturn = characters
    
    let presenter = CharactersPresenter(api: mockApi)
    presenter.managedView = mockCharactersVC
    presenter.start()
    
    presenter.searchFilter = searchFilter
    
    let filteredNames: [String] = presenter.filteredCharacters?.compactMap{$0.name} ?? []
    XCTAssertEqual(filteredNames, expectedNames, file: file, line: line)
  }


  private func getCharacter(char_id: Int = Defaults.char_id,
                            name: String = Defaults.name,
                            birthday: String = Defaults.birthday,
                            occupation: [String] = Defaults.occupation,
                            img: String = Defaults.img,
                            status: String = Defaults.status,
                            nickname: String = Defaults.nickname,
                            appearance: [Int]? = Defaults.appearance,
                            portrayed: String = Defaults.portrayed,
                            category: String = Defaults.category,
                            better_call_saul_appearance: [Int] = Defaults.better_call_saul_appearance) -> BBCharacter {
    
    return BBCharacter(char_id: char_id, name: name, birthday: birthday, occupation: occupation, img: img, status: status, nickname: nickname, appearance: appearance,portrayed: portrayed, category: category, better_call_saul_appearance: better_call_saul_appearance)
  }
  
  private enum Defaults {
    static let char_id: Int = 1
    static let name: String = "name"
    static let birthday: String = "birthday"
    static let occupation: [String] = ["occupation1"]
    static let img: String = "http://xyz.com/path/img.jpg"
    static let status: String = "status"
    static let nickname: String = "nickname"
    static let appearance: [Int]? = [1]
    static let portrayed: String = "portrayed"
    static let category: String = "category"
    static let better_call_saul_appearance: [Int] = [1]
  }
}
