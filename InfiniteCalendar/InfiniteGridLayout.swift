import UIKit
class InfiniteGridLayout: UICollectionViewLayout {
    
//    let gridSize = CGSize(width: 350.0, height: 5400.0) // arbitrary size - something very large
//    let tileSize = CGSize(width: 100.0, height: 100.0) // arbitrary size
    var currentDate =  Date()//"2020-11-08".date!
    var presentedDate = Date()//"2020-11-08".date!
    var testStartDate = Date()
    //var centerCoord = 0
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var firstWeekDayOfMonth : Int {
        return Date().getFirstWeekDay(currentMonthIndex: currentMonthIndex, currentYear: currentYear)
    }
    var todaysDate = 0
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
 
   
    private var collectionViewHeight: CGFloat {
        return collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
        return collectionView!.frame.width
    }
    
    var tileSize: CGSize {
        return CGSize(width: collectionViewWidth / 7, height: collectionViewWidth / 7 + 15)
    }
    var headerSize: CGSize {
        return CGSize(width: collectionViewWidth, height: tileSize.height * 0.5)
    }
    var gridSize: CGSize {
        return CGSize(width: collectionViewWidth, height: 10000.0)
    }
    
    override var collectionViewContentSize: CGSize {
        return gridSize
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

    }
    override func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            var sections = [[GridCoordinates]]()
            guard
                let grid = self.collectionView as? InfiniteGrid,
                let dataSource = grid.dataSource as? InfiniteGridDataSource
                else { return nil }
            
            
            let topLeftCoordinates = coordinates(at: CGPoint(x: rect.minX, y: rect.minY))
            let bottomRightCoordinates = coordinates(at: CGPoint(x: rect.maxX, y: rect.maxY))
    
//                    print("topLeftCoordinates: ____", topLeftCoordinates)
//                    print("bottomRightCoordinates: ____", bottomRightCoordinates)
            let test = topCoordinate(topCoordinate: topLeftCoordinates, bottomCoordinate: bottomRightCoordinates)
//          let test =   topCoordinate3(topCoordinate: topLeftCoordinates, bottomCoordinate: bottomRightCoordinates)
//print(test)
            var( coordinatesY,  week, month, year) = test
            let start = Date().currentWeekDate(week, month, year)
            print("week - \(week), month - \(month), year - \(year)")
            print("START-----", start)
            var attributes: [UICollectionViewLayoutAttributes] = []
            print("COORDINATES------")
            print(coordinates)
            var i = 0
            var section = 0
            sections.append([GridCoordinates]())
            //sections[0].append(contentsOf: <#T##Sequence#>)
            var day = start.day
            var totalDaysInMonth = month == 2 && year % 4 == 0 ? 29 : numOfDaysInMonth[month-1]
            var index = 0
            for coords in coordinatesY {


                if i == 0 && week == 1 {
                    for indexDay in 1...7 {
                        if indexDay >= start.weekday {
                            let coord = GridCoordinates(x: CGFloat(indexDay - 1), y : coords.y, day: day, month: month, year: year , section: section)
                            //let coord = GridCoordinates(x: CGFloat(indexDay - 1), y : coords.y)
                          //  attributes.append(layoutAttributes(for: coord, using: dataSource))
//                            sections[sections.count - 1].append(layoutAttributes(for: coord, using: dataSource))
                            sections[sections.count - 1].append(coord)

                            //print("indexDay : \(indexDay), day : \(day), coord : \(coord)")

                            day += 1
                        }
                    }
                    week += 1
                } else if week > 1  {

                    for indexDay in 1...7 {
                        if day <= totalDaysInMonth  {
                            let coord = GridCoordinates(x: CGFloat(indexDay - 1), y : coords.y, day: day, month: month, year: year, section: section)
                           // let coord = GridCoordinates(x: CGFloat(indexDay - 1), y : coords.y)
                            //attributes.append(layoutAttributes(for: coord, using: dataSource))
                            //print("indexDay : \(indexDay), day : \(day), coord : \(coord)")
//                            sections[sections.count - 1].append(layoutAttributes(for: coord, using: dataSource))
                            sections[sections.count - 1].append(coord)
                            index = indexDay
                            day += 1
                        }

                    }

                    if (day - 1) == totalDaysInMonth {
                        sections.append([GridCoordinates]())
                        index = index == 7 ? 1 : index + 1
                        day = 1
                        week = 1
                        month += 1
                        section += 1
                        if month > 12 {
                            month = 1
                            year += 1
                        }
                        totalDaysInMonth = month == 2 && year % 4 == 0 ? 29 : numOfDaysInMonth[month-1]
                    } else {
                        week += 1
                    }

                } else if week == 1 {
                    for indexDay in 1...7 {
                        if indexDay >= index {
                            let coord = GridCoordinates(x: CGFloat(indexDay - 1), y : coords.y, day: day, month: month, year: year, section: section)
                            //let coord = GridCoordinates(x: CGFloat(indexDay - 1), y : coords.y)
                            //attributes.append(layoutAttributes(for: coord, using: dataSource))
//                            sections[sections.count - 1].append(layoutAttributes(for: coord, using: dataSource))
                            sections[sections.count - 1].append(coord)
                            //coords.x = CGFloat(indexDay)
                            //print("indexDay : \(indexDay), day : \(day), coord : \(coords)")
                            day += 1
                        }
                    }
                    week += 1
                }

                //attributes.append(layoutAttributes(for: coords, using: dataSource))
                i += 1
            }
            //return sections
            for (index, elements) in sections.enumerated(){
               
                if let headerCoord = elements.first, headerCoord.day == 1 {
                   
                    let headerCoordinates = GridCoordinates(x: headerCoord.x, y: headerCoord.y - 0.5, day: headerCoord.day ?? 0, month: headerCoord.month ?? 0, year: headerCoord.year ?? 0, section: index)
                    attributes.append(headerLayoutAttributes(for: headerCoordinates, using: dataSource, section: index))
                }
                for coordinateXY in elements {
                    attributes.append(layoutAttributes(for: coordinateXY, using: dataSource, section: index))
                }
                
            }
            return attributes
             //return layoutAttributes2(coordinates: test.0)
            //return layoutAttributes(from: topLeftCoordinates, to: bottomRightCoordinates)
    }
    
//    override func layoutAttributesForSupplementaryView(
//        ofKind elementKind: String,
//        at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//         print("HEADER --------------HEADER")
//        super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
//
//        guard
//            let grid = self.collectionView as? InfiniteGrid,
//            let dataSource = grid.dataSource as? InfiniteGridDataSource
//            else { return nil }
//        switch elementKind {
//        default :
//            let coordinates = dataSource.cache[.sectionHeader]?[indexPath]
//            print("HEADER ;", coordinates)
//            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//            layoutAttributes.frame = CGRect(origin: originForTile(at: coordinates!),
//                                            size: tileSize)
//            return layoutAttributes
//        }
//    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard
            let grid = self.collectionView as? InfiniteGrid,
            let dataSource = grid.dataSource as? InfiniteGridDataSource
            else { return nil }
        let coordinates = dataSource.cache[.cell]?[indexPath]
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        layoutAttributes.frame = CGRect(origin: originForTile(at: coordinates!),
                                        size: tileSize)
        return layoutAttributes
    }
    private func layoutAttributes2(coordinates: [GridCoordinates])
        -> [UICollectionViewLayoutAttributes]? {
            
            guard
                let grid = self.collectionView as? InfiniteGrid,
                let dataSource = grid.dataSource as? InfiniteGridDataSource
                else { return nil }
            
            var attributes: [UICollectionViewLayoutAttributes] = []
            print("COORDINATES------")
            print(coordinates)
            for coords in coordinates {
                //print(coords)
                attributes.append(layoutAttributes(for: coords, using: dataSource))
            }

            return attributes
    }
    private func layoutAttributes(from topLeftCoordinates: GridCoordinates,
                                  to bottomRightCoordinates: GridCoordinates)
        -> [UICollectionViewLayoutAttributes]? {
            
            guard
                let grid = self.collectionView as? InfiniteGrid,
                let dataSource = grid.dataSource as? InfiniteGridDataSource
                else { return nil }
            
            var attributes: [UICollectionViewLayoutAttributes] = []
            var top: Int = Int(topLeftCoordinates.x)
            var bottom: Int = Int(bottomRightCoordinates.x)
            
//            print("topLeftCoordinates: ", topLeftCoordinates)
//            print("bottomRightCoordinates: ", bottomRightCoordinates)
//            print(testStartDate.month)
//            print(testStartDate.weekOfMonth)
            
            var margin = (topLeftCoordinates.y - CGFloat(Int(topLeftCoordinates.y)))
            for xCoordinate in 0 ... 1 {
                var currentWeek = testStartDate.weekOfMonth
                for yCoordinate in Int(topLeftCoordinates.y) ... Int(bottomRightCoordinates.y) {
//                    print(currentWeek)
//                    print(margin)
                    let coordinates = GridCoordinates(x: CGFloat(xCoordinate), y: CGFloat(yCoordinate) )
                    attributes.append(layoutAttributes(for: coordinates, using: dataSource))
//                   print(GridCoordinates(x: CGFloat(xCoordinate), y: CGFloat(yCoordinate) ))
                    if currentWeek == testStartDate.numberOfWeeksInMonth {
                        margin += 0.5
                        currentWeek = 1
                        testStartDate = Calendar.current.date(byAdding: .month, value: +1, to: testStartDate)!
                        
                        //print("ajoute une marge :", margin)
                    } else {
                        currentWeek += 1
                    }

                    

                }
            }
            return attributes
    }
    
    private func layoutAttributes(for coordinates: GridCoordinates,
                                  using dataSource: InfiniteGridDataSource, section: Int = 0)
        -> UICollectionViewLayoutAttributes {
            
            let indexPath = dataSource.assignPath(to: coordinates, section: section)
        
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            layoutAttributes.frame = CGRect(origin: originForTile(at: coordinates),
                                            size: tileSize)
            return layoutAttributes
    }
    
    private func headerLayoutAttributes(for coordinates: GridCoordinates,
                                  using dataSource: InfiniteGridDataSource, section: Int = 0) -> UICollectionViewLayoutAttributes
         {
            
            let indexPath = dataSource.assignHeaderPath(to: coordinates, section: section)
            let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            layoutAttributes.frame = CGRect(origin: CGPoint(x: 0.0, y: originForTile(at: coordinates).y),                                            size: headerSize)
            return layoutAttributes
    }
   
    func topCoordinate(topCoordinate: GridCoordinates, bottomCoordinate: GridCoordinates) -> ([GridCoordinates], Int, Int, Int){
        guard
            let centerCoordinates = (self.collectionView as? InfiniteGrid)?.centerCoordinates
            else { return ([GridCoordinates(x: 0, y: 0)], 0, 0, 0) }
        
        

        var coordinates = [GridCoordinates]()
        var startWeek:Int = 0, startMonth:Int = 0, startYear: Int = 0
     // print(" VISIBLEAREA   :",(visibleSizeArea / 2).rounded(.awayFromZero))
        var j:CGFloat = 0
        if topCoordinate.y < centerCoordinates.y && bottomCoordinate.y > centerCoordinates.y {
//print("------------MIDDLE--------------------")
            var monthStartDate = currentDate.monthBeginDay

            var currentDay = monthStartDate.day
            var currentWeek = monthStartDate.weekOfMonth
            
            var range = (monthStartDate.weekday,currentWeek == monthStartDate.numberOfWeeksInMonth ? 1 + (numOfDaysInMonth[monthStartDate.month-1] - currentDay): 7) //!!!!!!!!!
            var y: CGFloat = centerCoordinates.y
            
            var currentWeekInMonthT = currentDate.weekOfMonth

            var yCoordinateT: CGFloat = centerCoordinates.y
            var startDate = currentDate



            for j in stride(from: centerCoordinates.y as CGFloat, to: topCoordinate.y as CGFloat, by: -1) {

                
             
                if j <= topCoordinate.y + 1 {
                    startWeek = currentWeekInMonthT
                    startMonth = startDate.month
                    startYear = startDate.year

                }
                coordinates.insert(GridCoordinates(x: 0.0, y: yCoordinateT, day: 0, month: startDate.month, year: startDate.year, section: currentWeekInMonthT), at: 0)
                //coordinates.insert(GridCoordinates(x: 0.0, y: yCoordinateT), at: 0)
                if currentWeekInMonthT == 1 {
                    startDate = Calendar.current.date(byAdding: .month, value: -1, to: startDate)!
                    currentWeekInMonthT = startDate.numberOfWeeksInMonth + 1
                    yCoordinateT -= 0.5
                }
                currentWeekInMonthT -= 1
                yCoordinateT -= 1
            }
            

            
            yCoordinateT = centerCoordinates.y + 1
            if currentDate.weekOfMonth == currentDate.numberOfWeeksInMonth {
                startDate = Calendar.current.date(byAdding: .month, value: +1, to: currentDate)!
                currentWeekInMonthT = 1
               yCoordinateT += 0.5
            } else {
                startDate =  currentDate
                currentWeekInMonthT =  currentDate.weekOfMonth + 1
                
            }
           
             monthStartDate = currentDate.monthBeginDay
             //testDay = monthStartDate.day
             currentDay = monthStartDate.day
             currentWeek = monthStartDate.weekOfMonth
             range = (monthStartDate.weekday,currentWeek == monthStartDate.numberOfWeeksInMonth ? 1 + (numOfDaysInMonth[monthStartDate.month-1] - currentDay): 7) //!!!!!!!!!

            y = centerCoordinates.y

            for j in stride(from: centerCoordinates.y as CGFloat , to: bottomCoordinate.y as CGFloat, by: +1) {
//                print("downMid -> \(currentWeekInMonthT), coords -> \(yCoordinateT) , month -> \(startDate.monthName)")
//                print("day++----: \(currentDay), week-----: \(currentWeek), y----:\(y)");
//                (currentDay, currentWeek, y) = increment(currentDay, currentWeek, y)
                coordinates.append(GridCoordinates(x: 0.0, y: yCoordinateT, day: 0, month: startDate.month, year: startDate.year, section: currentWeekInMonthT))
                //coordinates.append(GridCoordinates(x: 0.0, y: yCoordinateT))
//                if currentWeekInMonthT == 1 {
//                    startDate = Calendar.current.date(byAdding: .month, value: -1, to: startDate)!
//                    currentWeekInMonthT = startDate.numberOfWeeksInMonth + 1
//                    yCoordinateT -= 0.5
//                }
                if currentWeekInMonthT == startDate.numberOfWeeksInMonth {
                    startDate = Calendar.current.date(byAdding: .month, value: +1, to: startDate)!
                    currentWeekInMonthT = 0
                    yCoordinateT += 0.5
                }
               currentWeekInMonthT += 1
                yCoordinateT += 1
            }
            
        } else if topCoordinate.y >= centerCoordinates.y && bottomCoordinate.y > centerCoordinates.y {
           // print("BASSSS")
            
            
            var currentWeekInMonth = currentDate.weekOfMonth
            var yCoordinate: CGFloat = centerCoordinates.y
            var startDate = currentDate
            
            
            for _ in stride(from: centerCoordinates.y as CGFloat, to: topCoordinate.y - 1, by: +1 as CGFloat) {
                if yCoordinate + 1 > topCoordinate.y {
                    continue

                }
                //print("coords : \(i) ---coordinateY: \(yCoordinate)----week: \(currentWeekInMonth)")
                if currentWeekInMonth == startDate.numberOfWeeksInMonth {
                    startDate = Calendar.current.date(byAdding: .month, value: +1, to: startDate)!
                    currentWeekInMonth = 0
                    yCoordinate += 0.5
                }
                yCoordinate += 1
                currentWeekInMonth += 1
            }
            startWeek = currentWeekInMonth
            startMonth = startDate.month
            startYear = startDate.year
           // print("bas ori -> \(currentWeekInMonth)), coords -> \(yCoordinate) , month -> \(startDate.month)")
            for i in stride(from: yCoordinate as CGFloat, to: bottomCoordinate.y + 1, by: +1 as CGFloat) {
                if yCoordinate  > bottomCoordinate.y {
                    continue
                    
                }
//                print("bas test -> \(testWeek2), coords -> \(y2) , month -> \(testMonth) year: -> \(testYear)")

//                print("BAS tDay: \(testDay), --week : \(testWeek),--- mois: \(currentMonthIndex),--y: \(y) x->:\(range)")
                //coordinates.append(GridCoordinates(x: 0.0, y: yCoordinate))
                
                coordinates.append(GridCoordinates(x: 0.0, y: yCoordinate, day: 0, month: startDate.month, year: startDate.year, section: currentWeekInMonth))
//                (testDay2, testWeek2, y2, _, testMonth, testYear) = increment3(testDay2, testWeek2, y: y2, testMonth, testYear)
                //(testDay, testWeek, y, range) = increment2(testDay, testWeek, y: y, range)
                
                
//                print("--ffffffc : \(i) ---coordinateY: \(yCoordinate)----week: \(currentWeekInMonth)")
                if currentWeekInMonth == startDate.numberOfWeeksInMonth {
                    startDate = Calendar.current.date(byAdding: .month, value: +1, to: startDate)!
                    currentWeekInMonth = 0
                    yCoordinate += 0.5
                }
                yCoordinate += 1
                currentWeekInMonth += 1
            }
        } else if bottomCoordinate.y <= centerCoordinates.y {
            print("DESSUS")
            
            var currentWeekInMonth = currentDate.weekOfMonth
            var yCoordinate: CGFloat = centerCoordinates.y
            var startDate = currentDate
            

            for _ in stride(from: centerCoordinates.y as CGFloat, to: bottomCoordinate.y - 1, by: -1 as CGFloat) {
                if abs(yCoordinate - 1) >= abs(bottomCoordinate.y)  {
                    break
                    
                }
                //print("coords :", i)
               // print("coordinateY: \(yCoordinate)----week: \(currentWeekInMonth)")
                if currentWeekInMonth == 1 {
                    startDate = Calendar.current.date(byAdding: .month, value: -1, to: startDate)!
                    currentWeekInMonth = startDate.numberOfWeeksInMonth + 1
                    yCoordinate -= 0.5
                }
                yCoordinate -= 1
                currentWeekInMonth -= 1
            }
           
            for i in stride(from: yCoordinate as CGFloat, to: topCoordinate.y - 1, by: -1 as CGFloat) {
                //print(" coords: \(i)-----coordinateY: \(yCoordinate)----week: \(currentWeekInMonth)")
                //print("coords  les vrais:", i)
                //print("Y2: \(y)----week: \(currentWeek)")
//                testCoordinate.insert(GridCoordinates(x: 0.0, y: y), at: 0)
//                (currentDay, currentWeek, y, range) = decrement(currentDay, currentWeek, y)
               // coordinates.insert(GridCoordinates(x: 0.0, y: yCoordinate), at: 0)
                print(startDate.month)
                coordinates.insert(GridCoordinates(x: 0.0, y: yCoordinate, day: 0, month: startDate.month, year: startDate.year, section: currentWeekInMonth), at: 0)
               //print("i -> \(i)---- topCoordinate.y -> \(topCoordinate.y)")
                if i <= topCoordinate.y  {
                    startWeek = currentWeekInMonth
                    startMonth = startDate.month
                    startYear = startDate.year
//                    print("dessus ori -> \(currentWeekInMonth)), coords -> \(yCoordinate) , month -> \(startDate.month)")
                }
                if currentWeekInMonth == 1 {
                    startDate = Calendar.current.date(byAdding: .month, value: -1, to: startDate)!
                    currentWeekInMonth = startDate.numberOfWeeksInMonth + 1
                    yCoordinate -= 0.5
                }
                yCoordinate -= 1
                currentWeekInMonth -= 1

            }
//            print("ICI__________________________testCoordinates")
//            print(testCoordinate)
        }
        return (coordinates, startWeek, startMonth, startYear)
    }

    func coordinates(at point: CGPoint)
        -> GridCoordinates {
            
            guard
                let centerCoordinates = (self.collectionView as? InfiniteGrid)?.centerCoordinates
                else { return GridCoordinates(x: 0, y: 0) }
            
            let centerTileOffset = gridCenterTileOffset()
            let distance = (point.x - centerTileOffset.x, point.y - centerTileOffset.y)
            let (horizontalTiles, verticalTiles) = roundToTiles(distance: distance, rounding: .awayFromZero)
            return GridCoordinates(x: CGFloat(Int(centerCoordinates.x) + Int(horizontalTiles)),
                                   y: CGFloat(centerCoordinates.y + verticalTiles) )
    }
    
    private func gridCenterTileOffset()
        -> CGPoint {
            return CGPoint(x: 0/*(gridSize.width - tileSize.width) * 0.5*/,
                           y: (gridSize.height - tileSize.height) * 0.5)
    }
    
    private func originForTile(at coordinates: GridCoordinates)
        -> CGPoint {
            
            guard
                let centerCoordinates = (self.collectionView as? InfiniteGrid)?.centerCoordinates
                else { return CGPoint.zero }
            
            let centerTileOffset = gridCenterTileOffset()
            return CGPoint(x: centerTileOffset.x + tileSize.width * CGFloat(coordinates.x - centerCoordinates.x),
                           y: centerTileOffset.y + tileSize.height * CGFloat(coordinates.y - centerCoordinates.y))
    }
    
    func gridCenterDisplacement()
        -> (CGFloat, CGFloat) {
            
            guard
                let grid = self.collectionView as? InfiniteGrid
                else { return (0, 0) }
            
            let contentOffset = grid.contentOffset
            let visibleSize = grid.frame.size
            return (contentOffset.x - (gridSize.width - visibleSize.width) * 0.5,
                    contentOffset.y - (gridSize.height - visibleSize.height) * 0.5)
    }
    
    func roundToTiles(distance: (CGFloat, CGFloat),
                      rounding roundingRule: FloatingPointRoundingRule)
        -> (CGFloat, CGFloat) {
            
            guard tileSize.width > 0,
                tileSize.height > 0
                else { return (0, 0) }
            
            let (horizontal, vertical) = distance
            return ((horizontal / tileSize.width).rounded(roundingRule),
                    (vertical / tileSize.height).rounded(roundingRule))
    }
  /*
    func increment3( _ day: Int, _ currentWeek: Int, y: CGFloat, _ month: Int,_ year: Int) -> (Int, Int, CGFloat, (Int, Int), Int, Int) {
        var day = day
        var week = currentWeek
        var y = y
        var year = year
        var range = (0, 0)
        var month = month
        
        
        
        if day == 1 {
            //            currentMonthIndex += 1
            //
            //            if currentMonthIndex > 12 {
            //                currentMonthIndex = 1
            //                currentYear += 1
            //            }
            //            if currentMonthIndex == 2 && currentYear % 4 == 0 {
            //                numOfDaysInMonth[currentMonthIndex-1] = 29
            //            }
            var firstMonthDay = Date().getFirstWeekDay(currentMonthIndex: month, currentYear: currentYear)
            if firstMonthDay > 1 {
                day = 1 + (7 - (firstMonthDay - 1) )
                //print("\(currentMonthIndex)  fff jour \( day )  premier :", firstMonthDay)
            } else {
                day = 1 + 7
                
            }
            range = (1, 7 /*- 1*/)
            week += 1
            y += 1
        } else {
            //            print("verif day: \(day + 7), month : \(currentMonthIndex), year : \(currentYear), jrs \(numOfDaysInMonth[currentMonthIndex-1])")
            let totalDaysInMonth = month == 2 && year % 4 == 0 ? 29 : numOfDaysInMonth[month-1]
            
            day = day + 7 > totalDaysInMonth ? 1 : day + 7
            
            if day == 1 {
                
                month += 1
                
                if month > 12 {
                    month = 1
                    year += 1
                }
                //                if currentMonthIndex == 2 && currentYear % 4 == 0 {
                //                    numOfDaysInMonth[currentMonthIndex-1] = 29
                //                }
                
                var firstMonthDay = Date().getFirstWeekDay(currentMonthIndex: month, currentYear: year)
                range = (firstMonthDay, 7 /*- 1*/)
                week = 1
                y += 1.5
            } else {
                week += 1
                y += 1
                //last week of month
                if day + 7 > totalDaysInMonth {
                    range = (1, totalDaysInMonth - (day-1) /*- 1*/)
                } else {
                    range = (1, 7 /*- 1*/)
                }
                
            }
        }
        return (day, week, y, range, month, year)
    }
    
    func decrement3(_ day: Int, _ currentWeek: Int, _ y: CGFloat, _ month: Int, _ year: Int) -> (Int,Int, CGFloat, (Int, Int), Int, Int) {
        var day = day
        var week = currentWeek
        var y = y
        var range = (0, 0)
        var month = month
        var year = year
        if day == 1 {
            
            var firstMonthDay = Date().getFirstWeekDay(currentMonthIndex: month, currentYear: year)
            
            
            month -= 1
            if month < 1 {
                month = 12
                year -= 1
            }
            let totalDaysInMonth = month == 2 && year % 4 == 0 ? 29 : numOfDaysInMonth[month-1]
            
            if firstMonthDay > 1 {
                day = totalDaysInMonth - (firstMonthDay - 1 - 1)
                range = (1, firstMonthDay - 1)
                //print("DDay \(day) -- month, firstMonthDay --: currentMonthIndex \(firstMonthDay)")
            } else {
                day = totalDaysInMonth  - 6
                range = (1, 7)
            }
            week = "\(year)-\(month)-01".date!.firstDayOfTheMonth.numberOfWeeksInMonth
            y -= 0.5
        } else {
            day = day - 7 <= 0 ? 1 : day - 7
            if day == 1 {
                let firstMonthDay = Date().getFirstWeekDay(currentMonthIndex: month, currentYear: currentYear)
                range = (firstMonthDay /*-1*/, 7)
            } else {
                range = (1, 7)
            }
            week -= 1
        }
        y -= 1
        return (day, week, y ,range, month, year)
    }
*/
}
