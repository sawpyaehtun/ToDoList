//
//  ScheduleViewController.swift
//  To-Do
//
//  Created by sawpyaehtun on 17/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ScheduleViewController: BaseViewController {
    
    @IBOutlet weak var collectionViewForMonth: UICollectionView!
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var scrollViewDayLabel: UIScrollView!
    @IBOutlet weak var tableViewWeek: UITableView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblWeek: UILabel!
    @IBOutlet weak var viewIndicatorWeek: UIView!
    @IBOutlet weak var viewIndicatorMonth: UIView!
    
    let viewModel = ScheduleViewModel()
    
    var allTaskList : [TaskVO]?{
        didSet{
            viewModel.allTaskBehaviorRelay.accept(allTaskList!)
        }
    }
    
    var categoryList : [CategoryVO]?
    
    let currentYear : Int = Date().getCurrentYear()
    
    var daysInMonthView : [Date] = []
    
    let numberOfItemsInRow : CGFloat = 7.0
    let spacing : CGFloat = 0
    let leadingSpace : CGFloat = 0
    let TrailingSpace : CGFloat = 0
    
    var yearItemArray : [Int] {
        var yearArr : [Int] = []
        for i in 0 ... 10 {
            yearArr.append(currentYear + i)
        }
        return yearArr
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysInMonthView = getStartDateForCurrentMonth().getDatesForMonth()
        
        if daysInMonthView[35].getCurrentMonth() != Date().getCurrentMonth() {
            repeat{
                daysInMonthView.removeLast()
            } while daysInMonthView.count > 35
        }
        
    }
    
    
    override func bindModel() {
        super.bindModel()
        viewModel.bindViewModel(in: self)
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.allTaskBehaviorRelay.subscribe(onNext: { (_) in
            self.tableViewWeek.reloadData()
        }).disposed(by: disposableBag)
        
        ScrollPositionManager.shared.scrollContentOffsetX.subscribe(onNext: { (valueX) in
            self.scrollViewDayLabel.contentOffset.x = valueX
        }).disposed(by: disposableBag)
    }
    
    override func setUpUIs() {
        super.setUpUIs()
        scrollViewDayLabel.delegate = self
        setupTableViews()
        setupCollectionView()
        setupScrollViewDayLabel()
    }
    
}

// MARK: - UI preparation
extension ScheduleViewController {
    
    private func setupTableViews(){
        tableViewWeek.delegate = self
        tableViewWeek.dataSource = self
        tableViewWeek.separatorStyle = .none
        tableViewWeek.bounces = false
        tableViewWeek.registerForCell(strID: String(describing: WeekViewItemTableViewCell.self))
    }
    
    private func setupCollectionView(){
        collectionViewForMonth.dataSource = self
        collectionViewForMonth.delegate = self
        collectionViewForMonth.registerForCell(strID: String(describing: MonthViewDayItemCollectionViewCell.self))
        
        let collectionViewWidth = UIScreen.main.bounds.width
        
        collectionViewForMonth.registerForCell(strID: String(describing: DayItemCollectionViewCell.self))
        
        let layout = collectionViewForMonth.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        // calculating total padding
        let totalPadding : CGFloat = ((numberOfItemsInRow - 1) * spacing) + leadingSpace + TrailingSpace
        
        let itemWidth = (collectionViewWidth - totalPadding) / numberOfItemsInRow
        let itemHight = itemWidth * 1.5
        layout.itemSize = CGSize(width: itemWidth, height: itemHight)
    }
    
    private func setupScrollViewDayLabel(){
        let dayViewItemWidth = UIScreen.main.bounds.width / 4
        let dayViewItemHeight = CGFloat(46.0)
        
        scrollViewDayLabel.contentSize.width = dayViewItemWidth * 7
        let dayArr = ["sun","mon","tue","wed","thu","fri","sat"]
        
        for i in 0 ..< dayArr.count {
            
            let dayViewOfWeekView = DayViewOfWeekView(frame: CGRect(x: dayViewItemWidth * CGFloat(i), y: 0, width: dayViewItemWidth, height: dayViewItemHeight))
            dayViewOfWeekView.lblDay.text = dayArr[i]
            scrollViewDayLabel.addSubview(dayViewOfWeekView)
        }
    }
}

// MARK: - user interaction
extension ScheduleViewController {
    @IBAction func didTapBtnBack(_ sender: Any) {
        ScrollPositionManager.shared.scrollContentOffsetX.accept(CGFloat(0.0))
        dismissThis(animated: true)
    }
    @IBAction func didTapBtnMonth(_ sender: Any) {
        moveIndicatorToMonth()
        collectionViewForMonth.reloadData()
    }
    
    @IBAction func didTapBtnWeek(_ sender: Any) {
        moveIndicatorToWeek()
    }
}

extension ScheduleViewController {
    
    private func moveIndicatorToWeek(){
        viewIndicatorWeek.backgroundColor = .white
        lblWeek.textColor = .white
        viewIndicatorMonth.backgroundColor = .darkGray
        lblMonth.textColor = .darkGray
        viewMonth.isHidden = true
    }
    
    private func moveIndicatorToMonth(){
        viewIndicatorWeek.backgroundColor = .darkGray
        lblWeek.textColor = .darkGray
        viewIndicatorMonth.backgroundColor = .white
        lblMonth.textColor = .white
        viewMonth.isHidden = false
    }
}

//MARK:- TableView
extension ScheduleViewController : UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeekViewItemTableViewCell.self), for: indexPath) as! WeekViewItemTableViewCell
        cell.setupcell(taskList: viewModel.allTaskBehaviorRelay.value, categoryList: categoryList ?? [], daysInCurrentWeek: getStartDateForCurrentWeek().getDaysInCurrentWeek())
        cell.delegate = self
        return cell
    }
    
    
    
}

//MARK:- scrollview for day label
//extension ScheduleViewController : UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == scrollViewDayLabel {
//            ScrollPositionManager.shared.scrollContentOffsetX.accept(scrollView.contentOffset.x)
//        }
//    }
//}

//MARK: - Collection for Month
extension ScheduleViewController : UICollectionViewDelegate {
    
}

extension ScheduleViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonthView.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthViewDayItemCollectionViewCell.self), for: indexPath) as! MonthViewDayItemCollectionViewCell
        let day = daysInMonthView[indexPath.row]
        item.setupItem(day: day,themesArr: getThemesForDay(day: day))
        return item
    }
    
    
}

//MARK: - Needed functions
extension ScheduleViewController {
    private func getStartDateForCurrentMonth() -> Date{
        let date = Date.from(year: Date().getCurrentYear(), month: Date().getCurrentMonth(), day: 1)
        let weekDayString = date.weekDayString()
        let fmt = DateFormatter()
        let weekDays = fmt.weekdaySymbols
        let neededDaysToSub = weekDays!.firstIndex(of: weekDayString)!
        return date.previousDay(decrease: neededDaysToSub)
    }
    
    private func getThemesForDay(day : Date) -> [themes]{
        
        print(day)
        
        let CategoryIDList = getTaskOfDay(day: day).map { (task) -> String in
            return task.categoryId ?? ""
        }
        
        let uniqueCategories = Array(Set(CategoryIDList))
        
        guard let filteredCategories = categoryList?.filter({ (category) -> Bool in
            uniqueCategories.contains(category.id ?? "")
        }) else { return []}
        
        return getThemesList(categories: filteredCategories)
    }
    
    private func getThemesList(categories : [CategoryVO]) -> [themes]{
        return categories.map { (category) -> themes in
            switch category.theme {
            case themes.purple.rawValue :
                return themes.purple
            case themes.yellow.rawValue :
                return themes.yellow
            case themes.blue.rawValue :
                return themes.blue
            case themes.maroon.rawValue :
                return themes.maroon
            default :
                return themes.maroon
            }
        }
    }
    
    private func getTaskOfDay(day : Date) -> [TaskVO] {
        let filteredTaskList =  viewModel.allTaskBehaviorRelay.value.filter({ (task) -> Bool in
            XTDateFormatterStruct.xt_defaultDateFormatter().string(from: task.startDate!) == XTDateFormatterStruct.xt_defaultDateFormatter().string(from: day)
        })
        print(day)
        print(filteredTaskList)
        return filteredTaskList
    }
    
    private func getStartDateForCurrentWeek() -> Date{
        let date = Date()
        let weekDayString = date.weekDayString()
        let fmt = DateFormatter()
        let weekDays = fmt.weekdaySymbols
        let neededDaysToSub = weekDays!.firstIndex(of: weekDayString)!
        return date.previousDay(decrease: neededDaysToSub)
    }
}

extension ScheduleViewController : WeekViewItemTableViewCellDelegate {
    func scrollup() {
        if tableViewWeek.contentOffset.y < tableViewWeek.contentSize.height {
            tableViewWeek.contentOffset.y += 5
        }
    }
    
    func scrollDown() {
        if tableViewWeek.contentOffset.y > 0 {
            tableViewWeek.contentOffset.y -= 5
        }
    }
    
    func didDrop(taskToUpdate: TaskVO) {
        if NetworkManager.checkReachable() {
             viewModel.updateTask(taskToUpdate: taskToUpdate)
        } else {
            AlertManager.showNoInternetConnectionMessage(inViewController: self)
            tableViewWeek.reloadData()
        }
       
    }
}
