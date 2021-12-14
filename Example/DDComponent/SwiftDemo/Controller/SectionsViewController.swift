import UIKit
import DDComponent

class SectionsViewController: UICollectionViewController {
    
    lazy var rootComponent: DDCollectionViewRootComponent = {
        let root = DDCollectionViewRootComponent(collectionView: self.collectionView!)
        return root
    }()
    
    let titleModels = [
        TitleModel(title: "Macrotarsomys petteri, Petter's big-footed mouse, is a Malagasy rodent. It is the largest in its genus, with a head and body length of 150 mm (5.9 in) and body mass of 105 g (3.7 oz). The upperparts are brown, darkest in the middle of the back, and the underparts are white to yellowish. The animal has long whiskers, short forelimbs, and long hindfeet. The tail ends in a prominent tuft of long, light hairs. The skull is robust and the molars are low-crowned and cuspidate. The species most resembles, and may be most closely related to, the greater big-footed mouse. The specific name, petteri, honors French zoologist François Petter for his contributions to the study of Malagasy rodents. M. petteri is now found only in southwestern Madagascar's Mikea Forest, which is threatened by human development. Subfossil records indicate that it used to be more widely distributed in southern Madagascar; climatic changes and competition with introduced species may have led to the shift in its distribution. (Full article...)", controllerClass: nil)
    ]
    
    let textModels = [
        TitleModel(title: "The Conservative Party, (governing since 2010 as a senior coalition partner prior to 2015 and as a majority government thereafter) was defending a majority of 12, against the Labour Party. The official opposition is led by Jeremy Corbyn. In order to \"strengthen [her] hand in forthcoming Brexit negotiations,\"[1] May hoped to secure a larger Parliamentary majority for the Conservative Party.", controllerClass: nil),
        TitleModel(title: "Since the previous general election, opinion polls had shown public opinion consistently increase for the Conservatives over Labour. At the beginning of the campaign, the Conservative Party had a 20-point lead, and peaked by 25 points in the early weeks of canvassing. This triggered widespread expectations of a landslide victory, similar to that of 1983 United Kingdom general election. However, in the latter stages of the campaign, their lead began to diminish as Labour Party support surged in the final weeks. Despite the narrowing opinion polls, the election results still came as a surprise for major political commentators.", controllerClass: nil),
        TitleModel(title: "Following the election results, the Conservatives spoke with Democratic Unionist Party (DUP) of Northern Ireland, whose 10 seats could allow for the formation of a minority Conservative government.[2]", controllerClass: nil)
        ]
    
    let imageModels = [
        ImageModel(imageName: "00ffff", controllerClass: nil),
        ImageModel(imageName: "00ff00", controllerClass: nil),
        ImageModel(imageName: "0000ff", controllerClass: nil),
        ImageModel(imageName: "ff00ff", controllerClass: nil),
        ImageModel(imageName: "ff0000", controllerClass: nil),
        ImageModel(imageName: "ffff00", controllerClass: nil),
        ImageModel(imageName: "000000", controllerClass: nil),
    ]

    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sections"
        self.collectionView?.backgroundColor = UIColor.white

        let titles = TitlesComponent()
        titles.cellModels = self.titleModels
        
        let texts = TextsComponent()
        texts.cellModels = self.textModels
        
        let images = ImagesComponent()
        images.headerComponent = {
            let header = HeaderComponent()
            header.text = "IMAGE HEADER"
            return header
        }()
        images.footerComponent = {
            let footer = FooterComponent()
            footer.text = "IMAGE FOOTER"
            return footer
        }()
        images.images = self.imageModels
        images.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        self.rootComponent.subComponents = [titles, texts, images]
        self.collectionView?.reloadData()
    }

    @objc class func catalogBreadcrumbs() -> [String] {
        return ["Sections"]
    }

}
