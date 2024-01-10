//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by Pulapa Sai Kiran on 09/01/24.
//
import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!

    var onTaskAdded: ((Task) -> Void)?
    
    
    let categories = ["Personal", "Work", "Meeting", "Shopping"]

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        dueDatePicker.backgroundColor = UIColor.red
        view.backgroundColor = UIColor.black
    }

    @IBAction func saveTask(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let description = descriptionTextField.text else {
            return
        }

        let dueDate = dueDatePicker.date
        let priorityIndex = prioritySegmentedControl.selectedSegmentIndex
        let priority = Priority(rawValue: priorityIndex == 0 ? "Low" : (priorityIndex == 1 ? "Medium" : "High")) ?? .low

        let statusIndex = statusSegmentedControl.selectedSegmentIndex
        let status = Status(rawValue: statusIndex == 0 ? "New" : (statusIndex == 1 ? "In Progress" : "Completed")) ?? .new

        
        let selectedCategoryIndex = categoryPickerView.selectedRow(inComponent: 0)
        let category = categories[selectedCategoryIndex]

        let newTask = Task(id: 0, title: title, description: description, dueDate: dueDate, priority: priority, category: category, status: status)

        onTaskAdded?(newTask)
        DatabaseManager.shared.saveTask(task: newTask)
        dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
}
