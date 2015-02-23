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

  private let fontName = "HelveticaNeue-Bold"

  private lazy var backgroundImage: UIImageView = UIImageView(
    image: UIImage(named: "LoginScreen")!
  )
  private lazy var headingLabel: UILabel = UILabel()
  private lazy var subheadingLabel: UILabel = UILabel()
  private lazy var loginContainer: UIView = UIView()
  private lazy var loginButton: UIButton = UIButton()

  private lazy var primaryColor: UIColor = kTwitterColors.Primary.color()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.blackColor()

    backgroundImage.alpha = 0.4
    backgroundImage.frame = view.bounds
    backgroundImage.contentMode = .ScaleAspectFill

    headingLabel.text = "Hello."
    headingLabel.textColor = UIColor.whiteColor()
    headingLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36.0)

    subheadingLabel.text = "Welcome to Twitter."
    subheadingLabel.textColor = UIColor.whiteColor()
    subheadingLabel.font = UIFont(name: "HelveticaNeue", size: 24.0)

    loginContainer.backgroundColor = UIColor.whiteColor()

    loginButton.setTitle("Login with Twitter", forState: .allZeros)
    loginButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Medium", size: 18.0)
    loginButton.setTitleColor(primaryColor, forState: .allZeros)
    loginButton.layer.borderColor = primaryColor.CGColor
    loginButton.layer.borderWidth = 1.0
    loginButton.layer.cornerRadius = 8.0
    loginButton.addTarget(self, action: "onLogin:",
      forControlEvents: .TouchDown)
    loginContainer.addSubview(loginButton)

    headingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    subheadingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
    loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    loginContainer.setTranslatesAutoresizingMaskIntoConstraints(false)

    view.addSubview(backgroundImage)
    view.addSubview(headingLabel)
    view.addSubview(subheadingLabel)
    view.addSubview(loginContainer)
    view.sendSubviewToBack(backgroundImage)

    let views = [
      "heading": headingLabel,
      "subheading": subheadingLabel,
      "login": loginContainer
    ]
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|-75-[heading]-3-[subheading]",
      options: nil,
      metrics: nil,
      views: views
    ))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:[login(100)]|",
      options: nil,
      metrics: nil,
      views: views
    ))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-30-[heading]",
      options: nil,
      metrics: nil,
      views: views
    ))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|-30-[subheading]",
      options: nil,
      metrics: nil,
      views: views
    ))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[login]|",
      options: nil,
      metrics: nil,
      views: views
    ))
    loginContainer.addConstraint(NSLayoutConstraint(
      item: loginButton,
      attribute: .CenterY,
      relatedBy: .Equal,
      toItem: loginContainer,
      attribute: .CenterY,
      multiplier: 1.0,
      constant: 0
    ))
    loginContainer.addConstraint(NSLayoutConstraint(
      item: loginButton,
      attribute: .CenterX,
      relatedBy: .Equal,
      toItem: loginContainer,
      attribute: .CenterX,
      multiplier: 1.0,
      constant: 0
    ))
    loginContainer.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:[button(250)]",
        options: nil,
        metrics: nil,
        views: ["button": loginButton]
      )
    )
    loginContainer.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[button(50)]",
        options: nil,
        metrics: nil,
        views: ["button": loginButton]
      )
    )
  }

  func onLogin(sender: UIButton!) {
    sender.backgroundColor = kTwitterColors.SecondaryOffWhite.color()
    SVProgressHUD.show()

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
        fatalError("Failed to fetch request token!")
      }
    )
  }
}