import UIKit
import DDComponent

class HeaderComponent: DDCollectionViewSectionComponent {
    
    var text: String?
    
    override init() {
        super.init()
        self.headerSize = CGSize(width: DDComponentAutomaticDimension, height: 50)
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        
        self.collectionView?.register(TextCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NSStringFromClass(TextCollectionReusableView.self))
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let textView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(TextCollectionReusableView.self), for: indexPath) as? TextCollectionReusableView
        textView?.textLabel.textAlignment = .left
        textView?.textLabel.font = UIFont.boldSystemFont(ofSize: 17)
        textView?.textLabel.text = self.text
        textView?.backgroundColor = UIColor.orange
        return textView!
    }
    
}
