import UIKit
import DDComponent

class TaobaoBannerComponent: DDCollectionViewHeaderFooterSectionComponent {
    
    override init() {
        super.init()
        self.size = CGSize(width: DDComponentAutomaticDimension, height: 100)
    }
    
    override func prepareCollectionView() {
        super.prepareCollectionView()
        
        self.collectionView?.register(UINib(nibName: "TaobaoBanner", bundle: nil), forCellWithReuseIdentifier: "TaobaoBanner")
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaobaoBanner", for: indexPath)
        
        return cell
    }
}
