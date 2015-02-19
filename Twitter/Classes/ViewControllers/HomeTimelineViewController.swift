//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDelegate,
  UITableViewDataSource {

  private let twitterClient: TwitterClient = TwitterClient.instance
  lazy private var statuses: [Status] = []
  lazy private var statusesTableView: UITableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()

    let navigationBar = navigationController!.navigationBar
    navigationItem.title = "Home"
    navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    navigationBar.barTintColor = kColors.Twitter.color()

    statusesTableView.layoutMargins = UIEdgeInsetsZero;
    statusesTableView.separatorInset = UIEdgeInsetsZero
    statusesTableView.delegate = self
    statusesTableView.dataSource = self
    statusesTableView.frame = view.bounds
    statusesTableView.backgroundColor = UIColor.whiteColor()
    statusesTableView.registerClass(StatusTableViewCell.self,
      forCellReuseIdentifier: "StatusTableViewCell")
    view.addSubview(statusesTableView)

    SVProgressHUD.show()
    twitterClient.fetchHomeTimeline(
      success: didFetchTimeline,
      error: { (error: NSError!) -> Void in
        //
      })
  }

  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return statuses.count
  }

  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = statusesTableView.dequeueReusableCellWithIdentifier(
      "StatusTableViewCell"
    ) as StatusTableViewCell

    cell.layoutMargins = UIEdgeInsetsZero;
    cell.setStatus(statuses[indexPath.row])

    return cell
  }

  func didFetchTimeline(response: AnyObject!) {
    SVProgressHUD.dismiss()
    statuses = map(response as [AnyObject], { Status.create($0) })
    statusesTableView.reloadData()
  }
}