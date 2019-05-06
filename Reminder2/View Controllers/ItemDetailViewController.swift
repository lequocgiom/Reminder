//
//  ItemDetailViewController.swift
//  Reminder2
//
//  Created by Le Trung on 5/3/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//

import UIKit

protocol EditingReceive {
    func dataEditingReceived(data: Item)
}

class ItemDetailViewController: UIViewController {
    
    var delegate : EditingReceive?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    private var datePicker: UIDatePicker?
    var selectedItem : Item?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = selectedItem {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            dateTextField.text = dateFormatter.string(from: item.dateCreated ?? Date())
            titleTextField.text = item.title
            noteTextField.text = item.note
            
            
        }
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        
        
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        dateTextField.inputView = datePicker
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
    
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if let title = titleTextField.text,
            let note = noteTextField.text
            //            let date = dateTextField.text
        {
            let newItem = Item(title: title, note: note)
            newItem.dateCreated = datePicker?.date
            print(title)
            print(note)
            delegate?.dataEditingReceived(data: newItem)
            print("Button tapped22")
        }
        
        self.dismiss(animated: true, completion: nil)
        print("Button tapped")
    }


    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
