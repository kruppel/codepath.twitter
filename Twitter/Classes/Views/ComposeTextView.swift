//
//  ComposeTextView.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/22/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

  private lazy var placeholderLabel: UILabel = UILabel()

  var isEmpty: Bool {
    get {
      return text == ""
    }
  }

  override init() {
    super.init()

    setTranslatesAutoresizingMaskIntoConstraints(false)
    textColor = kTwitterColors.SecondaryBlack.color()
    font = UIFont(name: "HelveticaNeue", size: 16.0)
    placeholderLabel.text = "What's happening?"
    placeholderLabel.font = font
    placeholderLabel.textColor = kTwitterColors.SecondarySilver.color()
    placeholderLabel.hidden = false
    placeholderLabel.numberOfLines = 0

    addSubview(placeholderLabel)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder: has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
  }

  func togglePlaceholder(visible: Bool) {
    if visible {
      placeholderLabel.hidden = false
      placeholderLabel.frame = CGRectMake(5, 6, 300, 24)
      placeholderLabel.alpha = 1.0
    } else {
      placeholderLabel.hidden = true
      placeholderLabel.frame = CGRectZero
      placeholderLabel.alpha = 0.0
    }
  }
}