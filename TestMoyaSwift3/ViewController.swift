//
//  ViewController.swift
//  TestMoyaSwift3
//
//  Created by Suraphan Laokondee on 10/10/2559 BE.
//  Copyright © 2559 Suraphan Laokondee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
   
    userProfile("rpzzzzzz")
  }

  func userProfile(_ username: String) {
    provider.request(.userProfile(username)) { result in
      switch result {
      case let .success(response):
        do {
          if let json = try response.mapJSON() as? NSDictionary {
            print(json)
          }
        } catch {
          
        }
      case .failure(_):
          break
      }
    }
  }
}



