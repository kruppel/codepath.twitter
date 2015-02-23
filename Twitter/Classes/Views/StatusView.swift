//
//  StatusView.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/23/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class StatusView: UIView {

  lazy internal var userAvatar: AvatarImageView = AvatarImageView()
  lazy internal var userName: UILabel = UILabel()
  lazy internal var userScreenName: UILabel = UILabel()
  lazy internal var absoluteTimestamp: UILabel = UILabel()
  lazy internal var statusText: UILabel = UILabel()

  internal var constraintFormats: [String] {
    get {
      return [
        "V:|-10-[avatar(48)]-20-[status]-10-[ts]-20-|",
        "V:|-10-[name]-3-[screenname]",
        "H:|-10-[avatar(48)]-8-[name]",
        "H:|-10-[avatar(48)]-8-[screenname]",
        "H:|-10-[status]-10-|",
        "H:|-10-[ts]-10-|"
      ]
    }
  }

  internal var viewsDict: NSDictionary {
    get {
      return [
        "avatar": userAvatar,
        "name": userName,
        "screenname": userScreenName,
        "ts": absoluteTimestamp,
        "status": statusText
      ]
    }
  }

  var status: Status? {
    didSet {
      let user = status!.user

      userAvatar.setImageWithURLRequestOrCache(user.profileImageURL!,
        success: nil,
        error: nil
      )
      userAvatar.backgroundColor = UIColor.blackColor()
      userName.text = user.name
      userScreenName.text = "@\(user.screenName)"
      absoluteTimestamp.text = status!.createdAt!.absolute
      statusText.text = status!.text
      highlightScreenNames()

      setNeedsLayout()
      layoutIfNeeded()
      let size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
      frame = CGRectMake(
        0,
        0,
        size.width,
        size.height
      )
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = UIColor.whiteColor()

    userName.font = UIFont(name: "HelveticaNeue-Bold", size: 15.0)
    userScreenName.font = UIFont(name: "HelveticaNeue", size: 13.0)
    absoluteTimestamp.font = UIFont(name: "HelveticaNeue", size: 13.0)
    statusText.font = UIFont(name: "HelveticaNeue-Light", size: 22.0)

    userName.textColor = kTwitterColors.SecondaryBlack.color()
    userScreenName.textColor = kTwitterColors.SecondaryGreyer.color()
    absoluteTimestamp.textColor = kTwitterColors.SecondaryGreyer.color()
    statusText.textColor = kTwitterColors.SecondaryBlack.color()

    userName.numberOfLines = 0
    userScreenName.numberOfLines = 0
    absoluteTimestamp.numberOfLines = 0
    statusText.numberOfLines = 0

    addSubview(userAvatar)
    addSubview(userScreenName)
    addSubview(userName)
    addSubview(absoluteTimestamp)
    addSubview(statusText)

    createAndAddConstraints()
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func addSubview(view: UIView) {
    super.addSubview(view)

    view.setTranslatesAutoresizingMaskIntoConstraints(false)
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

    statusText.setContentHuggingPriority(2000.0, forAxis: .Vertical)
  }

  func highlightScreenNames() {
    let text = statusText.text!
    let highlighted = NSMutableAttributedString(string: text)
    let words: [String] = text.componentsSeparatedByString(" ")

    for word in words {
      if word.hasPrefix("@") {
        let range = text.rangeOfString(word)!
        let start = distance(text.startIndex, range.startIndex)

        highlighted.addAttribute(
          NSForegroundColorAttributeName,
          value: kTwitterColors.Primary.color(),
          range: NSMakeRange(start, start + countElements(word))
        )
      }
    }
    
    statusText.attributedText = highlighted
  }
}