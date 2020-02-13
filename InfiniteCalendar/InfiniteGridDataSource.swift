import UIKit
class InfiniteGridDataSource: NSObject, UICollectionViewDataSource {
    enum Element: String {
        case header
        case menu
        case sectionHeader
        case sectionFooter
        case cell
        
        var id: String {
            return self.rawValue
        }
        
        var kind: String {
            return "Kind\(self.rawValue.capitalized)"
        }
    }
    var cache: [Element: [IndexPath: GridCoordinates]] = [Element.cell: [:], Element.sectionHeader: [:]]
    let pathsCacheSize: Int = 524 // arbitrary large number, increase if you use small tile sizes and some cells are not appearing when scrolling
    var pathsCache: [IndexPath: GridCoordinates] = [:]
    var pathsCacheIndex: Int = 0
    var pathsCacheIndexHeader: Int = 0
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pathsCacheSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pathsCacheSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let coordinates = pathsCache[indexPath] ?? GridCoordinates(x: 0, y: 0)
        let coordinates = cache[.cell]![indexPath] ?? GridCoordinates(x: 0, y: 0)
        return InfiniteGridCell.dequeue(from: collectionView, at: indexPath, for: coordinates)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let coordinates = cache[.sectionHeader]![indexPath] ?? GridCoordinates(x: 0, y: 0)
        return InfiniteGridCellHeader.dequeueReusable(from: collectionView, at: indexPath, for: coordinates, kind: kind )
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        print("CELL HEADER")
//        let coordinates = cache[.sectionHeader]![indexPath] ?? GridCoordinates(x: 0, y: 0)
//        return InfiniteGridCell.dequeueReusable(from: collectionView, at: indexPath, for: coordinates)
//    }
    func assignPath(to coordinates: GridCoordinates, section: Int = 0) -> IndexPath {
//        for cacheEntry in pathsCache where cacheEntry.value == coordinates {
//            return cacheEntry.key
//        }
        for cacheEntry in cache[Element.cell]! where cacheEntry.value == coordinates {
            return cacheEntry.key
        }
        let indexPath = IndexPath(item: pathsCacheIndex, section: section)
        pathsCacheIndex = (pathsCacheIndex + 1) % pathsCacheSize
//        pathsCache[indexPath] = coordinates
        cache[Element.cell]![indexPath] = coordinates
        
        return indexPath
    }
    func assignHeaderPath(to coordinates: GridCoordinates, section: Int = 0) -> IndexPath {
        //        for cacheEntry in pathsCache where cacheEntry.value == coordinates {
        //            return cacheEntry.key
        //        }
        for cacheEntry in cache[Element.sectionHeader]! where cacheEntry.value == coordinates {
            return cacheEntry.key
        }
        let indexPath = IndexPath(item: 0, section: pathsCacheIndexHeader)
        pathsCacheIndexHeader = (pathsCacheIndexHeader + 1) % pathsCacheSize
        //        pathsCache[indexPath] = coordinates
        cache[Element.sectionHeader]![indexPath] = coordinates
        print(indexPath)
        return indexPath
    }
}
