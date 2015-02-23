//
//  Status.swift
//  Twitter
//
//  Created by Kurt Ruppel on 2/18/15.
//  Copyright (c) 2015 kruppel. All rights reserved.
//

//{
//  contributors = "<null>";
//  coordinates = "<null>";
//  "created_at" = "Fri Feb 20 14:48:56 +0000 2015";
//  entities =         {
//    hashtags =             (
//    );
//    symbols =             (
//    );
//    urls =             (
//    );
//    "user_mentions" =             (
//      {
//        id = 2725888273;
//        "id_str" = 2725888273;
//        indices =                     (
//          3,
//          10
//        );
//        name = "Mozilla Geolocation";
//        "screen_name" = MozGeo;
//      }
//    );
//  };
//  "favorite_count" = 0;
//  favorited = 0;
//  geo = "<null>";
//  id = 568784370565300224;
//  "id_str" = 568784370565300224;
//  "in_reply_to_screen_name" = "<null>";
//  "in_reply_to_status_id" = "<null>";
//  "in_reply_to_status_id_str" = "<null>";
//  "in_reply_to_user_id" = "<null>";
//  "in_reply_to_user_id_str" = "<null>";
//  lang = en;
//  place = "<null>";
//  "retweet_count" = 3;
//  retweeted = 0;
//  "retweeted_status" =         {
//    contributors = "<null>";
//    coordinates = "<null>";
//    "created_at" = "Fri Feb 20 13:29:25 +0000 2015";
//    entities =             {
//      hashtags =                 (
//      );
//      symbols =                 (
//      );
//      urls =                 (
//      );
//      "user_mentions" =                 (
//      );
//    };
//    "favorite_count" = 2;
//    favorited = 0;
//    geo = "<null>";
//    id = 568764363185766400;
//    "id_str" = 568764363185766400;
//    "in_reply_to_screen_name" = "<null>";
//    "in_reply_to_status_id" = "<null>";
//    "in_reply_to_status_id_str" = "<null>";
//    "in_reply_to_user_id" = "<null>";
//    "in_reply_to_user_id_str" = "<null>";
//    lang = en;
//    place = "<null>";
//    "retweet_count" = 3;
//    retweeted = 0;
//    source = "<a href=\"http://twitter.com/#!/download/ipad\" rel=\"nofollow\">Twitter for iPad</a>";
//    text = "Less than a month and we reached another milestone: 4 million cell networks and 89 million WiFi networks. Keep it up!";
//    truncated = 0;
//    user =             {
//      "contributors_enabled" = 0;
//      "created_at" = "Tue Aug 12 10:12:57 +0000 2014";
//      "default_profile" = 0;
//      "default_profile_image" = 0;
//      description = "All things about Mozilla (Geo)location. Tweets by @hannosch";
//      entities =                 {
//        description =                     {
//          urls =                         (
//          );
//        };
//        url =                     {
//          urls =                         (
//            {
//              "display_url" = "location.services.mozilla.com";
//              "expanded_url" = "https://location.services.mozilla.com/";
//              indices =                                 (
//                0,
//                23
//              );
//              url = "https://t.co/FNXmUH8p7d";
//            }
//          );
//        };
//      };
//      "favourites_count" = 20;
//      "follow_request_sent" = 0;
//      "followers_count" = 209;
//      following = 0;
//      "friends_count" = 19;
//      "geo_enabled" = 0;
//      id = 2725888273;
//      "id_str" = 2725888273;
//      "is_translation_enabled" = 0;
//      "is_translator" = 0;
//      lang = en;
//      "listed_count" = 15;
//      location = "The Web";
//      name = "Mozilla Geolocation";
//      notifications = 0;
//      "profile_background_color" = C0DEED;
//      "profile_background_image_url" = "http://abs.twimg.com/images/themes/theme1/bg.png";
//      "profile_background_image_url_https" = "https://abs.twimg.com/images/themes/theme1/bg.png";
//      "profile_background_tile" = 0;
//      "profile_image_url" = "http://pbs.twimg.com/profile_images/499151784812609536/u5cyANo1_normal.png";
//      "profile_image_url_https" = "https://pbs.twimg.com/profile_images/499151784812609536/u5cyANo1_normal.png";
//      "profile_link_color" = 0096DD;
//      "profile_location" = "<null>";
//      "profile_sidebar_border_color" = FFFFFF;
//      "profile_sidebar_fill_color" = DDEEF6;
//      "profile_text_color" = 333333;
//      "profile_use_background_image" = 0;
//      protected = 0;
//      "screen_name" = MozGeo;
//      "statuses_count" = 30;
//      "time_zone" = Copenhagen;
//      url = "https://t.co/FNXmUH8p7d";
//      "utc_offset" = 3600;
//      verified = 0;
//    };
//  };
//  source = "<a href=\"http://twitter.com\" rel=\"nofollow\">Twitter Web Client</a>";
//  text = "RT @MozGeo: Less than a month and we reached another milestone: 4 million cell networks and 89 million WiFi networks. Keep it up!";
//  truncated = 0;
//}

struct Status {
  var id: Int?
  let text: String!
  let user: User
  let retweetedStatus: Box<Status>?
  let createdAt: NSDate!
  var retweetCount: Int!
  var retweeted: Bool!
  var inReplyToStatusID: Int?
  var favorited: Bool! = false

  static func create(data: AnyObject) -> Status {
    let json = JSON(data)
    let formatter = NSDateFormatter()
    var retweetedStatus: Box<Status>?

    formatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
    if (json["retweeted_status"] != nil) {
      retweetedStatus = Box(Status.create(json["retweeted_status"].object))
    }

    return Status(
      id: json["id"].int,
      text: json["text"].string,
      user: User.create(json["user"].object),
      retweetedStatus: retweetedStatus,
      createdAt: formatter.dateFromString(json["created_at"].string!),
      retweetCount: json["retweet_count"].int,
      retweeted: json["retweeted"].bool,
      inReplyToStatusID: json["in_reply_to_status_id"].int,
      favorited: json["favorited"].bool
    )
  }
}
