//
//  TaskListViewController.swift
//  ToDoListApp
//
//  Created by Pulapa Sai Kiran on 09/01/24.
//


import UIKit

class TaskListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("reloadData"), object: nil)
        loadTasks()
        navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20.0)
            ]

        title = "To Do List"
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
                tableView.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
    }
    
    @objc private func reloadData() {
        loadTasks()
    }

    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addTaskButtonTapped() {
        navigateToAddTaskViewController()
    }

    private func navigateToAddTaskViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addTaskViewController = storyboard.instantiateViewController(withIdentifier: "AddTaskViewController") as? AddTaskViewController {
            let navigationController = UINavigationController(rootViewController: addTaskViewController)
            
            addTaskViewController.onTaskAdded = { [weak self] task in
    
                        self?.tasks.append(task)
                        self?.tableView.reloadData()
                    }

            navigationController.modalPresentationStyle = .fullScreen
            present(navigationController, animated: true, completion: nil)
            
            
        }
    }

    private func loadTasks() {
        tasks = DatabaseManager.shared.loadTasks()

        print(tasks)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.configureCell(with: task)

        switch task.priority {
        case Priority(rawValue: "Low") ?? .low:
            cell.backgroundColor = UIColor.green
        case Priority(rawValue: "Medium") ?? .medium:
            cell.backgroundColor = UIColor.yellow
        case Priority(rawValue: "High") ?? .high:
            cell.backgroundColor = UIColor.red
        default:
            cell.backgroundColor = UIColor.white
        }

        return cell
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedTask = tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            DatabaseManager.shared.deleteTask(task: deletedTask)
           
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 150.0
    }
    

}
