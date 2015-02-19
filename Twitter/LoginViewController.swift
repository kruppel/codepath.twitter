//
//  LoginViewController.swift
//
//
//  Created by Kurt Ruppel on 2/16/15.
//
//

import UIKit

class LoginViewController: UIViewController {
  private let twitterClient = TwitterClient.instance
  private let loginButton:UIButton = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()

    loginButton.frame = CGRectMake((view.bounds.width / 2) - 125, 400, 250, 40)
    loginButton.setTitle("Login with Twitter", forState: .allZeros)
    loginButton.setTitleColor(UIColor.blueColor(), forState: .allZeros)
    loginButton.addTarget(self, action: "onLogin:",
      forControlEvents: .TouchDown)

    view.addSubview(loginButton)
  }

  func onLogin(sender: UIButton!) {
    SVProgressHUD.show()
    twitterClient.requestSerializer.removeAccessToken()
    twitterClient.fetchRequestTokenWithPath("oauth/request_token",
      method: "GET", callbackURL: NSURL(string: "kruppeltwitter://oauth"),
      scope: nil, success: { (credential: BDBOAuth1Credential!) -> Void in
        let authURL = NSURL(
          string: "https://api.twitter.com/oauth/authorize?" +
          "oauth_token=\(credential.token)"
        )

        UIApplication.sharedApplication().openURL(authURL!)
      },
      { (error: NSError!) -> Void in
        // Handle error
      }
    )
  }
}