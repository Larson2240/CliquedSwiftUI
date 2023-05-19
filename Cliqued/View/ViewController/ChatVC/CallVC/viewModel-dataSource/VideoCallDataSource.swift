//
//  VideoCallDataSource.swift
//  Cliqued
//
//  Created by C100-132 on 23/02/23.
//

import UIKit
import SDWebImage

class VideoCallDataSource: NSObject {

    private let viewController: VideoCallVC
    private let viewModel: VideoCallViewModel
    
    //MARK:- Init
    init(viewModel: VideoCallViewModel, viewController: VideoCallVC) {
        self.viewController = viewController
        self.viewModel = viewModel
        super.init()
    }
}
