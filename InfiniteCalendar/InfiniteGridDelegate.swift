//
//  InfiniteGridDelegate.swift
//  myCalender2
//
//  Created by Geoffroy on 05/10/2019.
//  Copyright © 2019 akhil. All rights reserved.
//



import UIKit

class InfiniteGridDelegate: NSObject, UIScrollViewDelegate, UICollectionViewDelegate {
    
    weak var grid: InfiniteGrid?
    weak var layout: InfiniteGridLayout?
    var currentDate = Date()
    private var expectingEndDecelarationEvent: Bool = false
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard decelerate == false else {
            expectingEndDecelarationEvent = true
            return
        }
        //print(" SCROLL END")
        expectingEndDecelarationEvent = false
        self.readjustOffsets()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard expectingEndDecelarationEvent else { return }
        expectingEndDecelarationEvent = false
        //self.grid?.InfiniteCollectionDelegate?.scrollParalax()
        self.readjustOffsets()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let grid = self.grid
            else { return }
        
        //grid.scrollToNext()
    }
    func readjustOffsets() {
        guard let layout = self.layout else { return }
        
        let displacement = layout.gridCenterDisplacement()
                let (horizontalTiles, verticalTiles) = layout.roundToTiles(distance: displacement, rounding: .towardZero)
        currentDate = layout.currentDate
        //var offset = 0
        var currentWeek = layout.currentDate.weekOfMonth
        //var center = 0
        var margin: CGFloat = 0.0
        var coordinateY: CGFloat = 0
        let ranges = 0...abs(Int(verticalTiles))
        print("verticalTiles", verticalTiles)
        print("vertical displacment", (displacement.1 / 100))
        
        
//        if verticalTiles > 0 {
//            for i in ranges {
//                print(currentWeek)
//                print("coordinateX -- : \(coordinateY)------week -- : \(currentWeek) - \(currentDate.monthName)")
//                if coordinateY  < verticalTiles {
//                    
//                    //limites ?? distance parcouru attention car ajout
//                    //if coordinateY >= verticalTiles  { continue }
//                    if currentWeek == currentDate.numberOfWeeksInMonth {
//                        
//                        coordinateY += 0.5
//                        currentWeek = 0
//                        var cal = Calendar.current
//                        cal.firstWeekday = 2
//                        currentDate = Calendar.current.date(byAdding: .month, value: +1, to: currentDate)!
//                        print("month :",currentDate.monthName)
//                    }
//                    // startDate = Calendar.current.date(byAdding: .month, value: +1, to: startDate)!
//                    // currentWeekInMonth = startDate.numberOfWeeksInMonth
//                    
//                    coordinateY += 1
//                    currentWeek += 1
//                }
//                
//            }
//            
//            
//            
//            if currentWeek == 1 {
//                
//                let dateString = String(format: "%4d/%d/01 10:00", currentDate.year, currentDate.month)
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
//                
//                currentDate = dateFormatter.date(from: dateString)!
//            } else {
//                
//                currentDate = currentDate.currentWeekToDate(currentWeek: currentWeek)
//                //cal.date(from: date)!
//            }
//        } else {
//          
//            for i in ranges {
//
//                if coordinateY  > verticalTiles {
//                    
//
//                    if currentWeek == 1 {
//                      
//                        var cal = Calendar.current
//                        cal.firstWeekday = 2
//                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
//                    
//                     currentWeek = currentDate.numberOfWeeksInMonth + 1
//                     coordinateY -= 0.5
//                        
//                    }
//
//                    
//                    coordinateY -= 1
//                    currentWeek -= 1
//                }
//                
//            }
//
//        }
        
        for i in ranges {
             if verticalTiles > 0 {
                
                if coordinateY  < verticalTiles {
                    
                    //limites ?? distance parcouru attention car ajout
                    //if coordinateY >= verticalTiles  { continue }
                    if currentWeek == currentDate.numberOfWeeksInMonth {
                        
                        coordinateY += 0.5
                        currentWeek = 0
                        var cal = Calendar.current
                        cal.firstWeekday = 2
                        currentDate = Calendar.current.date(byAdding: .month, value: +1, to: currentDate)!
                        print("month :",currentDate.monthName)
                    }
                    // startDate = Calendar.current.date(byAdding: .month, value: +1, to: startDate)!
                    // currentWeekInMonth = startDate.numberOfWeeksInMonth
                    
                    coordinateY += 1
                    currentWeek += 1
                }
                
             } else {
                
                if coordinateY  > verticalTiles {
                    
                    if currentWeek == 1 {
                        
                        var cal = Calendar.current
                        cal.firstWeekday = 2
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
                        
                        currentWeek = currentDate.numberOfWeeksInMonth + 1
                        coordinateY -= 0.5
                        
                    }
                    
                    
                    coordinateY -= 1
                    currentWeek -= 1
                }
            }

            
        }
        
        if currentWeek == 1 {
            
            let dateString = String(format: "%4d/%d/01 10:00", currentDate.year, currentDate.month)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd hh:mm"
            
            currentDate = dateFormatter.date(from: dateString)!
        } else {
            
            currentDate = currentDate.currentWeekToDate(currentWeek: currentWeek)
            
        }
        
        print("coordinateX -- : \(coordinateY)------week -- : \(currentWeek)")
        print("!!! LA DATE DOIT ETRE th:-", currentDate)


        
        print("----------READJUST---------")

 print("coordinateY", coordinateY)
        adjustContentOffsetBy(horizontalTiles, coordinateY )
    }
    
    private func adjustContentOffsetBy(_ horizontalTiles: CGFloat, _ verticalTiles: CGFloat) {
        print(horizontalTiles)
        guard
            let tileSize = self.layout?.tileSize,
            let grid = self.grid,
            horizontalTiles != 0 || verticalTiles != 0
            else { return }
        

        let updatedOffset = CGPoint(x: grid.contentOffset.x - (horizontalTiles * tileSize.width),
                                    y: grid.contentOffset.y - (verticalTiles * tileSize.height))
        grid.setContentOffset(updatedOffset, animated: false)
        print("readjust--------")
        print(GridCoordinates(x: grid.centerCoordinates.x + horizontalTiles,
                              y: grid.centerCoordinates.y + verticalTiles))

        self.layout?.currentDate = currentDate
        //self.layout?.initialize()
        grid.centerCoordinates = GridCoordinates(x: grid.centerCoordinates.x + horizontalTiles,
                                                 y: grid.centerCoordinates.y + verticalTiles)
//
        //self.grid?.InfiniteCollectionDelegate?.scrollParalax(horizontalTiles, verticalTiles)
        
        // reloadData() performed by didSet of centerCoordinates
    }
}
