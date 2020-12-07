//
//  StringExtensions.swift
//  BreakingBad
//
//  Created by Saville, Jonathan on 06/12/2020.
//

extension String {
  
  func replacingLastOccurrenceOfString(_ string: String,
                                       with replacementString: String,
                                       caseInsensitive: Bool = true) -> String {
    
    let options: String.CompareOptions = caseInsensitive ? [.backwards, .caseInsensitive] : [.backwards]

    if let range = self.range(of: string, options: options, range: nil, locale: nil) {
      return self.replacingCharacters(in: range, with: replacementString)
    }
    return self
  }
}
