//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/22/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

  var timelineDelegate: TimelineViewController?
  var inReplyToStatusID: Int?

  private let twitterClient: TwitterClient = TwitterClient.instance

  private var currentUser: User {
    get {
      return User.currentUser
    }
  }

  private lazy var closeButton: UIButton = UIButton()
  private lazy var tweetButton: UIButton = UIButton()
  private lazy var characterCounter: UILabel = UILabel()
  private lazy var userAvatar: AvatarImageView = AvatarImageView()
  private lazy var userName: UIImageView = UIImageView()
  private lazy var userScreenName: UILabel = UILabel()
  private lazy var textView: ComposeTextView = ComposeTextView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()

    closeButton.setTitle("×", forState: .allZeros)
    closeButton.setTitleColor(
      kTwitterColors.Primary.color(),
      forState: .allZeros
    )
    closeButton.titleLabel!.font = UIFont(name: "HelveticaNeue", size: 36.0)

    tweetButton.setTitle("Tweet", forState: .allZeros)
    tweetButton.setTitleColor(UIColor.whiteColor(), forState: .allZeros)
    tweetButton.titleLabel!.font = UIFont(
      name: "HelveticaNeue-Bold",
      size: 15.0
    )
    tweetButton.backgroundColor = kTwitterColors.Primary.color()
    tweetButton.layer.cornerRadius = 3.0

    characterCounter.font = UIFont(name: "HelveticaNeue", size: 15.0)
    characterCounter.textColor = kTwitterColors.SecondaryGreyer.color()

    closeButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    tweetButton.setTranslatesAutoresizingMaskIntoConstraints(false)
    characterCounter.setTranslatesAutoresizingMaskIntoConstraints(false)
    userAvatar.setTranslatesAutoresizingMaskIntoConstraints(false)
    userName.setTranslatesAutoresizingMaskIntoConstraints(false)
    userScreenName.setTranslatesAutoresizingMaskIntoConstraints(false)

    textView.delegate = self
    textViewDidChange(textView)

    view.addSubview(closeButton)
    view.addSubview(tweetButton)
    view.addSubview(characterCounter)
    view.addSubview(userAvatar)
    view.addSubview(userName)
    view.addSubview(userScreenName)
    view.addSubview(textView)

    let views = [
      "closeButton": closeButton,
      "tweet": tweetButton,
      "compose": textView,
      "characterCounter": characterCounter
    ]
    view.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-18-[closeButton(33)]",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    view.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:[characterCounter]-8-[tweet(64)]-10-|",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    view.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-10-[compose]-10-|",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    view.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-24-[tweet(33)]",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    view.addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-24-[closeButton(33)]-8-[compose]|",
        options: nil,
        metrics: nil,
        views: views
      )
    )
    view.addConstraint(
      NSLayoutConstraint(
        item: tweetButton,
        attribute: .CenterY,
        relatedBy: .Equal,
        toItem: characterCounter,
        attribute: .CenterY,
        multiplier: 1.0,
        constant: 0.0
      )
    )

    tweetButton.addTarget(
      self,
      action: "didTweet:",
      forControlEvents: .TouchDown
    )
    closeButton.addTarget(
      self,
      action: "didClose:",
      forControlEvents: .TouchDown
    )

    textView.becomeFirstResponder()
  }

  func setText(text: String) {
    textView.text = text
    textViewDidChange(textView)
  }

  func didTweet(sender: UIButton) {
    if textView.isEmpty {
      return
    }

    let status = Status(
      id: nil,
      text: textView.text,
      user: User.currentUser,
      retweetedStatus: nil,
      createdAt: NSDate(),
      retweetCount: 0,
      retweeted: false,
      inReplyToStatusID: inReplyToStatusID,
      favorited: false
    )
    twitterClient.updateStatus(
      status,
      success: { (response: AnyObject) -> Void in
        // TODO update status
      },
      failure: { (error: NSError) -> Void in
        // Handle error
      }
    )
    timelineDelegate?.didAddStatus(status)
    dismissViewControllerAnimated(true, completion: nil)
  }

  func didClose(sender: UIButton) {
    dismissViewControllerAnimated(true, completion: nil)
  }

  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange,
    replacementText text: String) -> Bool {
    let charCount = countElements(textView.text!) - range.length +
      countElements(text)

    return charCount <= 140
  }

  func textViewDidChange(textView: UITextView) {
    let tv = self.textView

    if tv.isEmpty {
      tweetButton.alpha = 0.6
      tv.togglePlaceholder(true)
    } else {
      tweetButton.alpha = 1.0

      tv.togglePlaceholder(false)
    }

    characterCounter.text = String(140 - countElements(textView.text))
  }
}