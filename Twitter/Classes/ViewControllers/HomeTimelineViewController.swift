//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class HomeTimelineViewController: TimelineViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Home"
  }

  override func fetchTimeline(completion: (response: AnyObject) -> Void) {
    super.fetchTimeline(completion)
    twitterClient.getStatusesHomeTimeline(
      parameters,
      success: completion,
      failure: { (error: NSError!) -> Void in
        NSLog(error.description)
      }
    )
  }
}