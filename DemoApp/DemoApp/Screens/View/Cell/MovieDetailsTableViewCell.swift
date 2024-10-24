//
//  MoveiDetailsTableViewCell.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 24/10/24.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var movieThumbnail: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieLanguages: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
