//
//  AvatarImageView.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/20/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {

  var user: User?

  private let notificationCenter: NSNotificationCenter =
  NSNotificationCenter.defaultCenter()

  private var tapRecognizer: UITapGestureRecognizer!

  override init() {
    super.init()

    userInteractionEnabled = true
    clipsToBounds = true
    contentMode = .ScaleAspectFill
    setTranslatesAutoresizingMaskIntoConstraints(false)
    layer.cornerRadius = 5.0

    tapRecognizer = UITapGestureRecognizer(target: self, action: "onTap:")
    addGestureRecognizer(tapRecognizer)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  func onTap(recognizer: UITapGestureRecognizer) {
    notificationCenter.postNotificationName("user:profile", object: user?._data)
  }
}
