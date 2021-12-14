import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
    
}
