import UIKit
import DDComponent

class TaobaoGoodsComponent: DDCollectionViewHeaderFooterSectionComponent {
    
    var goodsItem: GoodsItem?

    override init() {
        super.init()
        self.size = CGSize(width: DDComponentAutomaticDimension, height: 200)
        self.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        
        self.collectionView?.register(UINib(nibName: self.cellIdentifier(), bundle: nil), forCellWithReuseIdentifier: self.cellIdentifier())
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier(), for: indexPath)
        
        return cell
    }
    
    func cellIdentifier() -> String {
        return "TaobaoGoods\(self.goodsItem!.type)"
    }
}
