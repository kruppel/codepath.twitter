//
//  StatusViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/23/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class StatusViewController: UIViewController, UITableViewDelegate {

  private var status: Status?

  private var statusView: StatusView?
  lazy private var statusesTableView: UITableView = UITableView(
    frame: CGRectZero,
    style: .Grouped
  )

  override init() {
    super.init()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  convenience init(status: Status) {
    self.init()

    self.status = status
    navigationItem.title = "Tweet"
    view.backgroundColor = kTwitterColors.SecondaryWhite.color()

    view.addSubview(statusesTableView)

    statusesTableView.rowHeight = UITableViewAutomaticDimension;
    statusesTableView.estimatedSectionHeaderHeight = 100.0
    statusesTableView.layoutMargins = UIEdgeInsetsZero;
    statusesTableView.separatorInset = UIEdgeInsetsZero
    statusesTableView.delegate = self
    statusesTableView.frame = view.bounds
    statusesTableView.backgroundColor = kTwitterColors.SecondaryWhite.color()
    statusesTableView.separatorColor = kTwitterColors.SecondaryOffWhite.color()
    statusesTableView.registerClass(StatusTableViewCell.self,
      forCellReuseIdentifier: "StatusTableViewCell")
    statusesTableView.registerClass(RetweetStatusTableViewCell.self,
      forCellReuseIdentifier: "RetweetStatusTableViewCell")

    statusView = StatusView(frame: CGRectMake(0, 0, view.frame.width, 250))
    
    if (status.retweetedStatus != nil) {
      statusView!.status = status.retweetedStatus!.value
    } else {
      statusView!.status = status
    }

    statusesTableView.tableHeaderView = statusView

    statusesTableView.tableFooterView = UIView(frame: CGRectZero)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
