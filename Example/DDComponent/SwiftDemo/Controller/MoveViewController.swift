//
//  MoveViewController.swift
//  DDComponent_Example
//
//  Created by mac on 2021/9/1.
//  Copyright © 2021 liuxc123. All rights reserved.
//

import UIKit
import DDComponent

class MoveViewController: UICollectionViewController {
    
    lazy var rootComponent: DDCollectionViewRootComponent = {
        let root = DDCollectionViewRootComponent(collectionView: self.collectionView!)
        return root
    }()
    
    let imageModels = [
        ImageModel(imageName: "00ffff", controllerClass: nil),
        ImageModel(imageName: "00ff00", controllerClass: nil),
        ImageModel(imageName: "0000ff", controllerClass: nil),
        ImageModel(imageName: "ff00ff", controllerClass: nil),
        ImageModel(imageName: "ff0000", controllerClass: nil),
        ImageModel(imageName: "ffff00", controllerClass: nil),
        ImageModel(imageName: "000000", controllerClass: nil),
    ]
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Move"
        self.collectionView?.backgroundColor = UIColor.white
        
        let images = ImagesComponent()
        images.headerComponent = {
            let header = HeaderComponent()
            header.text = "IMAGE HEADER"
            return header
        }()
        images.footerComponent = {
            let footer = FooterComponent()
            footer.text = "IMAGE FOOTER"
            return footer
        }()
        images.images = self.imageModels
        images.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        self.rootComponent.subComponents = [images]
        self.collectionView?.reloadData()
        
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(moveAction(_:))))
    }
    
    @objc func moveAction(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView?.indexPathForItem(at: gesture.location(in: collectionView))
                , let canMoveItemAtIndexPath = collectionView?.dataSource?.collectionView?(collectionView, canMoveItemAt: selectedIndexPath)
                , canMoveItemAtIndexPath else {
                    return
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        case .cancelled, .failed, .possible:
            collectionView.cancelInteractiveMovement()
        @unknown default:
            break;
        }
    }
    
    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Move"]
    }
}
