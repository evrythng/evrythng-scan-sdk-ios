//
//  DateUtils.swift
//  EvrythngiOS
//
//  Created by JD Castro on 10/05/2017.
//  Copyright © 2017 ImFree. All rights reserved.
//

import UIKit

public class DateUtils {

    public class func date(srcDate: String, format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter.date(from: srcDate)
    }
    
    public class func getDateApiFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        return dateFormatter
    }
}
