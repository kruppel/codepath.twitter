//
//  TwitterClient.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/17/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

let kTwitterConsumerKey: String = "ZL0OF21l6lEdDPVblOZisHUQk"
let kTwitterConsumerSecret: String =
"b6lim9UmZ5z4JOnFhTlJTOImjpxkyi8iBxpLhjJjFsgaH5Wa0R"
let kTwitterBaseURL: NSURL = NSURL(string: "https://api.twitter.com")!

private let _TwitterClientInstance = TwitterClient(
  baseURL: kTwitterBaseURL,
  consumerKey: kTwitterConsumerKey,
  consumerSecret: kTwitterConsumerSecret
)

class TwitterClient: BDBOAuth1RequestOperationManager {

  func fetchHomeTimeline() {
  }

  class var instance: TwitterClient {
    return _TwitterClientInstance
  }
}