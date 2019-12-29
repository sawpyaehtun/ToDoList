//
//  WeekViewItemTableViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 17/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol WeekViewItemTableViewCellDelegate {
    func didDrop(taskToUpdate : TaskVO)
    func scrollup()
    func scrollDown()
}

class WeekViewItemTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var scrollViewEvents: UIScrollView!
    
    var dayArr : [Date] = []
    var dragCellSnapshot: SnapShotCellForWeekView?
    var delegate : WeekViewItemTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupcell(taskList : [TaskVO], categoryList : [CategoryVO], daysInCurrentWeek : [Date]){
        self.scrollViewEvents.subviews.forEach({ $0.removeFromSuperview() })
        self.dayArr = daysInCurrentWeek
        scrollViewEvents.delegate = self
        scrollViewEvents.bounces = false
        let taskItemBackgroundWidth = UIScreen.main.bounds.width / 4
        let taskItemBackgroundHeight = scrollViewEvents.bounds.size.height
        scrollViewEvents.contentSize.width = taskItemBackgroundWidth * 7
        let upperConstraint = 24
        let taskCardPadding = 5
        let viewHightPerHour = 100
        
        
        for i in 0 ..< daysInCurrentWeek.count {
            
            let taskItemBackgroundView = TaskViewBackgroundOfWeekView(frame: CGRect(x: taskItemBackgroundWidth * CGFloat(i), y: 0, width: taskItemBackgroundWidth, height: taskItemBackgroundHeight))
            
            scrollViewEvents.addSubview(taskItemBackgroundView)
            
            let taskListInDay = taskList.filter { (task) -> Bool in
                XTDateFormatterStruct.xt_defaultDateFormatter().string(from: task.startDate!) == XTDateFormatterStruct.xt_defaultDateFormatter().string(from: daysInCurrentWeek[i])
            }
            
            taskListInDay.forEach { (task) in
                
                let categoryOftask = categoryList.filter { (category) -> Bool in
                    category.id == task.categoryId
                }
                
                guard let startHour = task.startDate?.getCurrentHour() else {return}
                guard let startMinute = task.startDate?.getCurrentMinute() else {return}
                let startXposition = (viewHightPerHour * startHour) + (startMinute * (viewHightPerHour / 60))
                
                guard let endHour = task.endDate?.getCurrentHour() else {return}
                guard let endMinute = task.endDate?.getCurrentMinute() else {return}
                let endXposition = (viewHightPerHour * endHour) + (endMinute * (viewHightPerHour / 60))
                
                let taskCardHeight = endXposition - startXposition
                //                print(taskCardHeight)
                let taskViewOfWeekView = TaskViewOfWeekView()
                taskItemBackgroundView.addSubview(taskViewOfWeekView)
                
                taskViewOfWeekView.snp.makeConstraints { (make) in
                    make.top.equalToSuperview().inset(startXposition + upperConstraint - taskCardPadding)
                    make.leading.equalToSuperview()
                    make.trailing.equalToSuperview()
                    make.height.equalTo(taskCardHeight + (taskCardPadding * 2))
                }
                
                let logPressGestrue = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress(sender:)))
                taskViewOfWeekView.isUserInteractionEnabled = true
                taskViewOfWeekView.addGestureRecognizer(logPressGestrue)
                
                taskViewOfWeekView.task = task
                taskViewOfWeekView.taskTheme = categoryOftask.first?.theme
            }
        }
    }
}

extension WeekViewItemTableViewCell {
    @objc func didTapLongPress(sender: UILongPressGestureRecognizer) {
        
        guard let task = (sender.view as! TaskViewOfWeekView).task else {return}
        
        let locationInView = sender.location(in: scrollViewEvents)
        
        if sender.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            dragCellSnapshot = snapshotOfCell(inputView: sender.view!)
            dragCellSnapshot?.alpha = 0.0
            scrollViewEvents.addSubview(dragCellSnapshot!)
            guard var center  = sender.view?.center else { return}
            dragCellSnapshot?.center = center
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                center = locationInView
                self.dragCellSnapshot?.transform = (self.dragCellSnapshot?.transform.scaledBy(x: 0.9, y: 0.9))!
                self.dragCellSnapshot?.alpha = 0.99
                
            }, completion: { (finished) -> Void in
                if finished {
                    //                        cell?.isHidden = true
                    sender.view?.alpha = 0.4
                    self.dragCellSnapshot?.center = center
                }
            })
        } else if sender.state == .changed {
            
            if let dragCellPositionInYAxis = dragCellSnapshot?.superview?.convert((dragCellSnapshot?.frame.origin)!, to: nil).y {
                print(dragCellPositionInYAxis)
                if dragCellPositionInYAxis >= UIScreen.main.bounds.height - 200 {
                    print(true)
                    self.delegate!.scrollup()
                }
                
                if dragCellPositionInYAxis <= 300 {
                    print(false)
                    self.delegate!.scrollDown()
                }
            }
            
            //            print("dragcell position x \(dragCellPositionInXAxis)")
            //                            print("content size with : \(scrollViewEvents.contentSize.width)")
            //                            print("content offset x : \(scrollViewEvents.contentOffset.x)")
            //                            print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
            
            if let dragCellPositionInXAxis = dragCellSnapshot?.superview?.convert((dragCellSnapshot?.frame.origin)!, to: nil).x {
                
                //                print("dragcell position x \(dragCellPositionInXAxis)")
                //                print("content size with : \(scrollViewEvents.contentSize.width)")
                //                print("content offset sieze : \(scrollViewEvents.contentOffset.x)")
                //                print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
                
                //                if dragCellPositionInXAxis >= UIScreen.main.bounds.width - 80 {
                //                    if self.scrollViewEvents.contentOffset.x < 382.5 {
                //                        self.scrollViewEvents.contentOffset.x += 5
                //                    }
                //
                
                print("\(dragCellPositionInXAxis + 200)")
                
                print(dragCellSnapshot?.center.x)
                
                //                if dragCellPositionInXAxis + 200 <= 300 {
                //                    if self.scrollViewEvents.contentOffset.x > 0 {
                //
                //                        print("content size with : \(scrollViewEvents.contentSize.width)")
                //                        print("content offset x : \(scrollViewEvents.contentOffset.x)")
                //                        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
                //                        self.scrollViewEvents.contentOffset.x -= 5
                //                    }
                //                }
                
            }
            
            //                if dragCellPositionInXAxis <= 100 {
            //                    if (dragCellSnapshot?.center.x)!  > 0 {
            //                        self.scrollViewEvents.contentOffset.x -= 5
            //                    }
            //                }
            //                    if self.scrollViewEvents.contentOffset.x < self.scrollViewEvents.contentSize.width {
            //                        print(scrollViewEvents.contentOffset.x < self.scrollViewEvents.contentSize.width)
            //
            ////                    self.scrollViewEvents.contentOffset.x += 5
            //                }
            
            //                }
            
            //                if dragCellPositionInXAxis <= 80 && scrollViewEvents.contentOffset.x > 0 {
            //                    self.scrollViewEvents.contentOffset.x -= 5
            //                }
            
            //            }
            //        print(-contentOffset)
            //            let contentHeight = scrollViewEvents.contentSize.height
            
            
            //            print("frame : \(dragCellSnapshot?.superview?.convert((dragCellSnapshot?.frame.origin)!, to: nil).y)")
            //            print("bounds : \(dragCellSnapshot?.bounds.origin.y)")
            
            var center = dragCellSnapshot?.center
            center? = locationInView
            dragCellSnapshot?.center = center!
            
            let startPostionX = (dragCellSnapshot?.frame.origin.y)! + 26
            
            let hour = Int(startPostionX / 100)
            let indexforMinutes = (startPostionX / 100) - CGFloat(hour)
            let minutes = Int(indexforMinutes * 60)
            
            dragCellSnapshot?.hour = hour
            dragCellSnapshot?.minutes = minutes
            
        } else if sender.state == .ended  {
            
            let timeInterval = task.endDate!.timeIntervalSince(task.startDate!)
            let dateIndex = Int((dragCellSnapshot?.center.x)! / (UIScreen.main.bounds.width / 4))
            let dateToGetDayMonthYear = dayArr[dateIndex]
            
            let startDate = Date.from(year: dateToGetDayMonthYear.getCurrentYear(),
                                      month: dateToGetDayMonthYear.getCurrentMonth(),
                                      day: dateToGetDayMonthYear.getCurrentDay(),
                                      hour: dragCellSnapshot?.hour ?? 0,
                                      minute: dragCellSnapshot?.minutes ?? 0)
            
            let endDate = startDate.addingTimeInterval(timeInterval)
            let taskToUpdate = TaskVO(id: task.id, remindMe: task.remindMe, title: task.title, startDate: startDate, endDate: endDate, taskState: 0, categoryId: task.categoryId)
            
            delegate?.didDrop(taskToUpdate: taskToUpdate)
            
            sender.view?.removeFromSuperview()
            
        }
    }
    
    func snapshotOfCell(inputView: UIView) -> SnapShotCellForWeekView {
        
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let cellSnapshot = UIImageView(image: image)
        
        let snapShotCellForWeekView = SnapShotCellForWeekView()
        snapShotCellForWeekView.viewSnapShot.addSubview(cellSnapshot)
        
        cellSnapshot.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        snapShotCellForWeekView.snp.makeConstraints { (make) in
            make.height.equalTo(inputView.bounds.height + 48)
        }
        
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 10.0
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return snapShotCellForWeekView
    }
}

extension WeekViewItemTableViewCell : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        ScrollPositionManager.shared.scrollContentOffsetX.accept(scrollView.contentOffset.x)
    }
}

extension WeekViewItemTableViewCell {
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
