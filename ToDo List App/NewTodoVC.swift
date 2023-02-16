//
//  NewTodoVC.swift
//  ToDo List App
//
//  Created by SHUAA on 06/05/1444 AH.
//

import UIKit

class NewTodoVC: UIViewController, UIAlertViewDelegate {
 
    var isCreationScreen = true
    var editTodo: Todo?
    var editTodoIndex: Int?
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var detailsTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isCreationScreen {
            mainButton.setTitle("تعديل", for: .normal)
            navigationItem.title = "تعديل مهمة"
            if let todo = editTodo {
                titleTextfield.text = todo.title
                detailsTextView.text = todo.details
                todoImageView.image = todo.image
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)

    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        if isCreationScreen {
            let todo = Todo(title: titleTextfield.text!,image: todoImageView.image, details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"),object: nil, userInfo: ["addTodo":todo])
            // Create new Alert
            let alertMessage = UIAlertController(title: "   ✅   ", message: "تمت اضافة المهمة بنجاح", preferredStyle: .alert)
            // Create OK button with action handler
            let closeAction = UIAlertAction(title: "إغلاق", style: .destructive, handler: { _ in
                self.tabBarController?.selectedIndex = 0
                self.titleTextfield.text = nil
                self.detailsTextView.text = nil
            } )
            //Add OK button to a Alert message
            alertMessage.addAction(closeAction)
            // Present Alert to
            self.present(alertMessage, animated: true, completion:nil)
        } else{
            //else, if the view controller is opened for edit (not for create)
            let todo = Todo(title: titleTextfield.text!,image: todoImageView.image,details: detailsTextView.text)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentToDoEdited"), object: nil,userInfo: ["editedTodo":todo,"editedTodoIndex":editTodoIndex])
            
            // Create new Alert
            let alertMessage = UIAlertController(title: "   ✅   ", message: "تم تعديل المهمة بنجاح", preferredStyle: .alert)
            // Create OK button with action handler
            let closeAction = UIAlertAction(title: "إغلاق", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            } )
            //Add OK button to a Alert message
            alertMessage.addAction(closeAction)
            // Present Alert to
            self.present(alertMessage, animated: true, completion:nil)
        }
    
    }
    
    
}
extension NewTodoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        dismiss(animated: true)
        todoImageView.image = image
    }
}
