//
//  Colors.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

enum kTwitterColors {
  case Primary
  case SecondaryBlack
  case SecondaryGrey
  case SecondaryGreyer
  case SecondarySilver
  case SecondaryOffWhite
  case SecondaryWhite

  func color() -> UIColor {
    var hex: Int

    switch self {
      case Primary:
        hex = 0x55ACEE
      case .SecondaryBlack:
        hex = 0x292F33
      case .SecondaryGrey:
          hex = 0x66757F
      case .SecondaryGreyer:
        hex = 0x8899A6
      case .SecondarySilver:
        hex = 0xCCD6DD
      case .SecondaryOffWhite:
        hex = 0xE1E8ED
      case SecondaryWhite:
        hex = 0xF5F8FA
    }

    return UIColor(hex: hex)
  }
}
