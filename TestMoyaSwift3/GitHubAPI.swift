//
//  GitHubAPI.swift
//  TestMoyaSwift3
//
//  Created by Suraphan Laokondee on 10/10/2559 BE.
//  Copyright © 2559 Suraphan Laokondee. All rights reserved.
//

import Foundation
import Moya

let GitHubEndpointClosure = { (target: GitHub) -> Endpoint<GitHub> in
  let endpoint: Endpoint<GitHub> = Endpoint<GitHub>(URL: url(target),
                                                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                                                            method: target.method,
                                                            parameters: target.parameters)
  
  return endpoint
}


let provider = MoyaProvider<GitHub>(endpointClosure: GitHubEndpointClosure, stubClosure: MoyaProvider.NeverStub)

let unitTestProvider = MoyaProvider<GitHub>(endpointClosure: GitHubEndpointClosure, stubClosure: MoyaProvider.DelayedStub(3))


public enum GitHub {
  case userProfile(String)
  case userRepositories(String)
}

extension GitHub: TargetType {

  public var baseURL: URL { return URL(string: "https://api.github.com")! }
  
  public var path: String {
    switch self {
    case .userProfile(let name):
      return "/users/\(name.urlEscapedString)"
    case .userRepositories(let name):
      return "/users/\(name.urlEscapedString)/repos"
    }
  }
  
  public var method: Moya.Method {
    return .GET
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .userRepositories(_):
      return ["sort": "pushed" as AnyObject]
    default:
      return nil
    }
  }
  
  public var task: Task {
    return .request
  }
  
  public var sampleData: Data {
    switch self {
    case .userProfile(let name):
      return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
    case .userRepositories(_):
      return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
    }
  }
}

private extension String {
  var urlEscapedString: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

public func url(_ route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}
