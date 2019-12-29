//
//  TaskItemTableViewCell.swift
//  To-Do
//
//  Created by sawpyaehtun on 07/12/2019.
//  Copyright © 2019 Ye Ko Ko Htet. All rights reserved.
//

import UIKit

class TaskItemTableViewCell: BaseTableViewCell {
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStartTimeEndTime: UILabel!
    @IBOutlet weak var imgCompleteFail: UIImageView!
    @IBOutlet weak var viewTaskBackground: CardView!
    
    var themeOFTask : String?
    
    var task : TaskVO? {
        didSet {
            guard let task = task else {return}
            lblTaskTitle.text = task.title
            lblDate.text = XTDateFormatterStruct.xt_TaskDateFormatter().string(from: task.startDate!)
            
            if task.taskState == TaskState.normal.rawValue {
                lblDate.textColor = .gray
                lblStartTimeEndTime.textColor = .gray
                lblTaskTitle.textColor = .black
            } else {
                lblDate.textColor = .white
                lblStartTimeEndTime.textColor = .white
                lblTaskTitle.textColor = .white
            }
            
            switch task.taskState {
            case TaskState.normal.rawValue:
                imgCompleteFail.isHidden = true
                viewTaskBackground.backgroundColor = .white
                viewTaskBackground.borderColor = .gray
                lblStartTimeEndTime.text = XTDateFormatterStruct.xt_24HourFormatTimeFormatter().string(from: task.startDate!) + " - " + XTDateFormatterStruct.xt_24HourFormatTimeFormatter().string(from: task.endDate!)
            case TaskState.completed.rawValue:
                imgCompleteFail.isHidden = false
                imgCompleteFail.image = UIImage(systemName: "checkmark.square.fill")
                lblStartTimeEndTime.text = "COMPLETED!"
                if let theme = themeOFTask {
                    switch theme {
                    case themes.purple.rawValue:
                        viewTaskBackground.backgroundColor = themes.purple.getBackGroundColor()
                        viewTaskBackground.borderColor = .lightGray
                    case themes.yellow.rawValue:
                        viewTaskBackground.backgroundColor = themes.yellow.getBackGroundColor()
                        viewTaskBackground.borderColor = .lightGray
                    case themes.blue.rawValue:
                        viewTaskBackground.backgroundColor = themes.blue
                            .getBackGroundColor()
                        viewTaskBackground.borderColor = .lightGray
                    case themes.maroon.rawValue:
                        viewTaskBackground.backgroundColor = themes.maroon.getBackGroundColor()
                        viewTaskBackground.borderColor = .lightGray
                    default:
                        break
                    }
                }
            case TaskState.failed.rawValue:
                imgCompleteFail.isHidden = false
                imgCompleteFail.image = UIImage(systemName: "exclamationmark.triangle.fill")
                viewTaskBackground.backgroundColor = .red
                viewTaskBackground.borderColor = .lightGray
                lblStartTimeEndTime.text = "FAILED!"
                
            default:
                break
            }
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
