import UIKit
import DDComponent

class TitleModel {
    let title: String
    let controllerClass: UIViewController.Type?
    init(title:String, controllerClass:UIViewController.Type?) {
        self.title = title
        self.controllerClass = controllerClass
    }
}

class TitlesComponent: DDCollectionViewHeaderFooterSectionComponent {
    var cellModels: [TitleModel] = []
    weak var navigationController: UINavigationController?
    
    override init() {
        super.init()
        self.size = CGSize(width: DDComponentAutomaticDimension, height: 60)
        self.itemSpacing = 5
        self.lineSpacing = 5
        self.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        self.collectionView?.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(TitleCollectionViewCell.self))
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TitleCollectionViewCell.self), for: indexPath) as? TitleCollectionViewCell
        cell?.titleLabel.text = self.cellModels[indexPath.item].title
        cell?.backgroundColor = UIColor.lightGray
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cls = self.cellModels[indexPath.item].controllerClass {
            self.navigationController?.pushViewController(cls.init(), animated: true)
        }
    }
}
