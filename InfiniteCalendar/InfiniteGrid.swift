
import UIKit
class InfiniteGrid: UICollectionView {
    
    let infiniteDataSource = InfiniteGridDataSource()
    let infiniteDelegate = InfiniteGridDelegate()
    var centerCoordinates = GridCoordinates(x: 0, y: 0) {
        didSet { self.reloadData() }
    }
    
    convenience init(hostView: UIView) {
        //gggggggggg
        let layout = InfiniteGridLayout()
        self.init(frame: hostView.bounds, collectionViewLayout: layout)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = true
        self.backgroundColor = UIColor.clear
        infiniteDelegate.grid = self
        infiniteDelegate.layout = layout
        self.dataSource = infiniteDataSource
        self.delegate = infiniteDelegate

        InfiniteGridCell.register(with: self)
        InfiniteGridCellHeader.registerHeader(with: self)
        
        hostView.addSubview(self)
    }
    
    func scrollToCenter() {
        let size = self.contentSize
        let topLeftCoordinatesWhenCentered = CGPoint(x: (size.width - self.frame.width) * 0.5,
                                                     y: (size.height - self.frame.height) * 0.5)
        self.setContentOffset(topLeftCoordinatesWhenCentered, animated: false)
    }
}
