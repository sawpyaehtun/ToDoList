//
//  CategoryItemTableViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 15/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class CategoryItemTableViewCell: BaseTableViewCell {

    @IBOutlet weak var viewCategory: CategoryView!
    @IBOutlet weak var imgCategoryIndicator: UIImageView!
    
    var category : CategoryVO?{
        didSet {
            viewCategory.category = category
        }
    }
    
    var isSelectedIndex : Bool = false {
        didSet {
            viewCategory.isSelected = isSelectedIndex
            imgCategoryIndicator.isHidden = !isSelectedIndex
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
