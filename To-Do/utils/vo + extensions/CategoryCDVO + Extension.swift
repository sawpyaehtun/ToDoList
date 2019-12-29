//
//  CategoryCDVO + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension CategoryCDVO {
    func toCategoryVO() -> CategoryVO {
        return CategoryVO(id: self.id, name: self.name, theme: self.theme)
    }
}
