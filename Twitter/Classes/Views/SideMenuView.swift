//
//  SideMenuView.swift
//  Twitter
//
//  Created by Kurt Ruppel on 3/1/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class SideMenuProfileView: UIView {

  let title: String = "Profile"

  lazy private var notificationCenter: NSNotificationCenter =
    NSNotificationCenter.defaultCenter()

  var user: User? {
    get {
      return User.currentUser
    }

    set(user) {
      if user == nil {
        return
      }

      userName.text = user!.name
      userScreenName.text = user!.screenName
      userAvatar.setImageWithURLRequestOrCache(user!.profileImageURL!,
        success: nil,
        failure: nil
      )
    }
  }

  lazy private var userName: UILabel = UILabel()
  lazy private var userScreenName: UILabel = UILabel()
  lazy private var userAvatar: AvatarImageView = AvatarImageView()

  override init() {
    super.init()

    userInteractionEnabled = true

    userName.numberOfLines = 0
    userScreenName.numberOfLines = 0
    userName.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
    userScreenName.font = UIFont(name: "HelveticaNeue", size: 13.0)
    userName.textColor = kTwitterColors.SecondaryBlack.color()
    userScreenName.textColor = kTwitterColors.SecondaryGreyer.color()

    backgroundColor = kTwitterColors.SecondaryWhite.color()

    addSubview(userAvatar)
    addSubview(userName)
    addSubview(userScreenName)

    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-10-[avatar(48)]-10-|",
        options: nil,
        metrics: nil,
        views: [
          "avatar": userAvatar,
          "name": userName,
          "screenName": userScreenName
        ]
      )
    )
    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-10-[name]-3-[screenName]",
        options: nil,
        metrics: nil,
        views: [
          "avatar": userAvatar,
          "name": userName,
          "screenName": userScreenName
        ]
      )
    )
    addConstraints(
      NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-20-[avatar(48)]-10-[name]",
        options: nil,
        metrics: nil,
        views: [
          "avatar": userAvatar,
          "name": userName,
          "screenName": userScreenName
        ]
      )
    )
    addConstraint(
      NSLayoutConstraint(
        item: userName,
        attribute: .Left,
        relatedBy: .Equal,
        toItem: userScreenName,
        attribute: .Left,
        multiplier: 1.0,
        constant: 0.0
      )
    )

    notificationCenter.addObserver(
      self,
      selector: "onCurrentUserFetched:",
      name: "currentUser:fetched",
      object: nil
    )
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

  func onCurrentUserFetched(notification: NSNotification) {
    if (User.currentUser != nil) {
      user = User.currentUser
    }
  }
}

class SideMenuItemView: UIButton, UIGestureRecognizerDelegate {

  lazy var menuLabel: UILabel = UILabel()
  var title: String!

  private var _active: Bool = false
  var active: Bool {
    get {
      return _active
    }

    set(active) {
      if active {
        menuLabel.textColor = kTwitterColors.SecondaryWhite.color()
      } else {
        menuLabel.textColor = kTwitterColors.SecondaryGreyer.color()
      }

      _active = active
    }
  }

  convenience init(title: String) {
    self.init()
    self.title = title
    menuLabel.text = title

  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override init() {
    super.init()

    userInteractionEnabled = true

    backgroundColor = kTwitterColors.SecondaryBlack.color()
    menuLabel.font = UIFont(name: "HelveticaNeue-Light", size: 26.0)
    menuLabel.userInteractionEnabled = true
    active = false
    addSubview(menuLabel)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }
}

class SideMenuView: UIView, UIGestureRecognizerDelegate {

  lazy private var notificationCenter: NSNotificationCenter =
    NSNotificationCenter.defaultCenter()

  lazy var footerView: SideMenuProfileView = SideMenuProfileView()

  lazy var homeMenuItem: SideMenuItemView = SideMenuItemView(title: "Home")
  lazy var mentionsMenuItem: SideMenuItemView = SideMenuItemView(title: "Mentions")

  private var _active: SideMenuItemView?
  var active: SideMenuItemView? {
    get {
      return _active
    }

    set(active) {
      if _active != nil {
        _active!.active = false
      }

      if (active?.isKindOfClass(SideMenuItemView) != nil) {
        _active = active
        _active!.active = true
      } else {
        _active = nil
      }

    }
  }

  override init() {
    super.init()

    backgroundColor = kTwitterColors.SecondaryBlack.color()
    frame = bounds
    footerView.user = User.currentUser

    addSubview(homeMenuItem)
    addSubview(mentionsMenuItem)
    addSubview(footerView)
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    homeMenuItem.frame = CGRectMake(30, 150, bounds.width - 60, 68)
    homeMenuItem.menuLabel.frame = homeMenuItem.bounds
    mentionsMenuItem.frame = CGRectMake(30, 238, bounds.width - 60, 68)
    mentionsMenuItem.menuLabel.frame = homeMenuItem.bounds
    footerView.frame = CGRectMake(bounds.origin.x, bounds.height - 68, bounds.width, 68)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
}