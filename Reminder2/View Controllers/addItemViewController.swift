//
//  addItemViewController.swift
//  Reminder2
//
//  Created by Le Trung on 5/3/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//

import UIKit

protocol AddingReceive {
    
    func dataAddingReceived(data: Item)
}

    
class addItemViewController: UIViewController {
    
//    var itemTitle = ""
//    var itemNote = ""
//    var itemDate = Date()
    var delegate : AddingReceive?

    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var noteTextField: UITextField!
    private var datePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: Date())
//        datePicker?.minimumDate=Date()
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    //MARK: save action
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if titleTextField.text == "" {
            let alert = UIAlertController(title: "Missing infomation", message: "TITLE REQUIRED", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancel", style: .default) { (action) in
                print("Sucess")
            }
            alert.view.tintColor = .red
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
            
        else if noteTextField.text == "" {
            let alert = UIAlertController(title: "Missing infomation", message: "NOTE REQUIRED", preferredStyle: .alert)
            alert.view.tintColor = .red
            let action = UIAlertAction(title: "Cancel", style: .default) { (action) in
                print("Sucess")
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        else if dateTextField.text == "" {
            let alert = UIAlertController(title: "Missing infomation", message: "DATE REQUIRED", preferredStyle: .alert)
            alert.view.tintColor = .red
            let action = UIAlertAction(title: "Cancel", style: .default) { (action) in
                print("Sucess")
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else {
            if let title = titleTextField.text,
                let note = noteTextField.text
                //            let date = dateTextField.text
            {
                let newItem = Item(title: title, note: note)
                newItem.dateCreated = datePicker?.date.stripTime()
                print(title)
                print(note)
                delegate?.dataAddingReceived(data: newItem)
                print("Button tapped22")
            }
            self.dismiss(animated: true, completion: nil)
            //        print(type(of :self.duedate))
            //        print(self.duedate)
            print("Button tapped")
        }
        
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

