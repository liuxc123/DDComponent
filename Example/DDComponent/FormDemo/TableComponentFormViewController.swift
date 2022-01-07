//
//  TableComponentFormViewController.swift
//  DDComponent_Example
//
//  Created by liuxc on 2021/12/14.
//  Copyright © 2021 liuxc123. All rights reserved.
//

import UIKit
import DDComponent

class TableComponentFormViewController: UIViewController {
    
    lazy var tableView = UITableView(frame: self.view.bounds, style: .plain)
    lazy var rootComponent = DDTableViewRootComponent(tableView: tableView)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        
        let itemView = UIView()
        itemView.backgroundColor = .yellow
        
        let itemComponent = DDTableViewFormItemComponent(itemView: itemView)
        
        let group = DDTableViewItemGroupComponent(subComponents: [itemComponent])
        self.rootComponent.subComponents = [group]
        self.rootComponent.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.tableView.frame = self.view.bounds
        
        self.view.contentMode
    }
    
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["TableComponentForm"]
    }
}
