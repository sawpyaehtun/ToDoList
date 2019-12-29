//
//  DayItemCollectionViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 10/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

protocol DayItemCollectionViewCellDelegate {
    func didSelectDate(selectedDate : Date)
}

class DayItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewdayBackGround: CardView!
    @IBOutlet weak var lblDay: UILabel!
    
    var delegate : DayItemCollectionViewCellDelegate?
    
    var isSelectable : Bool = true {
        didSet {
            lblDay.textColor = isSelectable ? UIColor.white : UIColor.darkGray
            lblDay.isUserInteractionEnabled = isSelectable
        }
    }
    
    var isUserSelectedDate : Bool = false {
        didSet {
            viewdayBackGround.backgroundColor = isUserSelectedDate ? UIColor.yellow : UIColor.clear
            if isUserSelectedDate {
                lblDay.textColor = UIColor.darkGray
            }
        }
    }
    
    var monthForThisItem : Int = 0
    
    var currentUserSelectedDate : Date? {
        didSet {
            guard let cusd = currentUserSelectedDate else { return }
            guard let date = date else {return}
            isUserSelectedDate = (XTDateFormatterStruct.xt_defaultDateFormatter().string(from: date) == XTDateFormatterStruct.xt_defaultDateFormatter().string(from: cusd) && monthForThisItem == cusd.getCurrentMonth()) ? true : false
        }
    }
    
    var date : Date?{
        didSet {
            guard let date = date else {return}
            lblDay.text = String(date.getCurrentDay())
            isSelectable = (monthForThisItem == date.getCurrentMonth()) ? true : false
            
            let currentDate = Date().getCurrentDate()
            if date < currentDate {
                isSelectable = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDay(sender:)))
        lblDay.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapDay(sender : UITapGestureRecognizer){
        delegate?.didSelectDate(selectedDate: date!)
        print("date : \(date) and CurrentUserselectedDate : \(currentUserSelectedDate) - - - \(date == currentUserSelectedDate)")
    }
}
