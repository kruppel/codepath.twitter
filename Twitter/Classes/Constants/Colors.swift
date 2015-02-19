//
//  Colors.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

enum kColors {
  case Twitter

  func color() -> UIColor {
    var hex: Int

    switch self {
      case Twitter:
        hex = 0x55ACEE
    }

    return UIColor(hex: hex)
  }
}
