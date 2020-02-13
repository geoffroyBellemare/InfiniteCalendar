//
//  DateHelper.swift
//  myCalender2
//
//  Created by Geoffroy on 03/10/2019.
//  Copyright © 2019 akhil. All rights reserved.
//

import UIKit
class DateHelper {
    let daysArr = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    func getWeeks(date: Date = Date()) -> [[Int]] {
        
        var weeks = [[Int]]()
        
        let startOfWeek = date.startOfWeek
        var day = startOfWeek.day
        var month = startOfWeek.month - 1
        
        while(month < 11) {
            var weekdays = [Int]()
            for _ in 0..<7 {
                weekdays.append(day)
                if day == numOfDaysInMonth[month] {
                    month += 1
                    day = 1
                } else {
                    day  = day + 1
                }
            }
            weeks.append(weekdays)
        }
        
        return weeks
    }
}

extension Date {
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    func getDaysInMonth() -> Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    var dayOrdinal: Int {
        let cal = Calendar.current
        let day = cal.ordinality(of: .day, in: .year, for: self)
        return day!
    }
    var weekday: Int {
         let day = Calendar.current.component(.weekday, from: self)
         return day == 1 ? 7 : day - 1
    }
    
    var weekOfMonth: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.component(.weekOfMonth, from: self)
        //return Calendar.current.component(.weekOfMonth, from: self)
    }
    var weekOfMonth2: Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        return calendar.component(.weekOfMonth, from: self)
    }
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    func getFirstWeekDay( currentMonthIndex: Int, currentYear: Int) -> Int {

        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
       return day
    }
//    var getCurrentWeek: Int {
//
//        let range = Calendar.current.range(of: .day, in: .month, for: self)!
//        let currentDay = self.day
//        let numDays = range.count
//        var weekDay = self.getFirstWeekDay
//        var week = 1
//        for day in 1...numDays {
//            if weekDay > 7 {
//                week += 1
//                weekDay = 1
//            }
//            if currentDay == day {
//                return week
//            }
//            weekDay += 1
//        }
//
//        return 1
//    }

    
    var nextWeek: Date{
        var components = DateComponents()
        components.year = year
        components.hour = 10
        components.weekOfYear = weekOfYear + 1
        components.weekday = 2 // 1 == lundi
        let date = Calendar.current.date(from: components)!
        return date
    }
    var startOfWeek: Date{
        var components = DateComponents()
        components.year = year
        components.hour = 10
        components.weekOfYear = weekOfYear
        components.weekday = 2 // 1 == lundi
        let date = Calendar.current.date(from: components)!
        return date
    }
    var previousWeek: Date{
        var components = DateComponents()
        components.year = year
        components.hour = 10
        components.weekOfYear = weekOfYear + 1
        components.weekday = 2 // 1 == lundi
        let date = Calendar.current.date(from: components)!
        return date
    }
    var startOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    var monthName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: self)
        
    }
    
    var numberOfWeeksInMonth1: Int {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 0
        let weekRange = calendar.range(of: .weekOfMonth,
                                       in: .month,
                                       for: self)
        return  weekRange!.count
    }
    
    var numberOfWeeksInMonth:Int
    {
        var month = self.month
        var forYear = self.year
        
        
        
        let dateString = String(format: "%4d/%d/01", year, month)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        if let date = dateFormatter.date(from: dateString),
            let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        {
            calendar.firstWeekday = 2 // Monday
            let weekRange = calendar.range(of: .weekOfMonth, in: .month, for: date)
            let weeksCount = weekRange.length
            return weeksCount
        }
   return 0
    }
    
    var currentWeekBegin: Date {
        var date = DateComponents()
        date.weekOfMonth = self.weekOfMonth
        date.weekday = 2
        date.month = self.month
        date.hour = 8
        date.minute = 20
        date.year = self.year
        
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal.date(from: date)!
    }
    func currentWeekDate(_ week: Int, _ month: Int, _ year: Int) -> Date {
        if week == 1 {
            var date = DateComponents()
            date.month = month
            date.day =  1
            
            date.hour = 8
            date.minute = 20
            date.year = year
            
            var cal = Calendar.current
            cal.firstWeekday = 2
            return cal.date(from: date)!
            //return ("\(year)-\(month)-01".date?.firstDayOfTheMonth)!
        }
 
        var date = DateComponents()
        date.weekOfMonth = week
        date.weekday =  2
        date.month = month
        date.hour = 8
        date.minute = 20
        date.year = year
        
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal.date(from: date)!
    }
    var monthBeginDay: Date {
        let monthBeginDate = self.currentWeekBegin
        if monthBeginDate.month == self.month {
            return monthBeginDate
        } else {
            return ("\(self.year)-\(self.month)-01".date?.firstDayOfTheMonth)!
            
        }
    }
    
    func currentWeekToDate( currentWeek: Int)-> Date {
        var date = DateComponents()
        date.weekOfMonth = currentWeek
        date.weekday = 2
        date.month = self.month
        date.hour = 8
        date.minute = 20
        date.year = self.year
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal.date(from: date)!
    }
    
    
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}

extension UIView {
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
}
