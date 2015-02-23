//
//  User.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

//  user =         {
//    "contributors_enabled" = 0;
//    "created_at" = "Fri Apr 06 12:47:15 +0000 2007";
//    "default_profile" = 0;
//    "default_profile_image" = 0;
//    description = "Flying Dutchman";
//    entities =             {
//      description =                 {
//        urls =                     (
//        );
//      };
//      url =                 {
//        urls =                     (
//          {
//            "display_url" = "annevankesteren.nl";
//            "expanded_url" = "https://annevankesteren.nl/";
//            indices =                             (
//              0,
//              23
//            );
//            url = "https://t.co/e1JDyVvraa";
//          }
//        );
//      };
//    };
//    "favourites_count" = 395;
//    "follow_request_sent" = 0;
//    "followers_count" = 3052;
//    following = 1;
//    "friends_count" = 170;
//    "geo_enabled" = 1;
//    id = 3616991;
//    "id_str" = 3616991;
//    "is_translation_enabled" = 0;
//    "is_translator" = 0;
//    lang = en;
//    "listed_count" = 260;
//    location = Switzerland;
//    name = "Anne van Kesteren";
//    notifications = 0;
//    "profile_background_color" = 1A1B1F;
//    "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme9/bg.gif";
//    "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme9/bg.gif";
//    "profile_background_tile" = 0;
//    "profile_banner_url" = "https://pbs.twimg.com/profile_banners/3616991/1400053219";
//    "profile_image_url" = "http://pbs.twimg.com/profile_images/466483130011234305/5jT_75o__normal.jpeg";
//    "profile_image_url_https" = "https://pbs.twimg.com/profile_images/466483130011234305/5jT_75o__normal.jpeg";
//    "profile_link_color" = 2FC2EF;
//    "profile_location" = "<null>";
//    "profile_sidebar_border_color" = 181A1E;
//    "profile_sidebar_fill_color" = 252429;
//    "profile_text_color" = 666666;
//    "profile_use_background_image" = 1;
//    protected = 0;
//    "screen_name" = annevk;
//    "statuses_count" = 4733;
//    "time_zone" = Amsterdam;
//    url = "https://t.co/e1JDyVvraa";
//    "utc_offset" = 3600;
//    verified = 0;
//  };

import Foundation

struct User {

  let id: Int!
  var name: String!
  var screenName: String!
  var profileImageURL: NSURL!

  static var currentUser: User!

  static func create(data: AnyObject) -> User {
    let json = JSON(data)

    // s/normal.(ext)$/bigger.\1/ for profile image
    let profileImageURL = json["profile_image_url"].string!
    let length = countElements(profileImageURL)
    let range = NSMakeRange(0, length)
    let regex = NSRegularExpression(
      pattern: "_normal.([a-zA-Z]+)$",
      options: .CaseInsensitive,
      error: nil
    )!
    let biggerImageURL = regex.stringByReplacingMatchesInString(
      profileImageURL,
      options: .ReportProgress,
      range: range,
      withTemplate: "_bigger.$1"
    )

    return User(
      id: json["id"].int,
      name: json["name"].string,
      screenName: json["screen_name"].string,
      profileImageURL: NSURL(string: biggerImageURL)
    )
  }

  static func fetchCurrentUser(#success: ((user: User) -> Void)?,
    failure: ((error: NSError) -> Void)?) {
    let tc = TwitterClient.instance

    tc.getAccountVerifyCredentials(
      success: { (response: AnyObject) -> Void in
        User.currentUser = User.create(response)

        success?(user: User.currentUser)
      },
      failure: failure?
    )
  }
}