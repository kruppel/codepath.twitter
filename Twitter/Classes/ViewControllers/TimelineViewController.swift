//
//  HomeTimelineViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource {

  internal let twitterClient: TwitterClient = TwitterClient.instance
  internal let notificationCenter: NSNotificationCenter =
  NSNotificationCenter.defaultCenter()

  lazy internal var statuses: [Status] = []
  lazy internal var statusesTableView: UITableView = UITableView()
  lazy internal var isFetching: Bool = false
  lazy internal var isExhausted: Bool = false
  lazy internal var refreshControl: UIRefreshControl = UIRefreshControl()

  lazy internal var activityIndicator: UIActivityIndicatorView =
  UIActivityIndicatorView(activityIndicatorStyle: .Gray)
  internal var menuButton: UIBarButtonItem?
  internal var composeButton: UIBarButtonItem?

  internal var parameters: [String:NSObject] {
    get {
      var parameters: [String:NSObject] = [:]

      if statuses.count > 0 {
        let id = statuses[statuses.endIndex - 1].id

        parameters["max_id"] = id
      }

      return parameters
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let navigationBar = navigationController!.navigationBar
    navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
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


    menuButton = UIBarButtonItem(
      image: UIImage(named: "MenuButton"),
      style: .Plain,
      target: self,
      action: "toggleMenu:"
    )
    menuButton!.tintColor = UIColor.whiteColor()
    navigationItem.leftBarButtonItem = menuButton

    composeButton = UIBarButtonItem(
      image: UIImage(named: "ComposeButton"),
      style: .Plain,
      target: self,
      action: "compose:"
    )
    composeButton!.tintColor = UIColor.whiteColor()
    navigationItem.rightBarButtonItem = composeButton
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

      notificationCenter.postNotificationName("menu:toggle", object: false)
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
    isFetching = true
    activityIndicator.startAnimating()
  }

  func didFetchTimeline(response: AnyObject!) {
    if (response.count == 0) {
      isExhausted = true
    }

    isFetching = false
    activityIndicator.stopAnimating()
    statuses += map(response as [AnyObject], { Status.create($0) })
    statusesTableView.reloadData()
  }

  func toggleMenu(sender: UIBarButtonItem?) {
    notificationCenter.postNotificationName("menu:toggle", object: nil)
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
    self.statuses = []
    fetchTimeline({ (response: AnyObject) in
      self.didFetchTimeline(response)
      self.refreshControl.endRefreshing()
    })
  }
}