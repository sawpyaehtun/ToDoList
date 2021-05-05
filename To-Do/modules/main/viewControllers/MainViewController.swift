//
//  MainViewController.swift
//  To-Do
//
//  Created by sawpyaehtun on 07/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    @IBOutlet weak var btnAddNewTask: RoundedCornerButton!
    @IBOutlet weak var tableViewCategoryList: UITableView!
    @IBOutlet weak var tableViewTaskList: UITableView!
    @IBOutlet weak var lblTitleCategory: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgEdit: UIImageView!
    @IBOutlet weak var viewEditCategoryTextField: UIView!
    @IBOutlet weak var tfCategoryField: UITextField!
    
    
    let viewModel = MainViewModel()
    var taskList : [TaskVO] = [] {
        didSet {
            tableViewTaskList.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUIs() {
        super.setUpUIs()
        setUpTableViews()
    }
    
    
    private func setUpTableViews(){
        
        tableViewTaskList.delegate = self
        tableViewTaskList.dataSource = self
                
        tableViewTaskList.registerForCell(strID: String(describing: TaskItemTableViewCell.self))
        tableViewCategoryList.registerForCell(strID: String(describing: CategoryItemTableViewCell.self))
        tableViewCategoryList.rowHeight = UIScreen.main.bounds.width * 0.22 * 0.7
        tableViewTaskList.separatorStyle = .none
        tableViewCategoryList.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getAllCategory()
        viewModel.getAllTask()
    }
    
    override func bindModel() {
        super.bindModel()
        viewModel.bindViewModel(in: self)
    }
    
    override func bindData() {
        super.bindData()
        viewModel.isDoneBtnEnable.bind(to: btnDone.rx.isEnabled).disposed(by: disposableBag)
        tfCategoryField.rx.text.orEmpty.bind(to: viewModel.tfcategoryTitleBehaviorRealy).disposed(by: disposableBag)
        
        viewModel.isSuccessLogoutBehaviorRelay.subscribe(onNext: { (isSuccessed) in
            if isSuccessed {
                AlertManager.showAlert("Logout", message: "You are successfully logout!", inViewController: self)
                self.gotoLoginScreen()
            }
            }).disposed(by: disposableBag)
        viewModel.selectedIndexInCategoryListBehaviorRelay.subscribe(onNext: { (index) in
            self.changeAddNewTaskBtnColorAndReloadCategoryTableView(index: index)
        }).disposed(by: disposableBag)
        
        viewModel.taskListB4Current.subscribe(onNext: { (taskList) in
            self.showAlertsForTasksB4CurrentTime(tasksForAlert: taskList)
        }).disposed(by: disposableBag)
        
        viewModel.titleCategoryOfTaskBehaviorRealy.bind(to: lblTitleCategory.rx.text).disposed(by: disposableBag)
        
        viewModel.isEmptyTaskBehaviorRealy.subscribe(onNext: { (isEmptyTask) in
            if isEmptyTask && !self.viewModel.categoryListBehaviorRelay.value.isEmpty{
                self.goToCreateNewTask()
            }
        }).disposed(by: disposableBag)
        
        viewModel.categoryListBehaviorRelay.subscribe(onNext: { (categoryList) in
            if !categoryList.isEmpty && self.viewModel.isEmptyTaskBehaviorRealy.value {
                self.goToCreateNewTask()
            }
        }).disposed(by: disposableBag)
        
        viewModel.categoryListBehaviorRelay.bind(to: tableViewCategoryList.rx.items(cellIdentifier: String(describing: CategoryItemTableViewCell.self), cellType: CategoryItemTableViewCell.self)){ row, model, cell in
            cell.category = model
            cell.isSelectedIndex = (self.viewModel.selectedIndexInCategoryListBehaviorRelay.value == row)
        }.disposed(by: disposableBag)
        
        viewModel.taskListFilteredByCategoryObserable.subscribe(onNext: { (taskList) in
            self.taskList = taskList
        }).disposed(by: disposableBag)
        
        tableViewCategoryList.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.viewModel.selectedIndexInCategoryListBehaviorRelay.accept(indexPath.row)
            self.updateUIForDidTapBtnDone()
        }).disposed(by: disposableBag)
        
    }
    
}

// MARK: - UI update
extension MainViewController {
    
    private func changeAddNewTaskBtnColorAndReloadCategoryTableView(index : Int){
        let categoryList = viewModel.categoryListBehaviorRelay.value
        if !categoryList.isEmpty {
            switch categoryList[index].theme {
            case themes.purple.rawValue:
                btnAddNewTask.backgroundColor = themes.purple.getBackGroundColor()
            case themes.yellow.rawValue:
                btnAddNewTask.backgroundColor = themes.yellow.getBackGroundColor()
            case themes.blue.rawValue:
                btnAddNewTask.backgroundColor = themes.blue.getBackGroundColor()
            case themes.maroon.rawValue:
                btnAddNewTask.backgroundColor = themes.maroon.getBackGroundColor()
            default:
                btnAddNewTask.backgroundColor = themes.purple.getBackGroundColor()
            }
        } else {
            self.btnAddNewTask.backgroundColor = themes.purple.getBackGroundColor()
        }
        tableViewCategoryList.reloadData()
    }
    
    private func showAlertsForTasksB4CurrentTime(tasksForAlert : [TaskVO]){
        var  tasks = tasksForAlert
        
        if !tasks.isEmpty {
            let task = tasks.first
            
            let completedAction = UIAlertAction(title: "Of Course", style: .default) { (_) in
                // did tap complete task
                let completedTask = TaskVO(id: task?.id, remindMe: task?.remindMe, title: task?.title, startDate: task?.startDate, endDate: task?.endDate, taskState: TaskState.completed.rawValue, categoryId: task?.categoryId)
                self.viewModel.updteTask(task: completedTask)
                if tasks.count == 1 {
                    self.viewModel.getAllTask()
                } else {
                    tasks.remove(at: 0)
                    self.viewModel.taskListB4Current.accept(tasks)
                }
            }
            
            let failAction = UIAlertAction(title: "No", style: .default) { (_) in
                // did tap fail task
                let failTask = TaskVO(id: task?.id, remindMe: task?.remindMe, title: task?.title, startDate: task?.startDate, endDate: task?.endDate, taskState: TaskState.failed.rawValue, categoryId: task?.categoryId)
                self.viewModel.updteTask(task: failTask)
                if tasks.count == 1 {
                    self.viewModel.getAllTask()
                } else {
                    tasks.remove(at: 0)
                    self.viewModel.taskListB4Current.accept(tasks)
                }
            }
            
            let endTime = XTDateFormatterStruct.xt_defaultDateTimeFormatter().string(from: task?.endDate ?? Date())
            AlertManager.showAlertForTask("Did you complete this task at \(endTime)", message: task?.title, completeAction: completedAction, failAction: failAction, inViewController: self)
        }
    }
    
    
}

//MARK: - user interactions
extension MainViewController {
    
    @IBAction func didTapSchedule(_ sender: Any) {
        gotoSchedule()
    }
    
    @IBAction func didTapBtnEdit(_ sender: Any) {
        hideBtnEditAndShowBtnDone()
        hideLblCategoryTitleAndShowViewEditCategoryTitle()
        tableViewTaskList.isEditing = true
    }
    
    @IBAction func didTapBtnDone(_ sender: Any) {
        viewModel.updateCtegory()
        updateUIForDidTapBtnDone()
    }
    
    @IBAction func didTapAddNewTask(_ sender: Any) {
        goToCreateNewTask()
    }
    
    @IBAction func didTapAddNewCategory(_ sender: Any) {
        goToCreateNewCategory()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        viewModel.logout()
    }
    
}

//MARK: - hide show functions
extension MainViewController {
    
    private func updateUIForDidTapBtnDone(){
        showBtnEditAndHideBtndone()
        showLblCategoryTitleAndHideViewEditCategoryTitle()
        tableViewTaskList.isEditing = false
        view.endEditing(true)
    }
    
    private func hideLblCategoryTitleAndShowViewEditCategoryTitle(){
        tfCategoryField.text = lblTitleCategory.text
        viewModel.tfcategoryTitleBehaviorRealy.accept(lblTitleCategory.text ?? "")
        btnDone.isEnabled = true
        viewEditCategoryTextField.isHidden = false
        lblTitleCategory.isHidden = true
    }
    
    private func showLblCategoryTitleAndHideViewEditCategoryTitle(){
        viewEditCategoryTextField.isHidden = true
        lblTitleCategory.isHidden = false
    }
    
    private func hideBtnEditAndShowBtnDone(){
        btnEdit.isHidden = true
        imgEdit.isHidden = true
        btnDone.isHidden = false
        
    }
    
    private func showBtnEditAndHideBtndone(){
        btnEdit.isHidden = false
        imgEdit.isHidden = false
        btnDone.isHidden = true
        
    }
}

// MARK: - Navigation
extension MainViewController {
    private func goToCreateNewTask() {
        view.endEditing(true)
        self.viewModel.isEmptyTaskBehaviorRealy.accept(false)
        let vc = CreateNewTaskViewController.init()
        vc.modalPresentationStyle = .fullScreen
        if viewModel.isEmptyTaskBehaviorRealy.value {
            vc.isEmptyTask = true
        }
        vc.categoryList = viewModel.categoryListBehaviorRelay.value
        vc.selectedIndex = viewModel.selectedIndexInCategoryListBehaviorRelay.value
        present(vc, animated: true, completion: nil)
    }
    
    private func gotoSchedule() {
        let vc = ScheduleViewController.init()
        vc.modalPresentationStyle = .fullScreen
        vc.allTaskList = viewModel.allTaskListBehaviorRelay.value
        vc.categoryList = viewModel.categoryListBehaviorRelay.value
        present(vc, animated: true, completion: nil)
    }
    
    func goToCreateNewCategory() {
        let vc = CreateCategoryViewController.init()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    private func gotoLoginScreen(){
        let scence = UIApplication.shared.connectedScenes.first
        if let delegate = scence?.delegate as? SceneDelegate {
            delegate.setRootViewController()
        }
    }
}

//MARK: -Tableview delegate and datasource
extension MainViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TaskItemTableViewCell.self), for: indexPath) as! TaskItemTableViewCell
        cell.themeOFTask = viewModel.categoryListBehaviorRelay.value[viewModel.selectedIndexInCategoryListBehaviorRelay.value].theme
        cell.task = taskList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.delteTask(taskId: taskList[indexPath.row].id ?? "")
        }
    }
    
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        } else {
            return .none
        }
    }
}
