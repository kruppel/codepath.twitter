//
//  NSDate+Twitter.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/20/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import Foundation

extension NSDate {

  var absolute: String {
    get {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "M/d/yyyy, H:MM a"

      return formatter.stringFromDate(self)
    }
  }

  var relative: String {
    get {
      let interval: NSTimeInterval = fabs(self.timeIntervalSinceNow)

      if (interval < 60) {
        return "now"
      } else if (interval < 3600) {
        return "\(Int(floor(interval / 60)))m"
      } else if (interval < 86400) {
        return "\(Int(floor(interval / 3600)))h"
      } else {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d/yyyy"

        return formatter.stringFromDate(self)
      }
    }
  }
}