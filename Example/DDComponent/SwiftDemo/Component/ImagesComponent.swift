import UIKit
import DDComponent

private let imageSize = CGSize(width: 80, height: 80)

class ImageModel {
    let imageName: String
    let controllerClass: UIViewController.Type?
    
    private var _image: UIImage?
    
    var image: UIImage? {
        get {
            if _image == nil {
                let scanner = Scanner(string: self.imageName)
                var i: UInt64 = 0
                scanner.scanHexInt64(&i)
                let color = UIColor(red: CGFloat((i>>16)&0xff) / 255.0,
                                    green: CGFloat((i>>8)&0xff) / 255.0,
                                    blue: CGFloat(i&0xff) / 255.0,
                                    alpha: 1)
                UIGraphicsBeginImageContext(imageSize)
                color.setFill()
                UIBezierPath(rect: CGRect(origin: .zero, size: imageSize)).fill()
                _image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
            return _image
        }
    }
    
    init(imageName: String, controllerClass: UIViewController.Type?) {
        self.imageName = imageName
        self.controllerClass = controllerClass
    }
}

class ImagesComponent: DDCollectionViewHeaderFooterSectionComponent {
    var images : [ImageModel] = []
    var canMove: Bool = false
    weak var navigationController: UINavigationController?
    
    init(canMove: Bool = false) {
        self.canMove = canMove
        super.init()
        self.size = imageSize
        self.lineSpacing = 5
        self.itemSpacing = 5
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        self.collectionView?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(ImageCollectionViewCell.self))
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(ImageCollectionViewCell.self), for: indexPath) as? ImageCollectionViewCell
        cell?.imageView.image = self.images[indexPath.item].image
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cls = self.images[indexPath.item].controllerClass {
            self.navigationController?.pushViewController(cls.init(), animated: true)
        }
        self.images.removeFirst()
        self.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return canMove
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveSrouce = images[sourceIndexPath.item]
        var result = images
        result.remove(at: sourceIndexPath.item)
        result.insert(moveSrouce, at: destinationIndexPath.item)
        self.images = result
    }
}
