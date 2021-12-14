import UIKit
import DDComponent

private func AttributedText(text: String) -> NSAttributedString {
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineHeightMultiple = 1.5
    let attrText = NSMutableAttributedString(string: text, attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
        NSAttributedString.Key.paragraphStyle: paragraph
        ])
    return attrText
}

class TextsComponent: TitlesComponent {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TitleCollectionViewCell.self), for: indexPath) as? TitleCollectionViewCell
        cell?.titleLabel.attributedText = AttributedText(text: self.cellModels[indexPath.item].title)
        cell?.titleLabel.numberOfLines = 0
        cell?.backgroundColor = UIColor.lightGray
        return cell!
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = self.cellModels[indexPath.item].title
        
        let size = AttributedText(text: text).boundingRect(with: CGSize(width:collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right, height:.infinity),
                                         options: .usesLineFragmentOrigin,
                                         context: nil).size
        return size
    }
}
