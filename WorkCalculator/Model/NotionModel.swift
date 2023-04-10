//
//  NotionModel.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/24.
//

import UIKit

import UPsKit

final class NotionModel {
  
  let tag: NotionTag
  var messageList: [String]
  
  init(tag: NotionTag, messageList: [String]) {
    self.tag = tag
    self.messageList = messageList
  }
}

enum NotionTag: String {
  
  case white
  case red
  case blue
  case cyan
  case gray
  
  var textColor: UIColor {
    switch self {
    case .gray: return UIColor.white
    default: return UIColor.gray900
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .white: return UIColor.gray200
    case .red: return UIColor.red.withAlphaComponent(0.1)
    case .blue: return UIColor.blue.withAlphaComponent(0.1)
    case .cyan: return UIColor.cyan.withAlphaComponent(0.1)
    case .gray: return UIColor.black
    }
  }
}



struct NotionData: Codable {
  
  fileprivate let results: [Result]
  
  var data: [NotionModel] {
    let initData = [
      NotionModel(tag: .white, messageList: []),
      NotionModel(tag: .red, messageList: []),
      NotionModel(tag: .blue, messageList: []),
      NotionModel(tag: .cyan, messageList: []),
      NotionModel(tag: .gray, messageList: [])
    ]
    
    for i in self.results {
      guard
        let tagContent = i.properties?.tagContent,
        let tag = NotionTag(rawValue: tagContent),
        let messageContent = i.properties?.messageContent
      else {
        continue
      }
      
      let model = initData
        .filter { $0.tag == tag }
        .first
        
      model?.messageList.append(messageContent)
    }
    
    return initData
  }
}

fileprivate struct Result: Codable {
  
  let properties: Properties?
}

fileprivate struct Properties: Codable {
  
  let tag: Tag?
  let message: Message?
  
  
  
  var tagContent: String? {
    self.tag?.multiSelect?.first?.name
  }
  
  var messageContent: String? {
    self.message?.title?.first?.text?.content
  }
}



// MARK: - Tag

fileprivate struct Tag: Codable {
  
  let multiSelect: [MultiSelect]?
  
  enum CodingKeys: String, CodingKey {
    case multiSelect = "multi_select"
  }
}

fileprivate struct MultiSelect: Codable {
  
  let id: String?
  let name: String?
  let color: String?
}



// MARK: - Message

fileprivate struct Message: Codable {
  
  let title: [Title]?
}

fileprivate struct Title: Codable {
  
  let text: Text?
}

fileprivate struct Text: Codable {
  
  let content: String?
}
