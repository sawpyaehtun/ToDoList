//
//  CalendarViewController.swift
//  To-Do
//
//  Created by sawpyaehtun on 10/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

protocol CalendarViewControllerDelegate {
    func didSelectDate(selectedDate : Date)
}

class CalendarViewController: BaseViewController {
    
    @IBOutlet weak var viewYear: YearView!
    @IBOutlet weak var viewYearItems: YearPicker!
    @IBOutlet weak var tableViewMonthsOfYear: UITableView!
    
    var delegate : CalendarViewControllerDelegate?
    
    var selectedDate : Date?
    
    var currentUserSelectedYear : Int = 0
    
    var currentUserSelectedDate : Date = Date()
    
    let viewModel = CalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUIs() {
        setupTableView()
        if let date = selectedDate {
            currentUserSelectedDate = date
            currentUserSelectedYear = date.getCurrentYear()
        } else {
            currentUserSelectedYear = currentUserSelectedDate.getCurrentYear()
        }
        
        viewYearItems.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapYearView))
        viewYear.isUserInteractionEnabled = true
        viewYear.addGestureRecognizer(tapGestureRecognizer)
        
        viewYearItems.alpha = 0.0
        viewYearItems.center.x = UIScreen.main.bounds.width
        
        viewYearItems.setSelectedYear(selectedYear: currentUserSelectedYear)
        viewYear.lblYear.text = String(currentUserSelectedYear)
        viewYear.year = currentUserSelectedYear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         reloadTableView()
    }
    
    private func reloadTableView(){
        tableViewMonthsOfYear.reloadData()
        if currentUserSelectedYear == currentUserSelectedDate.getCurrentYear(){
            let indexPath:IndexPath = IndexPath(row: currentUserSelectedDate.getCurrentMonth() - 1, section: 0)
            tableViewMonthsOfYear.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
    
    
    private func setupTableView(){
        tableViewMonthsOfYear.delegate = self
        tableViewMonthsOfYear.dataSource = self
        
        tableViewMonthsOfYear.registerForCell(strID: String(describing: MonthItemTableViewCell.self))
        
        //        tableViewMonthsOfYear.estimatedRowHeight = UIScreen.main.bounds.height / 3
        tableViewMonthsOfYear.rowHeight =  UIScreen.main.bounds.height / 2
    }
    
    override func bindModel() {
        super.bindModel()
        viewModel.bindViewModel(in: self)
    }
    
}

// user interaction
extension CalendarViewController {
    
    @objc func didTapYearView(){
        showYearItemsAndHideYearView()
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        delegate?.didSelectDate(selectedDate: currentUserSelectedDate)
        dismissThis(animated: true)
    }
    @IBAction func didTapCancel(_ sender: Any) {
        dismissThis(animated: true)
    }
    
}

// show/hide yearItemView and yearView
extension CalendarViewController {
    
    private func showYearItemsAndHideYearView(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.viewYear.center.x += self.viewYear.frame.width
            self.viewYear.alpha = 0.0
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.viewYearItems.center.x = self.view.center.x
                self.viewYearItems.alpha = 1.0
            }, completion: nil)
        }
    }
    
    private func hideYearItemsAndShowYearView(){
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.viewYearItems.center.x += UIScreen.main.bounds.width
            self.viewYearItems.alpha = 0.0
        }) { (_) in
            self.viewYear.center.x += self.viewYear.frame.width
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                print(self.viewYear.center.x)
                self.viewYear.center.x -= self.viewYear.frame.width
                print(self.viewYear.center.x)
                self.viewYear.alpha = 1.0
            }, completion: nil)
        }
    }
    
}

extension CalendarViewController : UITableViewDelegate {
    
}

extension CalendarViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MonthItemTableViewCell.self), for: indexPath) as! MonthItemTableViewCell
        cell.monthForThisItem = indexPath.row + 1
        cell.delegate = self
        cell.currentUserSelectedDate = currentUserSelectedDate
        cell.startDate = getStartDateForMonth(month: indexPath.row + 1)
        return cell
    }
}

extension CalendarViewController {
    private func getStartDateForMonth(month : Int) -> Date{
        let date = Date.from(year: currentUserSelectedYear, month: month, day: 1)
        let weekDayString = date.weekDayString()
        let fmt = DateFormatter()
        var weekDays = fmt.weekdaySymbols
        let firstWeekDay = weekDays![0]
        weekDays?.remove(at: 0)
        weekDays?.append(firstWeekDay)
        let neededDaysToSub = weekDays!.firstIndex(of: weekDayString)!
        return date.previousDay(decrease: neededDaysToSub)
    }
}


extension CalendarViewController : YearPickerDelegate {
    func didSelectYear(year: Int) {
        hideYearItemsAndShowYearView()
        viewYear.year = year
        currentUserSelectedYear = year
        viewYear.lblYear.text = String(year)
        tableViewMonthsOfYear.reloadData()
    }
}

extension CalendarViewController : MonthItemTableViewCellDelegate {
    func didSelectDate(selectedDate: Date) {
        currentUserSelectedDate = selectedDate
        tableViewMonthsOfYear.reloadData()
    }
}

