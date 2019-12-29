//
//  CreateNewTaskViewController.swift
//  To-Do
//
//  Created by sawpyaehtun on 08/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Firebase

class CreateNewTaskViewController: BaseViewController {
    
    
    @IBOutlet weak var btnCreateNewTask: RoundedCornerButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var switchRemindMe: UISwitch!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var tfTeskTitle: UITextField!
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var lblSelectedStartEndTime: UILabel!
    
    var selectedIndex = 0
    var categoryList : [CategoryVO] = []
    let viewModel = CreateNewTaskViewModel()
    var isEmptyTask = false
    //    var startDate = Date()
    //    var endDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideLoading()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnBack.isHidden = isEmptyTask
        viewModel.selectedCategoryIndex.accept(selectedIndex)
        viewModel.categoryTitleBehaviorRelay.accept((categoryList[selectedIndex].name) ?? "")
        viewModel.categoryListBehaviorRelay.accept(categoryList)
        lblCategoryTitle.text = categoryList[selectedIndex].name
    }
    
    override func setUpUIs() {
        super.setUpUIs()
        tfTeskTitle.delegate = self
    }
    
    override func bindModel() {
        super.bindModel()
        viewModel.bindViewModel(in: self)
    }
    
    override func bindData() {
        super.bindData()
        
//        viewModel.selectedCategoryIndex.subscribe(onNext: { (index) in
//            let categoryList = self.viewModel.categoryListBehaviorRelay.value
//            if !categoryList.isEmpty {
//                self.viewModel.categoryTitleBehaviorRelay.accept((categoryList[index].name) ?? "")
//            }
//        }).disposed(by: disposableBag)
        tfTeskTitle.rx.text.orEmpty.bind(to: viewModel.taskTitleBehaviorRelay).disposed(by: disposableBag)
        viewModel.categoryTitleBehaviorRelay.bind(to: lblCategoryTitle.rx.text).disposed(by: disposableBag)
        viewModel.isCreateNewTaskBtnEnable.bind(to: btnCreateNewTask.rx.isEnabled).disposed(by: disposableBag)
        switchRemindMe.rx.value.subscribe(onNext: { (isOn) in
            self.viewModel.isRemaindMeBehaviorRelay.accept(isOn)
        }).disposed(by: disposableBag)
        
        viewModel.categoryListBehaviorRelay.subscribe(onNext: { (categoryList) in
            if !categoryList.isEmpty {
                self.lblCategoryTitle.text = categoryList[0].name
            }
        }).disposed(by: disposableBag)
        
        viewModel.selectedDayObserable.bind(to: lblSelectedDate.rx.text).disposed(by: disposableBag)
        viewModel.startTimeEndTimeObserable.bind(to: lblSelectedStartEndTime.rx.text).disposed(by: disposableBag)
    }
}

// user interactions
extension CreateNewTaskViewController {
    
    @IBAction func didTapCategory(_ sender: Any) {
        
        let pickerTitle = "Category"
        let values = viewModel.categoryListBehaviorRelay.value.map { (category) -> String in
            return category.name!
        }
        
        ActionSheetPickerWireframe.showPicker(pickerTitle, displayDataArray: values, initialSelection: viewModel.selectedCategoryIndex.value > 0 ? viewModel.selectedCategoryIndex.value : 0, doneBlock: { (picker, index, string) in
            //            if index < values.count {
            //                self.lblCategoryTitle.text = self.viewModel.categoryListBehaviorRelay.value[index].name
            //        self.viewModel.categoryTitleBehaviorRelay.accept(self.viewModel.categoryListBehaviorRelay.value[index].name!)
            //            } else {
            //                self.lblCategoryTitle.text = string as? String ?? ""
            //            }
            self.viewModel.selectedCategoryIndex.accept(index)
            self.view.endEditing(true)
        }, sender: (sender as? UIView)!)
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        dismissThis(animated: true)
    }
    
    @IBAction func didTapCreateTask(_ sender: Any) {
        if NetworkManager.checkReachable() {
            viewModel.createNewTask()
            dismissThis(animated: true)
        } else {
            AlertManager.showNoInternetConnectionMessage(inViewController: self)
        }
    }
    
    @IBAction func didTapBtnStartEndTime(_ sender: Any) {
        self.showLoading()
        goToTimeViewController()
    }
    
    @IBAction func didTapBtnSelectDate(_ sender: Any) {
        self.showLoading()
        goToCalendarViewController()
    }
}

extension CreateNewTaskViewController {
    private func goToCalendarViewController(){
        let vc = CalendarViewController.init()
        vc.delegate = self
        vc.selectedDate = viewModel.startDateBehaviorRelay.value
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func goToTimeViewController(){
        let vc = TimeViewController.init()
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.startDate = viewModel.startDateBehaviorRelay.value
        vc.endDate = viewModel.endDateBehaviorRelay.value
        present(vc, animated: true, completion: nil)
    }
}

extension CreateNewTaskViewController : TimeViewControllerDelegate {
    func didSelectTime(startDate: Date, endDate: Date) {
        self.viewModel.didSelectTime(startTime: startDate, endTime: endDate)
    }
}

extension CreateNewTaskViewController : CalendarViewControllerDelegate{
    func didSelectDate(selectedDate: Date) {
        self.viewModel.didSelectDate(selectedDate: selectedDate)
    }
}

extension CreateNewTaskViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
