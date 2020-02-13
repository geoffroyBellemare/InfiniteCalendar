import UIKit
class InfiniteGridCellHeader: UICollectionViewCell {
    
    private(set) var coordinates = GridCoordinates(x: 0, y: 0) {
        didSet {
            coordinatesLabel.text = "\(date.monthName)"
            print("\((frame.width / 7)) month: \(date.monthName),  x :", coordinates.x)
            xConstraint!.constant = (coordinates.x) * (frame.width / 7)
//            layoutIfNeeded()
        } /*"\(coordinates.day!) , \(coordinates.month!)"*/
    }
    var xConstraint: NSLayoutConstraint?
    var day: Int {
        return coordinates.day ?? 0
    }
    var month: Int {
        return coordinates.month ?? 0
    }
    var year: Int {
        return coordinates.year ?? 0
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .orange
        setupViews()
    }
    func setupViews() {
        addSubview(coordinatesLabel)

        
        coordinatesLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        xConstraint = coordinatesLabel.leftAnchor.constraint(equalTo: leftAnchor)

        coordinatesLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //xConstraint =  coordinatesLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        NSLayoutConstraint.activate([xConstraint!])
        

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var date: Date {
            let dateString = String(format: "%4d/%d/%d 10:00", year, month, day)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
            return dateFormatter.date(from: dateString)!
    }
    static let identifier = "InfiniteGridCell"

    static func registerHeader(with collectionView: UICollectionView) {
        
        collectionView.register(self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cellHeader")
    }
    static func dequeueReusable(from collectionView: UICollectionView, at indexPath: IndexPath,
                                for coordinates: GridCoordinates, kind: String) -> InfiniteGridCellHeader{
        
        
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "cellHeader", for: indexPath) as! InfiniteGridCellHeader

        headerCell.coordinates = coordinates
        return headerCell
        
    }

    
    lazy var coordinatesLabel:UILabel = {
//        if let label = self.contentView.subviews.first as? UILabel {
//            return label
//        }
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        //label.font = UIFont.systemFont(ofSize: 13.0)
        label.textColor = UIColor.black
        label.textAlignment = .left
      //label.layer.borderColor = UIColor.red.cgColor
//        
        //label.layer.borderWidth = 1
        
   //     label.minimumScaleFactor = 0.5
        //label.adjustsFontSizeToFitWidth = true
//        label.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }()
}
