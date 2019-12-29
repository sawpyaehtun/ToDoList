//
//  ActionSheetPickerExtension.swift
//  PADCHotelBooking
//
//  Created by saw pyaehtun on 06/09/2019.
//  Copyright © 2019 saw pyaehtun. All rights reserved.
//

import Foundation
import ActionSheetPicker_3_0

extension AbstractActionSheetPicker {
    func xt_defaultConfig() {
        titleTextAttributes = [kCTFontAttributeName : UIFont.fixedAppBoldFont (size: 18),NSAttributedString.Key.foregroundColor : UIColor.black]
        tapDismissAction = .cancel
        let cancelButton = UIBarButtonItem(title: "Cancle", style: .plain, target: nil, action: nil)
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.fixedAppBoldFont(size: 14), NSAttributedString.Key.foregroundColor : UIColor.systemBlue], for: UIControl.State.normal)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: nil)
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.fixedAppBoldFont(size: 14), NSAttributedString.Key.foregroundColor : UIColor.systemBlue], for: UIControl.State.normal)
        setCancelButton(cancelButton)
        setDoneButton(doneButton)
    }
}

class ActionSheetPickerWireframe {
    
    class func showDatePicker(_ title: String?, selectedDate: Date = Date(), timeZone: TimeZone? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, datePickerMode: UIDatePicker.Mode = .date, doneBlock: @escaping ActionDateDoneBlock = { _, _, _ in }, cancelBlock: @escaping ActionDateCancelBlock = { _ in }, sender: UIView) {
        let datePicker = ActionSheetDatePicker(title: title, datePickerMode: datePickerMode, selectedDate: selectedDate, doneBlock: doneBlock , cancel: cancelBlock, origin: sender)
        datePicker?.minimumDate = minimumDate
        datePicker?.maximumDate = maximumDate
        datePicker?.timeZone = timeZone
        datePicker?.xt_defaultConfig()
        datePicker?.show()
    }
    
    class func showPicker(_ title: String?, displayDataArray: [Any], initialSelection: Int = 0, doneBlock: @escaping ActionStringDoneBlock = { _, _, _ in }, cancelBlock: @escaping ActionStringCancelBlock = { _ in }, sender: UIView) {
        let picker = ActionSheetStringPicker(title: title, rows: displayDataArray, initialSelection: initialSelection, doneBlock: doneBlock, cancel: cancelBlock, origin: sender)
        
//        picker?.toolbarBackgroundColor = UIColor.darkGray
//        picker?.pickerBackgroundColor = UIColor.black
//        picker?.setTextColor(UIColor.white)
        picker?.xt_defaultConfig()
        picker?.show()
    }
    
    class func showMyMultipleStringPicker(_ title: String?, displayDataArray: [Any], initialSelection: [Int] = [0,0] , doneBlock: @escaping ActionMultipleStringDoneBlock = { _, _, _ in }, cancelBlock: @escaping ActionMultipleStringCancelBlock = { _ in }, sender: UIView) {
        let picker = ActionSheetMultipleStringPicker(title: title, rows: displayDataArray, initialSelection: initialSelection, doneBlock: doneBlock, cancel: cancelBlock, origin: sender)
        picker?.xt_defaultConfig()
        picker?.show()
    }
}
