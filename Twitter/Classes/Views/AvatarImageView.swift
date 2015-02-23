//
//  AvatarImageView.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/20/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class AvatarImageView: UIImageView {

  override init() {
    super.init()

    clipsToBounds = true
    contentMode = .ScaleAspectFill
    setTranslatesAutoresizingMaskIntoConstraints(false)
    layer.cornerRadius = 5.0
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }
}
