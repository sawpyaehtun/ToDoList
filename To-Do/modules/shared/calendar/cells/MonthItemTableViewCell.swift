//
//  MonthItemTableViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 10/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

protocol MonthItemTableViewCellDelegate {
    func didSelectDate(selectedDate : Date)
}

class MonthItemTableViewCell: BaseTableViewCell {
    
    let numberOfItemsInRow : CGFloat = 7.0
    let spacing : CGFloat = 0
    let leadingSpace : CGFloat = 10
    let TrailingSpace : CGFloat = 10
    var delegate : MonthItemTableViewCellDelegate?
    var currentUserSelectedDate : Date?
    
//    var selectedDate : Date?
    
    var dayArray : [Date] = [] {
        didSet {
            collectionViewDays.reloadData()
        }
    }
    
    var startDate : Date? {
        didSet {
            dayArray = (startDate?.getDatesForMonthVertically())!
        }
    }
    
    var monthForThisItem : Int = 0 {
        didSet {
            lblMonthTitle.text = getMonthName(month: monthForThisItem)
        }
    }
    
    
    @IBOutlet weak var lblMonthTitle: UILabel!
    @IBOutlet weak var collectionViewDays: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func setupUIs() {
        super.setupUIs()
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        
        collectionViewDays.delegate = self
        collectionViewDays.dataSource = self
        
        let collectionViewWidth = UIScreen.main.bounds.width * 0.85
        let collectionViewHeight = (UIScreen.main.bounds.height / 2) * 0.85
        
        collectionViewDays.registerForCell(strID: String(describing: DayItemCollectionViewCell.self))
        
        let layout = collectionViewDays.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        // calculating total padding
        let totalPadding : CGFloat = ((numberOfItemsInRow - 1) * spacing) + leadingSpace + TrailingSpace
        
        let itemWidth = (collectionViewWidth - totalPadding) / numberOfItemsInRow
        let itemHight = (collectionViewHeight - totalPadding) / 7.38
        layout.itemSize = CGSize(width: itemWidth, height: itemHight)
    }
}


extension MonthItemTableViewCell : UICollectionViewDelegate {
    
}

extension MonthItemTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DayItemCollectionViewCell.self), for: indexPath) as? DayItemCollectionViewCell
        let date = dayArray[indexPath.row]
        item?.monthForThisItem = monthForThisItem
        item?.date = date
        item?.currentUserSelectedDate = currentUserSelectedDate
        item?.delegate = self
//        item?.showIndex(day: currentUserSelectedDay, month: currentUserSelectedMonth, year: currentUserselectedYear)
        return item!
    }
}

extension MonthItemTableViewCell {
    private func getMonthName(month : Int) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "MM"
        return fmt.monthSymbols[month - 1]
    }
}

extension MonthItemTableViewCell : DayItemCollectionViewCellDelegate {
    func didSelectDate(selectedDate: Date) {
        delegate?.didSelectDate(selectedDate: selectedDate)
    }
}
