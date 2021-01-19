//
//  ViewController.swift
//  UdemyCourses
//
//  Created by Arsalan Wahid Asghar on 02/01/2021.
//

import Cocoa


class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    
    var todoItems: [ToDoItem] = []
    
    
    @IBOutlet weak var deleteItem: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addTodoItemField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteItem.isHidden = true
        getTodoItems()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    //MARK:- Get items from coredata
    func getTodoItems() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                todoItems = try context.fetch(ToDoItem.fetchRequest())
                print("get: \(todoItems)")
            } catch {
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func addTodoItemClicked(_ sender: NSButton) {
        
        if addTodoItemField.stringValue != "" {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
                let todoItem = ToDoItem(context: context)
                todoItem.name = addTodoItemField.stringValue
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                addTodoItemField.stringValue = ""
                getTodoItems()
            }
        }
        
    }
    
    
    //MARK:- Table view stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return todoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let todoItem = todoItems[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "taskCol") {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "taskCell"), owner: self) as? NSTableCellView {
                if todoItem.name != nil{
                    cell.textField?.stringValue = todoItem.name!
                }
                return cell
            }
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteItem.isHidden = false
        print(notification)
        
    }
    
    @IBAction func deleteItemClicked(_ sender: NSButton) {
        let todoItem = todoItems[tableView.selectedRow]
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(todoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            getTodoItems()
            deleteItem.isHidden = true
        }
    }
    
    @IBAction func editContent(_ sender: NSTextField) {
        let selectedRow = tableView.selectedRow
        if selectedRow != -1 {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                print(selectedRow)
                todoItems[selectedRow].name = sender.stringValue
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            }
        }
    }
    
    
}
