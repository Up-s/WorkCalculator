//
//  FirebaseError.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

enum FirebaseError: Error {
  
  case networkError
  case firebaseError(Error)
  case parsingError
  case emptyData
}
