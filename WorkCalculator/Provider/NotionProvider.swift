//
//  NotionProvider.swift
//  WorkCalculator
//
//  Created by YouUp Lee on 2023/02/24.
//

import Foundation

import RxCocoa
import RxSwift

final class NotionProvider {
  
  class func getMessage() -> Observable<Void> {
    Observable<Void>.create { observer -> Disposable in
      var request = URLRequest(url: URL(string: "https://api.notion.com/v1/databases/e91c0085966940669f307745a333fe2b/query")!,timeoutInterval: Double.infinity)
      request.addValue("Bearer secret_DEaqwcrCuw5MYiOtU82SsMJEEhy4p1SD2fwgA5PRElO", forHTTPHeaderField: "Authorization")
      request.addValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
      request.addValue("__cf_bm=OD7yKiXpRQRZeuV4nwOU3EdhIe72cuH9w.5Tdqjy3FM-1677223967-0-AVmLKM7XhbsdYPIJQjzo0qBLGolVXpp7T4LzroRJ37xkM4bhyvm5Ey5xH2vnNMDN7TV/4VVVtmpepoUV3vunL50=", forHTTPHeaderField: "Cookie")
      
      request.httpMethod = "POST"
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
          print(String(describing: error))
          observer.onError(error)
          
        } else {
          guard
            let data = data,
            let message = try? JSONDecoder().decode(NotionData.self, from: data)
          else {
            observer.onNext(())
            observer.onCompleted()
            return
          }
          
          AppManager.shared.message = message.data
          
          observer.onNext(())
          observer.onCompleted()
        }
      }
      
      task.resume()
      
      return Disposables.create()
    }
  }
}
