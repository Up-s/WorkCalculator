//
//  FirebaseError.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

enum FirebaseError: Error {
  
  case firebaseError(Error)
  case emptyData
  case parsingError
}
