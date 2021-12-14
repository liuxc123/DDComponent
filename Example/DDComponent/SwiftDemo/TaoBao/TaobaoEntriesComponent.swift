import UIKit
import DDComponent

class TaobaoEntriesComponent: DDCollectionViewHeaderFooterSectionComponent {
    
    var entries: [String] = []
    
    override init() {
        super.init()
        self.itemSpacing = 10
        self.lineSpacing = 10
        self.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        
        self.collectionView?.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: "TaobaoEntries")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaobaoEntries", for: indexPath) as? TitleCollectionViewCell
        cell?.titleLabel.text = self.entries[indexPath.item]
        cell?.titleLabel.font = UIFont.systemFont(ofSize: 12)
        cell?.titleLabel.textAlignment = .center
        cell?.backgroundColor = UIColor.cyan
        
        let width = (collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - 4*self.itemSpacing) / 5
        cell?.layer.cornerRadius = width / 2
        cell?.clipsToBounds = true
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - 4*self.itemSpacing) / 5
        return CGSize(width: width, height: width)
    }
}
