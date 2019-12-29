//
//  TimeViewController.swift
//  To-Do
//
//  Created by sawpyaehtun on 12/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

protocol TimeViewControllerDelegate {
    func didSelectTime(startDate : Date, endDate : Date)
}

class TimeViewController: BaseViewController {
    
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var datePickerStartTime: UIDatePicker!
    @IBOutlet weak var datePickerEndTime: UIDatePicker!
    
    var startDate : Date = Date()
    var endDate : Date = Date()
    
    var delegate : TimeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func setUpUIs() {
        super.setUpUIs()
        setUpStartAndEndTimePicker()
    }
    
    private func setUpStartAndEndTimePicker(){
        
        lblSelectedDate.text =  XTDateFormatterStruct.xt_appDateFormatter().string(from: startDate)
        
        let currentDate = Date()
        var minumStartDate : Date? = nil

        if startDate.getCurrentYear() == currentDate.getCurrentYear() &&
            startDate.getCurrentMonth() == currentDate.getCurrentMonth() &&
            startDate.getCurrentDay() == currentDate.getCurrentDay() {
            minumStartDate = currentDate
        }
        
        
        datePickerStartTime.datePickerMode = .time
        datePickerStartTime.addTarget(self, action: #selector(didChangeStartime(sender:)), for: .valueChanged)
        datePickerStartTime.timeZone = TimeZone.current
        datePickerStartTime.date = startDate
        datePickerStartTime.minimumDate = minumStartDate
        datePickerStartTime.setValue(UIColor.white, forKeyPath: "textColor")
        
        
        datePickerEndTime.datePickerMode = .time
        datePickerEndTime.addTarget(self, action: #selector(didChangeEndTime(sender:)), for: .valueChanged)
        datePickerEndTime.timeZone = TimeZone.current
        datePickerEndTime.date = endDate
        datePickerEndTime.minimumDate = minumStartDate
        datePickerEndTime.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
}

// User interaction
extension TimeViewController {
    @IBAction func didTapCancel(_ sender: Any) {
        dismissThis(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        delegate?.didSelectTime(startDate: startDate, endDate: endDate)
        dismissThis(animated: true)
    }
}

extension TimeViewController {
    @objc func didChangeStartime(sender : UIDatePicker){
        startDate = sender.date
        datePickerEndTime.minimumDate = sender.date
        if startDate > endDate {
            endDate = startDate
        }
    }
    
    @objc func didChangeEndTime(sender : UIDatePicker){
        endDate = sender.date
    }
}

