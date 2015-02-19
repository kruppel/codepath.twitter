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

  func fetchHomeTimeline(#success: (response: AnyObject) -> Void,
    error: (error: NSError) -> Void) {
    GET("1.1/statuses/home_timeline.json",
      parameters: nil,
      success: {(operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        success(response: response)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        // Handle error
      }
    )
  }

  class var instance: TwitterClient {
    return _TwitterClientInstance
  }
}