//
//  TESProductTableViewCell.swift
//  TestAppSwift
//
//  Created by Iegor Borodai on 7/23/15.
//  Copyright (c) 2015 Iegor Borodai. All rights reserved.
//

import UIKit

class TESProductTableViewCell : UITableViewCell {
    
    static let identifier = "TESProductTableViewCell"
   
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    @IBOutlet weak var poductActionButton: UIButton!
}
