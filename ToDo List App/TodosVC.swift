//
//  TodosVC.swift
//  ToDo List App
//
//  Created by SHUAA on 04/05/1444 AH.
//

import UIKit
import CoreData

class TodosVC: UIViewController {
    
    var todosArray:[Todo] = []
    @IBOutlet weak var todosTableView: UITableView!
    override func viewDidLoad() {
        self.todosArray = getTodos()
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
            storeTodo(todo: myTodo)
        }
    }
    @objc func currentTodoEdited(notification: Notification){
   
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            if let index = notification.userInfo?["editedTodoIndex"] as? Int{
                todosArray[index] = todo
                todosTableView.reloadData()
                updateTodo(todo: todo, index: index)
            }
        }
    }
    @objc func todoDeleted(notification: Notification){
        if let index = notification.userInfo?["deletedTodoIndex"] as? Int{
            todosArray.remove(at: index)
            todosTableView.reloadData()
            deleteTodo(index: index)
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
    // Core Data section
    func storeTodo(todo:Todo){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate
        else{return}
        
        let managedContext = appdelegate.persistentContainer.viewContext
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext) else { return }
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: managedContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        if let image = todo.image {
            let imageData = image.jpegData(compressionQuality: 1)
            todoObject.setValue(imageData, forKey: "image")
        }
        do{
            try managedContext.save()
            print("successssssssssss")

        }
        catch{
         print("erroooooor")
     }
    }
    func updateTodo(todo:Todo,index:Int){
   
        guard let appDeleget = UIApplication.shared.delegate as? AppDelegate else
        {return }
        let context = appDeleget.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            if let image = todo.image{
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
            }
            
            try context.save()
            
            
        }catch{"errrooooorrrrr"}
    }
    
    func deleteTodo(index:Int){
        
        guard let appDeleget = UIApplication.shared.delegate as? AppDelegate else
        {return }
        let context = appDeleget.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let todoToDelete = result[index]
            context.delete(todoToDelete)
            try context.save()
            
            
        }catch{ "errrooooorrrrr"}
    }
    func getTodos() -> [Todo]{
        var todos: [Todo] = []
        guard let appDeleget = UIApplication.shared.delegate as? AppDelegate else{return[]}
        let context = appDeleget.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        do{
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            for managedTodo in result{
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                
                var todoImage: UIImage? = nil
                if let imageFromContext = managedTodo.value(forKey: "image") as? Data {
                    todoImage = UIImage(data: imageFromContext)
                }
                let todo = Todo(title: title ?? "",image:  todoImage , details: details ?? "")
                todos.append(todo)
                
            }
            
        }catch{ "errrooooorrrrr"}
        return todos
    }
    
}
