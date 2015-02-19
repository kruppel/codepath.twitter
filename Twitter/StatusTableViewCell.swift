//
//  StatusTableViewCell.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/19/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

  var status: Status?

  lazy private var userAvatar: UIImageView = UIImageView()
  lazy private var userName: UILabel = UILabel()
  lazy private var userHandle: UILabel = UILabel()
  lazy private var statusText: UILabel = UILabel()
  lazy private var relativeTimestamp: UILabel = UILabel()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    statusText.frame = bounds
    addSubview(statusText)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  func setStatus(status: Status) {
    self.status = status
    statusText.text = status.text
  }
}
