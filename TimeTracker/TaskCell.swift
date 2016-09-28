//
//  TaskCell.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 21.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var activityInidcator: UIActivityIndicatorView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgColor: UIView!
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var activityIndicatorOverlay: UIView!
    
    //MARK: Fields
    
    static let tag = "TaskCell"
    
    //MARK: Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }

    private func initialize(){
        imgColor.layer.cornerRadius = UIConsts.cornerRadius
        imgColor.layer.borderWidth = UIConsts.borderWidth
        imgColor.layer.borderColor = UIColor.lightGray.cgColor
    }
}
