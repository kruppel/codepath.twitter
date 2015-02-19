//
//  AppDelegate.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/16/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

enum kColors {
  case Twitter

  func color() -> UIColor {
    switch self {
      case Twitter:
        return UIColor(hex: 0x55ACEE)
    }
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  private let twitterClient = TwitterClient.instance

  lazy var window = UIWindow(frame: UIScreen.mainScreen().bounds)

  func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
      window.rootViewController = LoginViewController()
      window.makeKeyAndVisible()

      return true
  }

  func application(application: UIApplication, openURL url: NSURL,
    sourceApplication: String?, annotation: AnyObject?) -> Bool {
      if url.host == "oauth" {
        twitterClient.fetchAccessTokenWithPath("oauth/access_token",
          method: "POST",
          requestToken: BDBOAuth1Credential(queryString: url.query)!,
          success: { (credential: BDBOAuth1Credential!) -> Void in
            let homeTimelineViewController = HomeTimelineViewController()

            self.twitterClient.requestSerializer.saveAccessToken(credential)
            self.twitterClient.GET("1.1/account/verify_credentials.json",
              parameters: nil,
              success: {(operation: AFHTTPRequestOperation!,
                response: AnyObject!) -> Void in
                let user = User.create(response)

                User.currentUser = user

                _ = self.window.rootViewController?.presentViewController(
                  homeTimelineViewController,
                  animated: false,
                  completion: nil
                )
              },
              failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) -> Void in
                // Handle error
              }
            )
          },
          { (err: NSError!) -> Void in
            // Handle error
          }
        )
      }

      return true
  }

  func applicationWillResignActive(application: UIApplication) {
  }

  func applicationDidEnterBackground(application: UIApplication) {
  }

  func applicationWillEnterForeground(application: UIApplication) {
  }

  func applicationDidBecomeActive(application: UIApplication) {
  }

  func applicationWillTerminate(application: UIApplication) {
  }
}