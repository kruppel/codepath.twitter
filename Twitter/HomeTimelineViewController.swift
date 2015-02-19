//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController {

  private let twitterClient: TwitterClient = TwitterClient.instance
  lazy private var statusesTableView: UITableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    statusesTableView.frame = view.bounds
    statusesTableView.backgroundColor = UIColor.whiteColor()

    SVProgressHUD.show()
    twitterClient.fetchHomeTimeline(
      success: didFetchTimeline,
      error: { (error: NSError!) -> Void in
      })
  }

  func didFetchTimeline(response: AnyObject!) {
    println(response)
  }
}