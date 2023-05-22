//
//  Data+Extension.swift
//  Bubbles
//
//  Created by C100-107 on 01/06/20.
//  Copyright © 2020 C100-107. All rights reserved.
//

import Foundation
import UIKit

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
    
    var uiImage: UIImage? { UIImage(data: self) }
}

