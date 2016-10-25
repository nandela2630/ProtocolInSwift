//
//  TableViewCellFile.swift
//  ProtocolInSwift
//
//  Created by wflogin on 24/10/16.
//  Copyright © 2016 wflogin. All rights reserved.
//

import Foundation
import UIKit


protocol CustomTableViewCellDelegate{
    
    func buyTapped(cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var styleImageView: UIImageView!
    
    
    //Notice the variable delegate is an optional and the protocol ChildDelegate is marked to be only implemented by class type (without this the delegate variable can't be declared as a weak reference avoiding any retain cycle. This means that if the delegate variable is no longer referenced anywhere else, it will be released)
    var delegate:CustomTableViewCellDelegate?
    
    
    
    @IBAction func payButtonAction(_ sender: UIButton) {
        
        delegate?.buyTapped(cell: self)
        
    }
    
    
}
