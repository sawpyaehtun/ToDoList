//
//  CategoryVO + Extension.swift
//  To-Do
//
//  Created by sawpyaehtun on 20/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation

extension CategoryVO {
    func toCategoryCDVO() -> CategoryCDVO {
        let categoryCDVO = CategoryCDVO(context: PersistenceManager.shared.persistanceContainer.viewContext)
        categoryCDVO.id = self.id
        categoryCDVO.name = self.name
        categoryCDVO.theme = self.theme
        return categoryCDVO
    }
}
