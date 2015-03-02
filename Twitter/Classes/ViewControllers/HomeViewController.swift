//
//  HomeViewController.swift
//  Twitter
//
//  Created by Kurt Ruppel on 3/1/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

  private let notificationCenter: NSNotificationCenter =
    NSNotificationCenter.defaultCenter()

  lazy private var homeTimelineViewController: HomeTimelineViewController =
    HomeTimelineViewController()
  lazy private var mentionsTimelineViewController: MentionsTimelineViewController =
  MentionsTimelineViewController()
  private var profileTimelineViewController: ProfileTimelineViewController!
  private var homeNavigationController: UINavigationController!

  lazy private var sideMenuView: SideMenuView = SideMenuView()

  private var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
  private var panRecognizer: UIPanGestureRecognizer!
  private var tapRecognizer: UITapGestureRecognizer!
  private var draggingPoint: CGPoint!

  private let kInitialSideMenuAlpha: CGFloat = 0.95

  override func viewDidLoad() {
    super.viewDidLoad()

    profileTimelineViewController = ProfileTimelineViewController(user: User.currentUser)
    homeNavigationController = UINavigationController(
      rootViewController: homeTimelineViewController
    )
    homeNavigationController.view.frame = view.bounds
    homeNavigationController.didMoveToParentViewController(self)
    sideMenuView.active = sideMenuView.homeMenuItem
    view.addSubview(homeNavigationController.view)
    addChildViewController(homeNavigationController)

    sideMenuView.frame = CGRectMake(-250, 0, 250, view.bounds.height)
    sideMenuView.alpha = kInitialSideMenuAlpha

    let layer = homeNavigationController.view.layer
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowRadius = 10;
    layer.shadowOpacity = 0.7;
    layer.shadowPath = UIBezierPath(rect: homeNavigationController.view.bounds).CGPath
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.mainScreen().scale

    screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(
      target: self,
      action: "onScreenEdgePanLeft:"
    )
    screenEdgeRecognizer.edges = .Left
    screenEdgeRecognizer.delegate = self

    panRecognizer = UIPanGestureRecognizer(target: self, action: "onPan:")
    panRecognizer.delegate = self

    tapRecognizer = UITapGestureRecognizer(target: self, action: "onMenuTap:")
    tapRecognizer.delegate = self
    sideMenuView.addGestureRecognizer(tapRecognizer)

    view.addGestureRecognizer(screenEdgeRecognizer)

    view.addSubview(sideMenuView)

    view.bringSubviewToFront(homeNavigationController.view)
    notificationCenter.addObserver(
      self,
      selector: "onNotifyToggleMenu:",
      name: "menu:toggle",
      object: nil
    )
    notificationCenter.addObserver(
      self,
      selector: "onNotifyMenuSelect:",
      name: "sidemenu:selected",
      object: nil
    )
    notificationCenter.addObserver(
      self,
      selector: "onNotifyUserSelect:",
      name: "user:profile",
      object: nil
    )
  }

  func openMenu(#completion: (Bool -> Void)?) {
    self.view.addGestureRecognizer(panRecognizer)

    UIView.animateWithDuration(
      0.18,
      delay: 0,
      options: .CurveEaseOut,
      animations: {
        self.sideMenuView.alpha = 1.0
        self.sideMenuView.frame.origin.x = 0
        self.homeNavigationController.view.frame.origin.x = 250
      },
      completion: completion
    )
  }

  func closeMenu(#completion: (Bool -> Void)?) {
    UIView.animateWithDuration(
      0.18,
      delay: 0,
      options: .CurveEaseOut,
      animations: {
        self.sideMenuView.alpha = self.kInitialSideMenuAlpha
        self.sideMenuView.frame.origin.x = -250
        self.homeNavigationController.view.frame.origin.x = 0
      },
      completion: completion
    )
    view.removeGestureRecognizer(panRecognizer)
  }

  @objc private func onNotifyToggleMenu(notification: NSNotification) {
    if notification.object != nil {
      let notificationBool = notification.object as Bool

      if notificationBool == false {
        closeMenu(completion: nil)
      } else if notificationBool == true {
        openMenu(completion: nil)
      }

      return
    }

    if (homeNavigationController.view.frame.origin.x > 0) {
      closeMenu(completion: nil)
    } else {
      openMenu(completion: nil)
    }
  }

  @objc private func onNotifyMenuSelect(notification: NSNotification) {
    let notificationObject = notification.object as String

    if notificationObject == "Home" {
      homeNavigationController.setViewControllers([homeTimelineViewController], animated: false)
    } else if notificationObject == "Mentions" {
      homeNavigationController.setViewControllers([mentionsTimelineViewController], animated: true)
    }

    view.bringSubviewToFront(homeNavigationController.view)
  }

  @objc private func onNotifyUserSelect(notification: NSNotification) {
    let notificationObject: AnyObject? = notification.object

    if (notificationObject != nil) {
      println(notificationObject!)
      profileTimelineViewController.user = User.create(notificationObject!)

      homeNavigationController.setViewControllers(
        [profileTimelineViewController],
        animated: false
      )
    }
  }

  @objc private func onMenuTap(recognizer: UITapGestureRecognizer) {
    let view = recognizer.view!
    let loc = recognizer.locationInView(view)
    let subview = view.hitTest(loc, withEvent: nil)

    closeMenu(completion: nil)

    if subview == sideMenuView.homeMenuItem.menuLabel {
      sideMenuView.active = sideMenuView.homeMenuItem
      homeNavigationController.setViewControllers([homeTimelineViewController], animated: false)
    } else if subview == sideMenuView.mentionsMenuItem.menuLabel {
      sideMenuView.active = sideMenuView.mentionsMenuItem
      homeNavigationController.setViewControllers([mentionsTimelineViewController], animated: false)
    } else if subview == sideMenuView.footerView {
      profileTimelineViewController.user = User.currentUser
      homeNavigationController.setViewControllers([profileTimelineViewController], animated: false)
    }
  }

  @objc private func onScreenEdgePanLeft(recognizer: UIScreenEdgePanGestureRecognizer) {
    self.view.addGestureRecognizer(panRecognizer)
  }

  @objc private func onPan(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translationInView(recognizer.view!)

    let state = recognizer.state
    let view = homeNavigationController.view

    if state == .Began {
      draggingPoint = translation
      draggingPoint.x -= view.frame.origin.x
    } else if state == .Changed {
      let movement = translation.x - draggingPoint.x
      var newHorizontalLocation = view.frame.origin.x
      var lastHorizontalLocation = newHorizontalLocation

      newHorizontalLocation += movement

      if movement >= 250 {
        view.frame.origin.x = 250
        self.sideMenuView.frame.origin.x = 0
        return
      }

      if movement >= 0 {
        view.frame.origin.x = min(movement, 250)
        self.sideMenuView.frame.origin.x = view.frame.origin.x - 250
      } else {
        view.frame.origin.x = max(0, movement)
        self.sideMenuView.frame.origin.x = view.frame.origin.x - 250
      }
    } else if state == .Ended {
      let offset = fabs(view.frame.origin.x)
      let velocityX = recognizer.velocityInView(recognizer.view!).x
      let absVelocityX = fabs(velocityX)

      if (velocityX > 0) {
        openMenu(completion: nil)
      } else {
        closeMenu(completion: nil)
      }
    }
  }
}
