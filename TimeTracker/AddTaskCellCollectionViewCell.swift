//
//  AddTaskCellCollectionViewCell.swift
//  TimeTracker
//
//  Created by Michał Szyszka on 21.09.2016.
//  Copyright © 2016 Michał Szyszka. All rights reserved.
//

import UIKit

class AddTaskCellCollectionViewCell: UICollectionViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var background: UIView!
    
    //MARK: Fields
    
    static let tag = "AddTaskCellCollectionViewCell"
    
    //MARK: Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func setColor(_ color: UIColor){
        background.backgroundColor = color
    }
    
    func setCellSelected(_ isSelected: Bool){
        imgTick.isHidden = !isSelected
    }
    
    private func initialize(){
        background.layer.cornerRadius = UIConsts.cornerRadius
        background.layer.borderWidth = UIConsts.borderWidth
        background.layer.borderColor = UIColor.lightGray.cgColor
    }
}
