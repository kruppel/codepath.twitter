//
//  UIImageView+Twitter.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/20/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

extension UIImageView {

  func setImageWithURLRequestOrCache(url: NSURL,
    success: ((image: UIImage) -> Void)!, error: ((error: NSError) -> Void)!) {
    let request = NSMutableURLRequest(URL: url)
    let cached = UIImageView.sharedImageCache().cachedImageForRequest(
      request as NSURLRequest
    )

    if (cached != nil) {
      self.image = cached
    } else {
      request.addValue("image/*", forHTTPHeaderField: "Accept")
      alpha = 0

      let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
      dispatch_async(dispatch_get_global_queue(priority, 0), {
        self.setImageWithURLRequest(request, placeholderImage: nil,
          success: { (request, response, image) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
              UIView.animateWithDuration(0.4, animations: {
                self.alpha = 1
              })
              self.image = image
            })
          },
          failure: nil
        )
      })
    }
  }
}