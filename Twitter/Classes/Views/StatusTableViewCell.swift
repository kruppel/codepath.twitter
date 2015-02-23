//
//  StatusTableViewCell.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/19/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

  private let twitterClient: TwitterClient = TwitterClient.instance

  var status: Status?

  var timelineController: HomeTimelineViewController?

  lazy internal var userAvatar: AvatarImageView = AvatarImageView()
  lazy internal var userName: UILabel = UILabel()
  lazy internal var userScreenName: UILabel = UILabel()
  lazy internal var relativeTimestamp: UILabel = UILabel()
  lazy internal var statusText: UILabel = UILabel()
  lazy internal var actions: StatusActionsView = StatusActionsView()

  internal var constraintFormats: [String] {
    get {
      return [
        "V:|-10-[avatar(48)]",
        "V:|-10-[name]-3-[status]-8-[actions(18)]-10-|",
        "V:|-10-[ts]",
        "H:|-10-[avatar(48)]-8-[name]-8-[screenname]-(>=15)-[ts]-15-|",
        "H:[avatar]-8-[status]-25-|",
        "H:[avatar]-8-[actions(180)]"
      ]
    }
  }

  internal var viewsDict: NSDictionary {
    get {
      return [
        "avatar": userAvatar,
        "name": userName,
        "screenname": userScreenName,
        "ts": relativeTimestamp,
        "status": statusText,
        "actions": actions
      ]
    }
  }

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    layoutMargins = UIEdgeInsetsZero;

    addSubviews()
    createAndAddConstraints()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  func setStatus(status: Status) {
    let user = status.user

    self.status = status

    userAvatar.setImageWithURLRequestOrCache(user.profileImageURL!,
      success: nil,
      error: nil
    )
    userName.text = user.name
    userScreenName.text = "@\(user.screenName)"
    relativeTimestamp.text = status.createdAt!.relative
    statusText.text = status.text

    if actions.delegate == nil {
      actions.delegate = self
    }

    layoutIfNeeded()
  }

  func addSubviews() {
    userName.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
    userScreenName.font = UIFont(name: "HelveticaNeue", size: 13.0)
    relativeTimestamp.font = UIFont(name: "HelveticaNeue", size: 13.0)
    statusText.font = UIFont(name: "HelveticaNeue", size: 15.0)

    userName.textColor = kTwitterColors.SecondaryBlack.color()
    userScreenName.textColor = kTwitterColors.SecondaryGreyer.color()
    relativeTimestamp.textColor = kTwitterColors.SecondaryGreyer.color()
    statusText.textColor = kTwitterColors.SecondaryBlack.color()

    userName.numberOfLines = 0
    userScreenName.numberOfLines = 0
    relativeTimestamp.numberOfLines = 0
    statusText.numberOfLines = 0

    userName.setTranslatesAutoresizingMaskIntoConstraints(false)
    userScreenName.setTranslatesAutoresizingMaskIntoConstraints(false)
    relativeTimestamp.setTranslatesAutoresizingMaskIntoConstraints(false)
    statusText.setTranslatesAutoresizingMaskIntoConstraints(false)
    actions.setTranslatesAutoresizingMaskIntoConstraints(false)

    addSubview(userAvatar)
    addSubview(userScreenName)
    addSubview(userName)
    addSubview(relativeTimestamp)
    addSubview(statusText)
    addSubview(actions)
  }

  func createAndAddConstraints() {
    let views = viewsDict

    for format in constraintFormats {
      addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat(
          format,
          options: nil,
          metrics: nil,
          views: views
        )
      )
    }

    addConstraint(
      NSLayoutConstraint(
        item: userName,
        attribute: .Baseline,
        relatedBy: .Equal,
        toItem: userScreenName,
        attribute: .Baseline,
        multiplier: 1.0,
        constant: 0.0
      )
    )
    addConstraint(
      NSLayoutConstraint(
        item: userScreenName,
        attribute: .Baseline,
        relatedBy: .Equal,
        toItem: relativeTimestamp,
        attribute: .Baseline,
        multiplier: 1.0,
        constant: 0.0
      )
    )
    relativeTimestamp.setContentCompressionResistancePriority(
      2000,
      forAxis: .Horizontal
    )
  }

  func didReply(sender: UIButton) {
    timelineController?.compose(
      "@\(status!.user.screenName) ",
      inReplyToStatusID: status!.id
    )
  }

  func didRetweet(sender: UIButton) {
    if status!.user.id == User.currentUser.id {
      return
    }

    status!.retweeted = true
    status!.retweetCount! += 1
    twitterClient.retweetStatus(
      String(status!.id!),
      success: { (response: AnyObject) -> Void in
      },
      failure: { (error: NSError) -> Void in
        // Handle error
      }
    )

    actions.updateRetweetButtonState()
  }

  func didFavorite(sender: UIButton) {
    if (status!.favorited!) {
      status!.favorited! = false
      twitterClient.destroyFavorite(
        String(status!.id!),
        success: { (response: AnyObject) -> Void in
        },
        failure: { (error: NSError) -> Void in
          // Handle error
        }
      )
    } else {
      status!.favorited! = true
      twitterClient.createFavorite(
        String(status!.id!),
        success: { (response: AnyObject) -> Void in
        },
        failure: { (error: NSError) -> Void in
          // Handle error
        }
      )
    }

    actions.updateFavoriteButtonState()
  }
}