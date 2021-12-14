import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.frame = self.bounds
    }
}
