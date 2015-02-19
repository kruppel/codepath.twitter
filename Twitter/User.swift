//
//  User.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

struct User {
  let id: Int!
  var name: String?

  static func create(data: AnyObject) -> User {
    let json = JSON(data)

    return User(
      id: json["id"].int,
      name: json["name"].string
    )
  }

  static var currentUser: User!
}