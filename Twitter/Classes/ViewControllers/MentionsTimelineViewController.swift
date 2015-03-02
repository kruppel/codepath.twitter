//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class MentionsTimelineViewController: TimelineViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Mentions"
  }

  override func fetchTimeline(completion: (response: AnyObject) -> Void) {
    super.fetchTimeline(completion)
    twitterClient.getStatusesMentionsTimeline(
      parameters,
      success: completion,
      failure: { (error: NSError!) -> Void in
        NSLog(error.description)
      }
    )
  }
}