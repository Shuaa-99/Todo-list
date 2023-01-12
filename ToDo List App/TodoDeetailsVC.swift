//
//  TodoDeetailsVC.swift
//  ToDo List App
//
//  Created by SHUAA on 04/05/1444 AH.
//

import UIKit

class TodoDeetailsVC: UIViewController {

    var todo :Todo!
    var index: Int!
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var todoDetailsLabel: UILabel!
    @IBOutlet weak var todiTitleLablel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if todo.image != nil{
            todoImageView.image = todo.image
        }else{
            todoImageView.image = #imageLiteral(resourceName: "Image 2")
        }
       setuoUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentTodoEdited), name: NSNotification.Name(rawValue: "CurrentToDoEdited"), object: nil)
        
    }
    @objc func currentTodoEdited(notification: Notification){
   
        if let todo = notification.userInfo?["editedTodo"] as? Todo {
            self.todo = todo
           setuoUI()
        }
    }
    func setuoUI (){
        todoDetailsLabel.text = todo.details
        todiTitleLablel.text = todo.title
    }
    @IBAction func editTodoButtonClicked(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NewTodoVC") as? NewTodoVC {
            viewController.isCreationScreen = false
            viewController.editTodo = todo
            viewController.editTodoIndex = index
            navigationController?.pushViewController(viewController, animated: true)
           
            
            
        }
        
    }
    @IBAction func deleteButtonClicked(_ sender: Any) {
        let confirmAlert = UIAlertController(title: "تنبيه", message: "هل انت متأكد من الحذف", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "تأكيد الحذف", style: .destructive){
            alert in
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "TodoDeleted"), object: nil,userInfo: ["deletedTodoIndex":self.index])
            
            // Create new Alert
            let alertMessage = UIAlertController(title: "", message: "تم حذف المهمة بنجاح", preferredStyle: .alert)
            // Create OK button with action handler
            let closeAction = UIAlertAction(title: "تم", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: false)
            } )
            //Add OK button to a Alert message
            alertMessage.addAction(closeAction)
            // Present Alert to
            self.present(alertMessage, animated: true, completion:nil)
        }
        confirmAlert.addAction(confirmAction)
        let cancelAlert = UIAlertAction(title: "تراجع عن الحذف", style: .default)
        confirmAlert.addAction(cancelAlert)
        present(confirmAlert, animated: true,completion: nil)
        
   
    }
}
