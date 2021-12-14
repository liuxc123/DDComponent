import UIKit
import DDComponent

class FooterComponent: DDCollectionViewSectionComponent {
    
    var text: String?
    
    override init() {
        super.init()
        self.footerSize = CGSize(width: DDComponentAutomaticDimension, height: 30)
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        
        self.collectionView?.register(TextCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: NSStringFromClass(TextCollectionReusableView.self))
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let textView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: NSStringFromClass(TextCollectionReusableView.self), for: indexPath) as? TextCollectionReusableView
        textView?.textLabel.textAlignment = .center
        textView?.textLabel.font = UIFont.systemFont(ofSize: 12)
        textView?.textLabel.text = self.text
        textView?.backgroundColor = UIColor.brown
        return textView!
    }
    
}
