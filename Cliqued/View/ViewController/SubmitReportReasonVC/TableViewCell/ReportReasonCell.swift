//
//  ReportReasonCell.swift
//  Cliqued
//
//  Created by C211 on 19/01/23.
//

import UIKit

class ReportReasonCell: UITableViewCell {

    @IBOutlet weak var labelReportReasonText: UILabel!{
        didSet {
            labelReportReasonText.text = "This person is trying to sell me something"
            labelReportReasonText.font = CustomFont.THEME_FONT_Medium(16)
            labelReportReasonText.textColor = Constants.color_DarkGrey
        }
    }
    
    @IBOutlet weak var imageviewSelectIcon: UIImageView!
    @IBOutlet weak var imageviewBottomLine: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageviewSelectIcon.isHidden = true
        imageviewBottomLine.isHidden = true
        labelReportReasonText.lastLineFillPercent = 100
        labelReportReasonText.linesCornerRadius = 10
        labelReportReasonText.skeletonTextNumberOfLines = 1
        labelReportReasonText.skeletonTextLineHeight = .fixed(22)
        labelReportReasonText.showAnimatedGradientSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func hideAnimation() {
        labelReportReasonText.hideSkeleton()
        imageviewBottomLine.isHidden = false
    }
}
