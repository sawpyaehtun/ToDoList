//
//  CategoryVO.swift
//  To-Do
//
//  Created by sawpyaehtun on 09/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import Foundation
import UIKit

enum themes : String {
    case purple
    case yellow
    case blue
    case maroon
    
    func getBackGroundColor() -> UIColor {
        switch self {
        case .purple:
            return UIColor(named: "purple")!
        case .yellow:
            return UIColor(named: "yellow")!
        case .blue:
            return UIColor(named: "blue")!
        case .maroon:
            return UIColor(named: "maroon")!
        }
    }
    
    func getShadowColor() -> UIColor {
        switch self {
        case .purple:
            return UIColor(named: "purpleShadow")!
        case .yellow:
            return UIColor(named: "yellowShadow")!
        case .blue:
            return UIColor(named: "blueShadow")!
        case .maroon:
            return UIColor(named: "maroonShadow")!
        }
    }
    
    func getCategory(name : String) -> CategoryVO {
        var cateGoryName = name
        if name.isEmpty {
            cateGoryName = "T"
        }
        switch self {
        case .purple:
            return CategoryVO(id: "", name: cateGoryName, theme: themes.purple.rawValue)
        case .yellow:
            return CategoryVO(id: "", name: cateGoryName, theme: themes.yellow.rawValue)
        case .blue:
            return CategoryVO(id: "", name: cateGoryName, theme: themes.blue.rawValue)
        case .maroon:
            return CategoryVO(id: "", name: cateGoryName, theme: themes.maroon.rawValue)
        }
    }
}

struct CategoryVO {
    let id : String?
    let name : String?
    let theme : String?
}

extension CategoryVO {
    init?(dictionary : [String : Any]) {
        guard let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let theme = dictionary["theme"] as? String else {return nil}
        self.id = id
        self.name = name
        self.theme = theme
    }
}

extension CategoryVO {
    func toDictionary() -> [String : Any]{
        return [
            "id" : self.id as Any,
            "name" : self.name as Any,
            "theme" : self.theme as Any
        ]
    }
}
