//
//  ChooseTaskViewController.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 20.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: Outlets & Actions

    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var navBar: UIView!
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textFieldTaskName: UITextField!
    
    @IBAction func onTaskNameEditingChanged(_ sender: UITextField) {
        btnAddTask.isEnabled = !(sender.text?.isEmpty)!
    }
    
    //MARK: Fields & Properties
    
    var dataSource: [UIColor]!
    var selectedIndex = 0
    
    private var selectedTask: Task?
    var createdTask: Task {
        get {
                if let task = selectedTask {
                    return task
                }
            
            selectedTask = Task(taskName: textFieldTaskName.text!, backgroundColor: dataSource[selectedIndex])
            return selectedTask!
        }
    }
    
    //MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = getDataSourceList()
        initialize()
    }
    
    func getDataSourceList() -> [UIColor]{
        var colorList: [UIColor] = []
        if let path = Bundle.main.path(forResource: "TaskColors", ofType: "plist"){
            if let dict = NSArray(contentsOfFile: path) as NSArray! {
                for color in dict {
                    let array = color as! NSArray
                    let uiColor = UIColor(colorLiteralRed: Float(array[0] as! String)!,
                                          green: Float(array[1] as! String)!,
                                          blue: Float(array[2] as! String)!,
                                          alpha: Float(array[3] as! String)!)
                    colorList.append(uiColor)
                }
            }
        }
        
        return colorList
    }
    
    private func initialize(){
        navBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navBar.layer.shadowColor = UIColor.gray.cgColor
        navBar.layer.shadowRadius = 2
        navBar.layer.shadowOpacity = 0.8
        
        bottomContainer.layer.shadowOffset = CGSize(width: 0, height: -1)
        bottomContainer.layer.shadowColor = UIColor.gray.cgColor
        bottomContainer.layer.shadowRadius = 1
        bottomContainer.layer.shadowOpacity = 0.3
        
        btnAddTask.layer.cornerRadius = UIConsts.cornerRadius
        btnAddTask.layer.borderWidth = UIConsts.borderWidth
        btnAddTask.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.dequeueReusableCell(withReuseIdentifier:
            AddTaskCellCollectionViewCell.tag, for: indexPath) as! AddTaskCellCollectionViewCell
        
        selectedIndex = indexPath.row
        selectedCell.setCellSelected(true)
        collectionView.reloadData()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let addTaskCell = collectionView.dequeueReusableCell(withReuseIdentifier: AddTaskCellCollectionViewCell.tag,
                                                             for: indexPath) as! AddTaskCellCollectionViewCell
        
        addTaskCell.setColor(dataSource[indexPath.row])
        addTaskCell.setCellSelected(indexPath.row == selectedIndex)
        
        return addTaskCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
}

