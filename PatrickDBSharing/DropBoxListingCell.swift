//
//  DropBoxListingCell.swift
//  PatrickDBSharing
//
//  Created by indianic on 13/04/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit

class DropBoxListingCell: UITableViewCell {

    
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var fileName: UILabel!
  
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}
