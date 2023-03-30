//
//  NetworkError.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/01/06.
//

import Foundation

enum NetworkError: Error {
  
  case emptyData
  case parsingError
  case urlError
  case firebaseError(Error)
}
