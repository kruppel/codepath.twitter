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

  func getAccountVerifyCredentials(#success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
    GET("1.1/account/verify_credentials.json",
      parameters: nil,
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        _ = success?(response: response)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        // Handle error
      }
    )
  }

  func getStatusesHomeTimeline(parameters: [String: AnyObject]?,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
    GET("1.1/statuses/home_timeline.json",
      parameters: parameters,
      success: { (operation: AFHTTPRequestOperation!,
        response: AnyObject!) -> Void in
        _ = success?(response: response)
      },
      failure: { (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void in
        // Handle error
        _ = failure?(error: error)
      }
    )
  }

  func getStatusesMentionsTimeline(parameters: [String: AnyObject]?,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
      GET("1.1/statuses/mentions_timeline.json",
        parameters: parameters,
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(response: response)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          // Handle error
          _ = failure?(error: error)
        }
      )
  }


  func getStatusesUserTimeline(parameters: [String: AnyObject]?,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
      GET("1.1/statuses/user_timeline.json",
        parameters: parameters,
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(response: response)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          // Handle error
          _ = failure?(error: error)
        }
      )
  }

  func updateStatus(status: Status,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
      var parameters = [
        "status": status.text
      ]

      if status.inReplyToStatusID? != nil {
        parameters["in_reply_to_status_id"] = String(status.inReplyToStatusID!)
      }

      POST("1.1/statuses/update.json",
        parameters: parameters,
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(response: response)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          // Handle error
          _ = failure?(error: error)
        }
      )
  }

  func retweetStatus(id: String,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
      POST("1.1/statuses/retweet/\(id).json",
        parameters: nil,
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(response: response)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          // Handle error
          _ = failure?(error: error)
        }
      )
  }

  func createFavorite(id: String,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
      POST("1.1/favorites/create.json",
        parameters: ["id": id],
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(response: response)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          // Handle error
          _ = failure?(error: error)
        }
      )
  }

  func destroyFavorite(id: String,
    success: ((response: AnyObject) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
      DELETE("1.1/favorites/destroy.json",
        parameters: ["id": id],
        success: { (operation: AFHTTPRequestOperation!,
          response: AnyObject!) -> Void in
          _ = success?(response: response)
        },
        failure: { (operation: AFHTTPRequestOperation!,
          error: NSError!) -> Void in
          // Handle error
          _ = failure?(error: error)
        }
      )
  }

  class var instance: TwitterClient {
    return _TwitterClientInstance
  }
}