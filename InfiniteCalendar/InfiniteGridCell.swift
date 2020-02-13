import UIKit
class InfiniteGridCell: UICollectionViewCell {
    
    private(set) var coordinates = GridCoordinates(x: 0, y: 0) {
        didSet { coordinatesLabel.text = "\(coordinates.day ?? 0)" } /*"\(coordinates.day!) , \(coordinates.month!)"*/
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    static let identifier = "InfiniteGridCell"
    static func register(with collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: identifier)
    }
    static func registerHeader(with collectionView: UICollectionView) {
        
        collectionView.register(self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cellHeader")
    }
    static func dequeueReusable(from collectionView: UICollectionView, at indexPath: IndexPath,
                                for coordinates: GridCoordinates, kind: String) -> InfiniteGridCell{
       
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cellHeader", for: indexPath) as? InfiniteGridCell ?? InfiniteGridCell()
        headerCell.backgroundColor = .orange
        headerCell.coordinates = coordinates
        return headerCell
        
    }
    static func dequeue(from collectionView: UICollectionView, at indexPath: IndexPath,
                        for coordinates: GridCoordinates) -> InfiniteGridCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? InfiniteGridCell ?? InfiniteGridCell()
       
        cell.coordinates = coordinates


        
        return cell
    }
    func setupViews() {
        addBorders(edges: [.top], color: .lightGray, thickness: 0.5)
        addSubview(coordinatesLabel)
        coordinatesLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        
    }
    lazy var coordinatesLabel: UILabel = {
        if let label = self.contentView.subviews.first as? UILabel {
            return label
        }
        let label = UILabel(frame: self.contentView.bounds)
        label.font = UIFont.systemFont(ofSize: 19.0)
        label.textColor = UIColor.darkText
        label.textAlignment = .center
//        label.layer.borderColor = UIColor.red.cgColor
//        label.layer.borderWidth = 1
        //label.addBorders(edges: [.top], color: .lightGray, thickness: 0.5)
        
//        label.minimumScaleFactor = 0.5
//        label.adjustsFontSizeToFitWidth = true
//        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
//        label.translatesAutoresizingMaskIntoConstraints = true
//        self.contentView.addSubview(label)
        return label
    }()
}
