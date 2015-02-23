//
//  RetweetStatusTableViewCell.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/22/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class RetweetStatusTableViewCell: StatusTableViewCell {

  lazy internal var retweetedIcon: UIImageView = UIImageView(
    image: UIImage(named: "RetweetIcon")!
  )
  lazy internal var retweetedLabel: UILabel = UILabel()

  override internal var constraintFormats: [String] {
    get {
      return [
        "V:|-10-[retweetedIcon(16)]",
        "V:|-10-[retweeted]-10-[avatar(48)]",
        "V:|-10-[retweeted]-10-[name]-3-[status]-8-[actions(18)]-10-|",
        "V:|-10-[retweeted]-10-[ts]",
        "H:|-42-[retweetedIcon(16)]-8-[retweeted]",
        "H:|-10-[avatar(48)]-8-[name]-8-[screenname]-(>=15)-[ts]-15-|",
        "H:[avatar]-8-[status]-25-|",
        "H:[avatar]-8-[actions(180)]"
      ]
    }
  }

  override internal var viewsDict: NSDictionary {
    get {
      return [
        "avatar": userAvatar,
        "name": userName,
        "screenname": userScreenName,
        "ts": relativeTimestamp,
        "status": statusText,
        "retweeted": retweetedLabel,
        "retweetedIcon": retweetedIcon,
        "actions": actions
      ]
    }
  }

  override func addSubviews() {
    retweetedLabel.font = UIFont(name: "HelveticaNeue", size: 13.0)
    retweetedLabel.textColor = kTwitterColors.SecondaryGreyer.color()

    retweetedIcon.contentMode = .ScaleAspectFit

    retweetedIcon.setTranslatesAutoresizingMaskIntoConstraints(false)
    retweetedLabel.setTranslatesAutoresizingMaskIntoConstraints(false)

    addSubview(retweetedIcon)
    addSubview(retweetedLabel)

    super.addSubviews()
  }

  override func setStatus(status: Status) {
    retweetedLabel.text = "\(status.user.name) retweeted"
    super.setStatus(status.retweetedStatus!.value)
  }
}
