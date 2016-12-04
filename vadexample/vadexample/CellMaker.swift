//
//  CellMaker.swift
//  Biji
//
//  Created by Peiqiang Hao on 16/1/28.
//  Copyright © 2016年 Peiqiang Hao. All rights reserved.
//

import Foundation
import UIKit

@objc public class CellMaker:NSObject {
    
    public func makeLineCell(_ tableView: UITableView) -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "timelinecell")
        
            if(cell==nil) {
                
                cell = UITableViewCell(style: .default, reuseIdentifier: "timelinecell")
                let lineView:UIView = UIView(frame:CGRect(x: 5,y: 5,width: 0,height: 20))
                lineView.backgroundColor = UIColor.green
                lineView.layer.cornerRadius = 5.0
                lineView.clipsToBounds = true
                lineView.tag = 1001
                cell!.contentView.addSubview(lineView)
            }
        
            return cell!
    }
    
    public func LineCell(cell:UITableViewCell,withTitle title:String, withWidth width:CGFloat) {
        
        cell.textLabel?.text = title
        
        let lineView:UIView = cell.contentView.viewWithTag(1001)!
        lineView.frame = CGRect(x: 5,y: 5,width: width,height: 30)
    }
    
}
