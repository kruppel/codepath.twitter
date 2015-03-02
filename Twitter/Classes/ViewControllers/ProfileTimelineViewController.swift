//
//  ProfileTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 3/2/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class ProfileHeaderView: UIView {

  lazy internal var userAvatar: AvatarImageView = AvatarImageView()
  lazy internal var userName: UILabel = UILabel()
  lazy internal var userScreenName: UILabel = UILabel()

  internal var constraintFormats: [String] {
    get {
      return [
        "V:|-10-[avatar(64)]-[name]-3-[screenname]",
        "H:|-10-[avatar(64)]",
        "H:|-10-[name]",
        "H:|-10-[screenname]"
      ]
    }
  }

  internal var viewsDict: NSDictionary {
    get {
      return [
        "avatar": userAvatar,
        "name": userName,
        "screenname": userScreenName
      ]
    }
  }

  var user: User? {
    didSet {
      let user = self.user!

      userAvatar.user = user
      userAvatar.setImageWithURLRequestOrCache(user.profileImageURL!,
        success: nil,
        failure: nil
      )
      userName.text = user.name
      userScreenName.text = "@\(user.screenName)"
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor.clearColor()

    userName.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
    userScreenName.font = UIFont(name: "HelveticaNeue", size: 13.0)

    userName.textColor = kTwitterColors.SecondaryBlack.color()
    userScreenName.textColor = kTwitterColors.SecondaryGreyer.color()

    userName.numberOfLines = 0
    userScreenName.numberOfLines = 0

    userAvatar.layer.borderColor = UIColor.whiteColor().CGColor
    userAvatar.layer.borderWidth = 5.0

    addSubview(userAvatar)
    addSubview(userScreenName)
    addSubview(userName)

    createAndAddConstraints()

    notificationCenter.addObserver(
      self,
      selector: "onNotifyUserSelect:",
      name: "user:profile",
      object: nil
    )
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func addSubview(view: UIView) {
    view.setTranslatesAutoresizingMaskIntoConstraints(false)
    super.addSubview(view)
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
  }
}

class ProfileTimelineViewController: TimelineViewController {

  lazy internal var navbarImageView: UIImageView = UIImageView()
  internal var originalHeight: CGFloat?

  lazy private var headerView: ProfileHeaderView = ProfileHeaderView(frame: CGRectMake(0, 0, self.view.bounds.width, 125))

  private var _user: User?
  var user: User! {
    get {
      return _user
    }

    set(user) {
      _user = user
      
      willRefresh()
    }
  }

  convenience init(user: User?) {
    self.init()

    if user != nil {
      self.user = user
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let navigationBar = navigationController!.navigationBar

    if user.profileBannerURL != nil {
      var priority = DISPATCH_QUEUE_PRIORITY_DEFAULT

      navigationBar.translucent = true
      navigationBar.barTintColor = kTwitterColors.SecondaryWhite.color()

      navbarImageView.setImageWithURLRequestOrCache(self.user.profileBannerURL!, success: nil, failure: nil)

      navbarImageView.clipsToBounds = true
      navbarImageView.contentMode = .ScaleAspectFill
      originalHeight = navigationBar.frame.height
      navigationBar.frame = CGRectMake(0, 0, view.bounds.width, 100)
      navbarImageView.frame = CGRectMake(0, 0, navigationBar.bounds.width, navigationBar.bounds.height + 20)
      navigationBar.addSubview(navbarImageView)

      navigationItem.leftBarButtonItem = nil
      /*
      navigationItem.leftBarButtonItem = menuButton
      navigationItem.leftBarButtonItem!.setBackButtonBackgroundVerticalPositionAdjustment(200.0, forBarMetrics: .Default)
*/
      navigationItem.rightBarButtonItem = nil
      //navigationItem.rightBarButtonItem = composeButton
    } else {
      navigationController?.view.backgroundColor = UIColor.clearColor()
      navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      navigationBar.layer.shadowColor = user.profileBackgroundColor!.CGColor
      navigationBar.barTintColor = user.profileBackgroundColor!
    }

    statusesTableView.tableHeaderView = headerView
    statusesTableView.bringSubviewToFront(headerView)
    view.bringSubviewToFront(statusesTableView)
    headerView.user = user
  }

  override func fetchTimeline(completion: (response: AnyObject) -> Void) {
    var params = parameters

    super.fetchTimeline(completion)
    params["user_id"] = user.id

    twitterClient.getStatusesUserTimeline(
      params,
      success: completion,
      failure: { (error: NSError!) -> Void in
        NSLog(error.description)
      }
    )
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)

    let navigationBar = navigationController?.navigationBar

    if navigationBar == nil {
      return
    }

    navbarImageView.removeFromSuperview()
    navigationBar!.barTintColor = kTwitterColors.Primary.color()
    navigationBar!.frame = CGRectMake(0, 0, view.bounds.width, originalHeight!)
  }
}