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
  lazy private var isFetching: Bool = false
  lazy private var isExhausted: Bool = false
  lazy private var refreshControl: UIRefreshControl = UIRefreshControl()

  lazy private var activityIndicator: UIActivityIndicatorView =
    UIActivityIndicatorView(activityIndicatorStyle: .Gray)
  private var composeButton: UIBarButtonItem?

  override func viewDidLoad() {
    super.viewDidLoad()

    let navigationBar = navigationController!.navigationBar
    navigationItem.title = "Home"
    navigationBar.layer.shadowColor = kTwitterColors.Primary.color().CGColor
    navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    navigationBar.barTintColor = kTwitterColors.Primary.color()
    navigationBar.tintColor = UIColor.whiteColor()
    navigationItem.backBarButtonItem = UIBarButtonItem(
      title: "",
      style: .Plain,
      target: nil,
      action: nil
    )

    composeButton = UIBarButtonItem(
      image: UIImage(named: "ComposeButton"),
      style: .Plain,
      target: self,
      action: "compose:"
    )
    composeButton!.tintColor = UIColor.whiteColor()
    navigationItem.rightBarButtonItem = composeButton

    statusesTableView.rowHeight = UITableViewAutomaticDimension;
    statusesTableView.estimatedRowHeight = 100.0;
    statusesTableView.layoutMargins = UIEdgeInsetsZero;
    statusesTableView.separatorInset = UIEdgeInsetsZero
    statusesTableView.delegate = self
    statusesTableView.dataSource = self
    statusesTableView.frame = view.bounds
    statusesTableView.backgroundColor = UIColor.whiteColor()
    statusesTableView.separatorColor = kTwitterColors.SecondaryOffWhite.color()
    statusesTableView.registerClass(StatusTableViewCell.self,
      forCellReuseIdentifier: "StatusTableViewCell")
    statusesTableView.registerClass(RetweetStatusTableViewCell.self,
      forCellReuseIdentifier: "RetweetStatusTableViewCell")
    statusesTableView.insertSubview(refreshControl, atIndex: 0)

    refreshControl.addTarget(
      self,
      action: "willRefresh",
      forControlEvents: .ValueChanged
    )
    view.addSubview(statusesTableView)

    activityIndicator.frame = CGRectMake(
      0,
      0,
      statusesTableView.frame.width,
      44
    )
    statusesTableView.tableFooterView = activityIndicator

    fetchTimeline(didFetchTimeline)
  }

  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return statuses.count
  }

  func tableView(tableView: UITableView,
    cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let status = statuses[indexPath.row]

    if (status.retweetedStatus != nil) {
      var cell = statusesTableView.dequeueReusableCellWithIdentifier(
        "RetweetStatusTableViewCell"
        ) as RetweetStatusTableViewCell

      cell.timelineController = self
      cell.setStatus(status)

      return cell
    } else {
      var cell = statusesTableView.dequeueReusableCellWithIdentifier(
        "StatusTableViewCell"
        ) as StatusTableViewCell

      cell.timelineController = self
      cell.setStatus(status)

      return cell
    }
  }

  func tableView(tableView: UITableView,
    didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let status = statuses[indexPath.row]
    let statusController = StatusViewController(status: status)

    statusesTableView.deselectRowAtIndexPath(indexPath, animated: false)
    navigationController?.pushViewController(
      statusController,
      animated: true
    )
  }

  func scrollViewDidScroll(scrollView: UIScrollView) {
    if isFetching || isExhausted {
      return
    }

    let tableHeight = statusesTableView.frame.height
    let offset = scrollView.contentOffset.y + tableHeight
    let limit = scrollView.contentSize.height - 300

    if (offset > limit) {
      fetchTimeline(didFetchTimeline)
    }
  }

  func fetchTimeline(completion: (response: AnyObject) -> Void) {
    var parameters: [String:NSObject] = [:]

    if statuses.count > 0 {
      let id = statuses[statuses.endIndex - 1].id

      parameters["max_id"] = id
    }

    isFetching = true
    activityIndicator.startAnimating()
    twitterClient.getStatusesHomeTimeline(
      parameters,
      success: completion,
      failure: { (error: NSError!) -> Void in
        NSLog(error.description)
      }
    )
  }

  func didFetchTimeline(response: AnyObject!) {
    if (response.count < 20) {
      isExhausted = true
    }

    isFetching = false
    activityIndicator.stopAnimating()
    statuses += map(response as [AnyObject], { Status.create($0) })
    statusesTableView.reloadData()
  }

  func compose(sender: UIBarButtonItem?) {
    _ = compose("", inReplyToStatusID: nil)
  }

  func compose(text: String, inReplyToStatusID: Int?) -> ComposeViewController {
    let controller = ComposeViewController()

    controller.timelineDelegate = self
    controller.setText(text)
    presentViewController(controller, animated: true, completion: nil)

    return controller
  }

  func didAddStatus(status: Status) {
    statuses.insert(status, atIndex: 0)
    statusesTableView.reloadData()
  }

  func willRefresh() {
    fetchTimeline({ (response: AnyObject) in
      self.statuses = []
      self.didFetchTimeline(response)
      self.refreshControl.endRefreshing()
    })
  }
}