//
//  YearPicker.swift
//  To-Do
//
//  Created by sawpyaehtun on 10/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

protocol YearPickerDelegate {
    func didSelectYear(year : Int)
}

class YearPicker: UIView {
    
    @IBOutlet weak var scrollViewYearPicker: UIScrollView!
    
    var delegate : YearPickerDelegate?
    
    let currentYear : Int = Date().getCurrentYear()
    var yearItemArray : [Int] {
        var yearArr : [Int] = []
        for i in 0 ... 10 {
               yearArr.append(currentYear + i)
           }
        return yearArr
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: YearPicker.self), owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
        
        setupYearsItems(selectedID : 0)
    }
    
    func setSelectedYear(selectedYear : Int){
        setupYearsItems(selectedID: yearItemArray.firstIndex(of: selectedYear)!)
    }
    
    
    private func setupYearsItems(selectedID : Int){
        
        let yearItemWidth = UIScreen.main.bounds.width / 5
        let yearItemHeight = self.bounds.height - 10
        
        scrollViewYearPicker.contentSize.width = yearItemWidth * 11
        
        for i in 0 ... 10 {
            
            let yearView = YearView(frame: CGRect(x: yearItemWidth * CGFloat(i), y: 0, width: yearItemWidth, height: yearItemHeight))
            
            yearView.id = i
            yearView.lblYear.text = String(yearItemArray[i])
            yearView.year = yearItemArray[i]
            if selectedID == i {
                yearView.isSelectedOrNot(isSelected: true)
            } else {
                yearView.isSelectedOrNot(isSelected: false)
            }
            
            let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(didTapCategory(sender:)))
            yearView.isUserInteractionEnabled = true
            yearView.addGestureRecognizer(tapGestureRecogniser)
            scrollViewYearPicker.addSubview(yearView)
        }
        
        if selectedID > 2 && selectedID < 8 {
        scrollViewYearPicker.contentOffset = CGPoint(x: (yearItemWidth * CGFloat(selectedID)) - (yearItemWidth * CGFloat(2)), y: 0)
        }
        
    }
    
    @objc func didTapCategory(sender : UITapGestureRecognizer){
           
           guard let yearView =  sender.view as? YearView else {return}
           
           let id = yearView.id
           
           for view in scrollViewYearPicker.subviews {
               view.removeFromSuperview()
           }
           
          setupYearsItems(selectedID: id ?? 0)
        delegate?.didSelectYear(year: yearView.year ?? 0)
       }
}
