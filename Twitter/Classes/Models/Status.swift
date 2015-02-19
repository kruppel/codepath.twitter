//
//  Status.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

struct Status {
  let id: Int!
  let text: String!
  let user: User

  static func create(data: AnyObject) -> Status {
    let json = JSON(data)

    return Status(
      id: json["id"].int,
      text: json["text"].string,
      user: User.create(json["user"].object)
    )
  }
}
