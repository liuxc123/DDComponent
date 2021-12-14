import UIKit

class TextCollectionReusableView: UICollectionReusableView {
    lazy var textLabel: UILabel = {
        let label = UILabel()
        self.addSubview(label)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel.frame = self.bounds
    }
}
