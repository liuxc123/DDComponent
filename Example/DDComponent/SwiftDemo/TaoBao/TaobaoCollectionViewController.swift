import UIKit
import DDComponent

class GoodsItem {
    let type: Int
    let title: String?
    init(type: Int, title:String?) {
        self.type = type
        self.title = title
    }
}

class TaobaoCollectionViewController: UICollectionViewController {
    
    lazy var rootComponent: DDCollectionViewRootComponent = {
        let root = DDCollectionViewRootComponent(collectionView: self.collectionView!)
        return root
    }()
    
    lazy var banner: DDCollectionViewBaseComponent = {
        let comp = TaobaoBannerComponent()
        return comp
    }()
    
    lazy var entries: TaobaoEntriesComponent = {
        let comp = TaobaoEntriesComponent()
        return comp
    }()
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TaoBao"
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.collectionView?.backgroundColor = UIColor.darkGray

        self.entries.entries = [
            "天猫", "聚划算", "天猫国际", "外卖", "天猫超市",
            "充值中心", "飞猪旅行", "领金币", "拍卖", "分类"
        ]
        var components = [self.banner, self.entries]
        
        let group = DDCollectionViewSectionGroupComponent()
        group.subComponents = components
        let status = StatusComponent.component(normalComponent: group)
        status.state = .loading
        status.emptySize = CGSize(width: DDComponentAutomaticDimension, height: DDComponentAutomaticDimension)
        
        
        self.rootComponent.subComponents = [status]
        self.collectionView?.reloadData()
        
        // Request ...
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            let goodsData = [
                GoodsItem(type: 0, title: nil),
                GoodsItem(type: 2, title: "Header 2"),
                GoodsItem(type: 3, title: nil),
                GoodsItem(type: 1, title: nil),
                GoodsItem(type: 3, title: nil),
                GoodsItem(type: 2, title: "Header 2"),
                GoodsItem(type: 0, title: nil),
                GoodsItem(type: 2, title: nil),
                GoodsItem(type: 1, title: "Header 1"),
                GoodsItem(type: 0, title: nil),
                GoodsItem(type: 2, title: nil),
                GoodsItem(type: 1, title: nil)
            ]
            for item in goodsData {
                let goods = TaobaoGoodsComponent()
                goods.goodsItem = item
                if let title = item.title {
                    goods.headerComponent = {
                        let header = HeaderComponent()
                        header.text = title
                        return header
                    }()
                }
                components.append(goods)
            }
            group.subComponents = components
            
            status.state = .normal
            self.collectionView?.reloadData()
        }
    }

    @objc class func catalogBreadcrumbs() -> [String] {
        return ["TaoBao"]
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
    }
}
