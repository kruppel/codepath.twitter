//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController {
  private let twitterClient = TwitterClient.instance

  override func viewDidLoad() {
    super.viewDidLoad()

    SVProgressHUD.show()
    //    twitterClient.fetchHomeTimeline()
  }
}