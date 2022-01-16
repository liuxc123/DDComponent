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
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    lazy var collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewLayout)
    lazy var rootComponent = DDCollectionViewRootComponent(collectionView: collectionView)
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.collectionView.backgroundColor = .gray
        self.collectionView.refreshControl = refreshControl
        self.view.addSubview(collectionView)
        setupComponent()
    }
    
    func setupComponent() {
        
        var subComponents = [DDCollectionViewItemComponent]()
        
        for i in 0..<100 {

            let textItemView = TextItemView(frame: .zero)
            textItemView.titleLabel.text = "label---\(i)"
            textItemView.detailLabel.text = "aioghaedopshg0aersgh g\(i)"
            textItemView.backgroundColor = .white

            let itemComponent = DDCollectionViewFormItemComponent(itemView: textItemView)
            itemComponent.layoutSize = DDComponentLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            subComponents.append(itemComponent)
        }
        
        let label = UILabel()
        label.text = "label"
        label.backgroundColor = .white
        label.sizeToFit()
                
        let itemComponent = DDCollectionViewFormItemComponent(itemView: label)
        itemComponent.layoutSize = DDComponentLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        subComponents.append(itemComponent)
        
        let group = DDCollectionViewItemGroupComponent(subComponents: subComponents)
        group.lineSpacing = 10;
        group.itemSpacing = 0;
                
        self.rootComponent.subComponents = [group]
        self.rootComponent.reloadData()
    }
    
    @objc func handleRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.setupComponent()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.frame = self.view.bounds
    }
    
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["CollectionComponentForm"]
    }
}
