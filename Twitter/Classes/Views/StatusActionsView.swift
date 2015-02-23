//
//  StatusActionsView.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/23/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class StatusActionsView: UIView {

  var delegate: StatusTableViewCell? {
    didSet {
      replyButton.addTarget(delegate, action: "didReply:", forControlEvents: .TouchDown)
      retweetButton.addTarget(delegate, action: "didRetweet:", forControlEvents: .TouchDown)
      favoriteButton.addTarget(delegate, action: "didFavorite:", forControlEvents: .TouchDown)

      updateRetweetButtonState()
      updateFavoriteButtonState()
    }
  }

  private lazy var replyButton: UIButton = UIButton()
  private lazy var retweetButton: UIButton = UIButton()
  private lazy var favoriteButton: UIButton = UIButton()
  private lazy var retweetCountLabel: UILabel = UILabel()
  private lazy var favoriteCountLabel: UILabel = UILabel()

  override init() {
    super.init()

    replyButton.setBackgroundImage(
      UIImage(named: "ReplyIcon"),
      forState: .allZeros
    )
    retweetButton.setBackgroundImage(
      UIImage(named: "RetweetIcon"),
      forState: .allZeros
    )
    favoriteButton.setBackgroundImage(
      UIImage(named: "FavoriteIcon"),
      forState: .allZeros
    )

    addSubview(replyButton)
    addSubview(retweetButton)
    addSubview(favoriteButton)
//    addSubview(retweetCountLabel)
//    addSubview(favoriteCountLabel)

    let views = [
      "reply": replyButton,
      "retweet": retweetButton,
      "favorite": favoriteButton,
      "retweetCount": retweetCountLabel,
      "favoriteCount": favoriteCountLabel
    ]
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[reply(16)]",
      options: nil,
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[retweet(16)]",
      options: nil,
      metrics: nil,
      views: views
    ))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "V:|[favorite(16)]",
      options: nil,
      metrics: nil,
      views: views
    ))
//    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//      "V:|[retweetCount]",
//      options: nil,
//      metrics: nil,
//      views: views
//    ))
//    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
//      "V:|[favoriteCount]",
//      options: nil,
//      metrics: nil,
//      views: views
//    ))
    addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
      "H:|[reply(16)]-48-[retweet(16)]-48-[favorite(16)]",
      options: nil,
      metrics: nil,
      views: views
    ))
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func addSubview(view: UIView) {
    view.setTranslatesAutoresizingMaskIntoConstraints(false)
    super.addSubview(view)
  }

  func updateRetweetButtonState() {
    let status = self.delegate!.status!
    let retweetCount = status.retweetCount

    if status.retweeted! {
      retweetButton.setBackgroundImage(
        UIImage(named: "RetweetedIcon"),
        forState: .allZeros
      )

      return
    }

    if status.user.id == User.currentUser?.id {
      retweetButton.enabled = false
      retweetButton.alpha = 0.6
    } else {
      retweetButton.enabled = true
      retweetButton.alpha = 1.0
    }

    retweetButton.setBackgroundImage(
      UIImage(named: "RetweetIcon"),
      forState: .allZeros
    )
  }

  func updateFavoriteButtonState() {
    let status = self.delegate!.status!

    if status.favorited! {
      favoriteButton.setBackgroundImage(
        UIImage(named: "FavoritedIcon"),
        forState: .allZeros
      )
    } else {
      favoriteButton.setBackgroundImage(
        UIImage(named: "FavoriteIcon"),
        forState: .allZeros
      )
    }
  }
}
