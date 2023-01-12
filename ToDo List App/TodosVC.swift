//
//  TodosVC.swift
//  ToDo List App
//
//  Created by SHUAA on 04/05/1444 AH.
//

import UIKit

class TodosVC: UIViewController {
    
    var todosArray = [
        Todo(title:" الذهاب للنادي" , image: #imageLiteral(resourceName: "image4"), details: "الساعة الرابعة مساء"),
        Todo(title:" ممارسة الرياضة",image: #imageLiteral(resourceName: "Image 1"),details: "مشي لمدة ٢٠ د"),
        Todo(title:" حل واجب",image: #imageLiteral(resourceName: "Image 2.png")),
        Todo(title:" التسوق"),
        Todo(title:" مشاهدة الكورس"),]
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        todosTableView.dataSource = self
        todosTableView.delegate = self
        //New Todo  Notification
        NotificationCenter.default.addObserver(self, selector: #selector(newTodoAdded), name: NSNotification.Name(rawValue:"NewTodoAdded"), object: nil)
        
        //Edit Todo  Notification
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentToDoEdited"), object: nil)
        
        //Delete Todo  Notification
        NotificationCenter.default.addObserver(self, selector: #selector(todoDeleted), name: NSNotification.Name(rawValue:"TodoDeleted"), object: nil)
    }
    @objc func newTodoAdded(notification: Notification){
   
        if let myTodo = notification.userInfo?["addTodo"] as? Todo {
            todosArray.append(myTodo)
            todosTableView.reloadData()
        }
    }
    @objc func currentTodoEdited(notification: Notification){
   
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedTodoIndex"] as? Int{
                todosArray[index] = todo
                todosTableView.reloadData()
            }
        }
    }
    @objc func todoDeleted(notification: Notification){
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int{
            todosArray.remove(at: index)
            todosTableView.reloadData()
        }
    }
}

extension TodosVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TodoCell
        
        cell.todoTitleLabel.text = todosArray[indexPath.row].title
        if todosArray[indexPath.row].image != nil {
            cell.todoImage.image = todosArray[indexPath.row].image
        }else{
            cell.todoImage.image = #imageLiteral(resourceName: "Image 3")
        }
        cell.todoImage.layer.cornerRadius = cell.todoImage.frame.width / 2

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let todo = todosArray[indexPath.row]
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as? TodoDeetailsVC
        if let viewController = vc {
            viewController.todo = todo
            viewController.index = indexPath.row
            navigationController?.pushViewController(viewController, animated: true)
        }

    }
    
}
