//
//  CollectionComponentFormViewController.swift
//  DDComponent_Example
//
//  Created by liuxc on 2021/12/14.
//  Copyright © 2021 liuxc123. All rights reserved.
//

import UIKit
import DDComponent

class CollectionComponentFormViewController: UIViewController {
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width:self.view.frame.size.width, height:60);
        return layout
    }()
    lazy var collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
    lazy var rootComponent = DDCollectionViewRootComponent(collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        let itemView = UIView()
        itemView.backgroundColor = .yellow
        let itemComponent = DDCollectionViewFormItemComponent(itemView: itemView)
        itemComponent.itemSize = DDComponentLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let group = DDCollectionViewItemGroupComponent(subComponents: [itemComponent])
        group.lineSpacing = 0;
        group.itemSpacing = 0;
                
        self.rootComponent.subComponents = [group]
        self.rootComponent.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["CollectionComponentForm"]
    }
}
