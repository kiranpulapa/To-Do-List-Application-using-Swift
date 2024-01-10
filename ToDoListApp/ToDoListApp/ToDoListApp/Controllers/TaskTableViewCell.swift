//
//  TaskTableViewCell.swift
//  ToDoListApp
//
//  Created by Pulapa Sai Kiran on 09/01/24.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func checkboxTapped(_ cell: TaskTableViewCell)
}

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton! // Add checkbox outlet

    weak var delegate: TaskTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCheckbox()
        checkboxButton.setTitle("", for: .normal)
        checkboxButton.setTitle("", for: .selected)
    }

    func configureCell(with task: Task) {
        titleLabel.text = task.title
        dueDateLabel.text = DateFormatter.localizedString(from: task.dueDate, dateStyle: .short, timeStyle: .short)
        priorityLabel.text = task.priority.rawValue
        categoryLabel.text = task.category
        checkboxButton.isSelected = task.status == .completed
   
    }

    @IBAction func checkboxTapped(_ sender: UIButton) {
        delegate?.checkboxTapped(self)
        checkboxButton.isSelected.toggle()
        updateCheckboxImage()
        print("Checkbox tapped")
    }
    
    private func updateCheckboxImage() {
           if checkboxButton.isSelected {
               checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
           } else {
               checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
           }
       }

    private func setupCheckbox() {
        checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        checkboxButton.tintColor = .systemBlue
        checkboxButton.isUserInteractionEnabled = true
    }
}
