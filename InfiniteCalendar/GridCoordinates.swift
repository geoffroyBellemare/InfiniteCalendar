import Foundation
import UIKit
class  GridCoordinates: Equatable {
    static func == (lhs: GridCoordinates, rhs: GridCoordinates) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    

    
    var x: CGFloat
    var y: CGFloat

    var day: Int?
    var month: Int?
    var year: Int?
    var week: Int?
     var section: Int?
    var item:Int?
    init( x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }

    convenience init( x: CGFloat, y: CGFloat, day: Int, month: Int, year: Int, section: Int) {
        self.init(x: x, y: y)
        self.day = day
        self.month = month
        self.year = year
        self.section = section
    }
}
