//
//  ConstantLibraryDescription.swift
//  Cliqued
//
//  Created by C211 on 28/04/23.
//

import UIKit

//MARK:- Classes
struct ConstantsLibraryDescription {
    
    var Alamofire = "\n Copyright (c) 2014-2022 Alamofire Software Foundation\n\n Alamofire provides an elegant and composable interface to HTTP network requests. It does not implement its own HTTP networking functionality. Instead it builds on top of Apple's URL Loading System provided by the Foundation framework. At the core of the system is URLSession and the URLSessionTask subclasses. Alamofire wraps these APIs, and many others, in an easier to use interface and provides a variety of functionality necessary for modern application development using HTTP networking. However, it's important to know where many of Alamofire's core behaviors come from, so familiarity with the URL Loading System is important. Ultimately, the networking features of Alamofire are limited by the capabilities of that system, and the behaviors and best practices should always be remembered and observed.\n Additionally, networking in Alamofire (and the URL Loading System in general) is done asynchronously. Asynchronous programming may be a source of frustration to programmers unfamiliar with the concept, but there are very good reasons for doing it this way.\n Previous versions of Alamofire's documentation used examples like Alamofire.request(). This API, while it appeared to require the Alamofire prefix, in fact worked fine without it. The request method and other functions were available globally in any file with import Alamofire. Starting in Alamofire 5, this functionality has been removed and instead the AF global is a reference to Session.default. This allows Alamofire to offer the same convenience functionality while not having to pollute the global namespace every time Alamofire is used and not having to duplicate the Session API globally. Similarly, types extended by Alamofire will use an af property extension to separate the functionality Alamofire adds from other extensions.\n\n Alamofire is released under the MIT license."
    
    var SDWebImage = "\n This library provides an async image downloader with cache support. For convenience, we added categories for UI elements like UIImageView, UIButton, MKAnnotationView.\n\n All source code is licensed under the MIT License."
    
    var Koloda = "\n Copyright © 2019 Yalantis\n\n KolodaView is a class designed to simplify the implementation of Tinder like cards on iOS. It adds convenient functionality such as a UITableView-style dataSource/delegate interface for loading views dynamically, and efficient view loading, unloading. Supported OS & SDK Versions\n\n Supported build target - iOS 11.0 (Xcode 9)\n\n ARC Compatibility\n KolodaView requires ARC.\n\n Thread Safety KolodaView is subclassed from UIView and - as with all UIKit components - it should only be accessed from the main thread. You may wish to use threads for loading or updating KolodaView contents or items, but always ensure that once your content has loaded, you switch back to the main thread before updating the KolodaView.\n\n All source code is licensed under the MIT License."
    
    var SkeletonView = "\n Copyright (c) 2017 Juanpe Catalán\n\n Today almost all apps have async processes, such as API requests, long running processes, etc. While the processes are working, usually developers place a loading view to show users that something is going on.\n SkeletonView has been conceived to address this need, an elegant way to show users that something is happening and also prepare them for which contents are waiting.\n\n All source code is licensed under the MIT License."
    
    var SKPhotoBrowser = "\n SKPhotoBrowser is a simple PhotoBrowser/Viewer inspired by facebook, twitter photo browsers written by swift. Features: Display one or more images by providing either UIImage objects, or string of URL array. Photos can be zoomed and panned, and optional captions can be displayed.\n • Display one or more images by providing either UIImage objects, or string of URL array.\n • Photos can be zoomed and panned, and optional captions can be displayed\n • Minimalistic Facebook-like interface, swipe up/down to dismiss. \n • Ability to custom control. (hide/ show toolbar for controls, / swipe control).\n • Handling and caching photos from web.\n • Landscape handling.\n • Delete photo support(by offbye). By set displayDelete=true show a delete icon in statusbar, deleted indexes can be obtain from delegate func didDeleted.\n\n All source code is licensed under the MIT License."
    
    var SwiftyJson = "\n SwiftyJSON is a library that helps to read and process JSON data from an API/Server. So why use SwiftyJSON? Swift by nature is strict about data types and wants the user to explicitly declare it. This becomes a problem as JSON data is usually implicit about data types.\n\n All source code is licensed under the MIT License."
    
    var TLPhotoPicker = "\n TLPhotoPicker enables application to pick images and videos from multiple smart album in iOS, similar to the current facebook app.\n\n TLPhotoPicker is available under the MIT license."
}

var DescriptionLibrary = ConstantsLibraryDescription()
