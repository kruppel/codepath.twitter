//
//  AppDelegate.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/16/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  private let twitterClient = TwitterClient.instance

  lazy var window = UIWindow(frame: UIScreen.mainScreen().bounds)

  func application(application: UIApplication, didFinishLaunchingWithOptions
    launchOptions: [NSObject: AnyObject]?) -> Bool {
      // For testing purposes:
      twitterClient.requestSerializer.removeAccessToken()
      if (twitterClient.authorized) {
        User.fetchCurrentUser(
          success: { (user) -> Void in

          },
          failure: { (error: NSError) -> Void in
            fatalError("Failed to get current user!")
          }
        )

        self.window.rootViewController = UINavigationController(
          rootViewController: HomeTimelineViewController()
        )
      } else {
        self.window.rootViewController = LoginViewController()
      }

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
            SVProgressHUD.showSuccessWithStatus("Successfully authenticated!")
            User.fetchCurrentUser(
              success: { (user) -> Void in
                _ = self.window.rootViewController?.presentViewController(
                  UINavigationController(
                    rootViewController: HomeTimelineViewController()
                  ),
                  animated: false,
                  completion: nil
                )
              },
              failure: { (error: NSError) -> Void in
                fatalError("Failed to get current user!")
              }
            )
          },
          { (err: NSError!) -> Void in
            fatalError("Failed to access token!")
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