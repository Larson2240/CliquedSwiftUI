//
//  Connectivity.swift
//  SwimInc
//
//  Created by C211 on 20/07/21.
//

import UIKit
import Foundation
import Alamofire

class Connectivity {
    static let sharePreference = Connectivity()
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
