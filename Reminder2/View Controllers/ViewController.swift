//
//  ViewController.swift
//  Reminder2
//
//  Created by Le Trung on 5/3/19.
//  Copyright © 2019 Le Trung. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddingReceive, EditingReceive {
    
    //MARK: editing item action
    var currentIndex : Int?
    
    func dataEditingReceived(data: Item) {
        if let index = currentIndex {
            print(index)
            if let todo = self.itemList?[index] {
                do {
                    try self.realm.write {
                        todo.title = data.title
                        todo.note = data.note
                        todo.dateCreated = data.dateCreated
                    }
                }
                catch {
                    print("Error deleting category, \(error)")
                }
                
            }
        }
        else {print("current index not found")}
        tableView.reloadData()
    }
    
    // MARK: variable for persisting data
    let realm = try! Realm()
    
    var itemList : Results<Item>!
    
    var hideCompleted = false
    //MARK: TableView delegate and datasource
    
    @IBOutlet weak var hideCompletedButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        self.tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "tableCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        loadItems()
        // Do any additional setup after loading the view.
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! CustomCell
        
        if let item = itemList?[indexPath.row] {
            cell.configure(title: item.title, delegate: self)
            
            if item.done {
                cell.checkButton.setBackgroundImage(UIImage(imageLiteralResourceName: "checkBoxFILLED"), for: UIControl.State.normal)
            }
            else {
                cell.checkButton.setBackgroundImage(UIImage(imageLiteralResourceName: "checkBoxOUTLINE"), for: UIControl.State.normal)
                
            }

        }
        return cell
    }
    
    //MARK: add button adtion
    @IBAction func addButtonAction(_ sender: UIButton) {
        let addVC = addItemViewController()
        addVC.delegate = self
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(addVC, animated:true, completion:nil)
    }
    
    @IBAction func testDate(_ sender: UIButton) {
        //Todo: filter item by Date(today)
        itemList = itemList.filter("dateCreated == %@", NSDate())
        tableView.reloadData()
    }
  
    //MARK: manipulate data (Load, save)
    
    func save(item : Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        }
            
        catch{
            print("Error saving category, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems() {
        
        itemList = realm.objects(Item.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: delete cell by swiping
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch editingStyle {
        case .delete:
            if let todo = self.itemList?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(todo)
                    }
                }
                catch {
                    print("Error deleting category, \(error)")
                }
                
            }
            tableView.reloadData()
            
        default:
            return
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = UIColor(hexString: "#218c74")
        return [deleteButton]
    }
    
    //MARK: adopt protocol for adding data
    func dataAddingReceived(data: Item) {
        save(item: data)
        tableView.reloadData()
        return
    }
    @IBAction func hideCompletedAction(_ sender: Any) {
        
        if hideCompleted == false {
            itemList = itemList.filter(NSPredicate(format: "done == %@", NSNumber(booleanLiteral: false)))
            tableView.reloadData()
            hideCompleted = true
            hideCompletedButton.setTitle("Show Completed Tasks", for: .normal)
        }
        else {
            hideCompletedButton.setTitle("Hide Completed Tasks", for: .normal)
            hideCompleted = false
            loadItems()
        }
    }
}

//MARK: adopt CustomCellDelegate methods
extension ViewController: CustomCellDelegate {
    func checkChange(_ cell: CustomCell, didTap checkButton: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        
        if let item = itemList?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("error changing done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
    func detail(_ cell: CustomCell, didTap detailButton: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        currentIndex = indexPath.row
        print(currentIndex!)
        let detailVC = ItemDetailViewController()
        detailVC.delegate = self
        detailVC.selectedItem = itemList[indexPath.row]
        detailVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.present(detailVC, animated: true, completion: nil)
    }
    
}

//MARK: Searchbar button action
extension ViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemList = itemList.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            searchBar.resignFirstResponder()
        }
    }
    
}

//MARK: extension for Date
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
