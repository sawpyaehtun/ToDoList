//
//  ThemeItemTableViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 15/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class ThemeItemTableViewCell: BaseTableViewCell {

    @IBOutlet weak var viewThemeView: ThemeView!
    
    var categoryName : String? {
        didSet {
            viewThemeView.categoryName = categoryName!
        }
    }
    
    var theme : themes? {
        didSet {
            viewThemeView.theme = theme
        }
    }
    
    var isSelectedIndex : Bool = false {
        didSet {
            viewThemeView.isSelectedIndex = isSelectedIndex
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
