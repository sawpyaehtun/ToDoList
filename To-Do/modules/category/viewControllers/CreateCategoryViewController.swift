//
//  CreateCategoryViewController.swift
//  To-Do
//
//  Created by sawpyaehtun on 13/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateCategoryViewController: BaseViewController {
    
    @IBOutlet weak var tfCategoryTitle: UITextField!
    @IBOutlet weak var tableViewTheme: UITableView!
    @IBOutlet weak var btnCreateCategory: RoundedCornerButton!
    
    var viewModel = CreateCategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func bindModel() {
        super.bindModel()
        viewModel.bindViewModel(in: self)
    }
    
    override func bindData() {
        super.bindData()
        
        viewModel.isEnableCreateCategory.bind(to: btnCreateCategory.rx.isEnabled).disposed(by: disposableBag)
        tfCategoryTitle.rx.text.orEmpty.bind(to: viewModel.categoryName).disposed(by: disposableBag)
        viewModel.themeListSelectedIndex.subscribe(onNext: { (_) in
            self.tableViewTheme.reloadData()
            }).disposed(by: disposableBag)
        viewModel.themeListBehaviorRelay.bind(to: tableViewTheme.rx.items(cellIdentifier: String(describing: ThemeItemTableViewCell.self), cellType: ThemeItemTableViewCell.self)){ row, model, cell in
            cell.categoryName = self.viewModel.categoryName.value
            switch model.theme {
            case themes.purple.rawValue :
                cell.theme = .purple
            case themes.yellow.rawValue :
                cell.theme = .yellow
            case themes.blue.rawValue :
                cell.theme = .blue
            case themes.maroon.rawValue :
                cell.theme = .maroon
            default :
                cell.theme = .purple
            }
            cell.isSelectedIndex = (self.viewModel.themeListSelectedIndex.value == row)
        }.disposed(by: disposableBag)
        
        tableViewTheme.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.viewModel.themeListSelectedIndex.accept(indexPath.row)
        }).disposed(by: disposableBag)
        
    }
    
    @IBAction func didTapCreateCategory(_ sender: Any) {
        if NetworkManager.checkReachable() {
            viewModel.createCategory()
            dismissThis(animated: true)
        } else {
            AlertManager.showNoInternetConnectionMessage(inViewController: self)
        }
        
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        dismissThis(animated: true)
    }
    
    override func setUpUIs() {
        super.setUpUIs()
        setUPTableView()
    }
    
    private func setUPTableView(){
        tableViewTheme.registerForCell(strID: String(describing: ThemeItemTableViewCell.self))
        tableViewTheme.rowHeight = UIScreen.main.bounds.height * 0.1
        tableViewTheme.separatorStyle = .none
    }
    
}
