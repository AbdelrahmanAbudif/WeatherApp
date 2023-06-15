//
//  ForecastCellTableViewCell.swift
//  WeatherApp
//
//  Created by Abdelrahman Adel on 14/06/2023.
//

import UIKit

class ForecastCellTableViewCell: UITableViewCell {
    @IBOutlet weak var conditionCellImage: UIImageView!
    @IBOutlet weak var dayCellLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
