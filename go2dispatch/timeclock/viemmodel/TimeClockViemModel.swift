//
//  TimeClockViemModel.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/28/21.
//

import Foundation
import SwiftUI
class TimeClockViewModel : ObservableObject {
    
    @Published var timelogmodel : TimeLogModel = TimeLogModel()
    
    @Published var messageError = ""
    
    @Published var isError = false
    
    @Published var isClockSuccess = false
    
    @Published var isLoading = false
    
    @Published var timeLogHistory : [TimeLogHistory] = [TimeLogHistory()]
    
    @Published var clockInLocationLabel  = ""
    var secounds = 60
    var  timer : Timer? = nil
    var hours_calculate : Int = 0
    var seconds_calculate  : Int = 0
    var minutes_calculate: Int = 0
    var date_diff : Date = Date()
    @Published var timeStart : String = "00:00:00"

    // Button
    
    @Published var colorButton =   Color.green
    @Published var titleButton =  "CLOCK IN"
    
   
    
    func pickTime() {
        // 1# Location address
        self.isLoading = true
        self.messageError =  ""
        
        CurrentGps.get_location_and_address() {
            (error, result) in
            let (error1, address, latitude, longitude) = self.errorTheGps(error, result)
            if let e = error1  {
                self.isLoading = false
                self.messageError = e
                return
            }
         
            ApiTimeClock.pickTime(location_address: address!, latitude: latitude!, Longitude: longitude!) { success, error, result in
                if let e = error {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.messageError =  e
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.isClockSuccess = true
                    self.getHistory()
                }
            }
        }
        
    }
    
    private func errorTheGps(_ error : String?, _ result : CurrentGpsModel?) -> (String?,String?, Double?, Double?)  {
        
        if let e = error {
            return  (e,nil,nil, nil)
        }
        if let r = result {
            guard let addresslocation = r.addressComplete else {
                return ("Cannot received the address from location", nil, nil, nil)
            }
            guard let latitude =  r.latitude else  {
                return ("Cannot capture the coordinate", nil, nil, nil)
            }
            guard let longitude =  r.longitude else  {
                return ("Cannot capture the coordinate",nil,nil, nil)
            }
            return (nil, addresslocation, latitude, longitude)
        }
        return (nil, nil, nil, nil)
        
    }
    
    func getHistory() {
        self.timeStart = "00:00:00"
        
        self.timer?.invalidate()
        self.timer = nil
        ApiTimeClock.HistoryTimeClock() {
            (success, error, time_zone, data) in
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.messageError = error
                }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.timeLogHistory = data
                    if data.count > 0 {
                        self.checkInfoFromHistory(data[0],  time_zone: time_zone ?? "")
                    }
                 }
                
                return
            }
            DispatchQueue.main.async {
                self.isLoading = false
                self.messageError = "Unknow Error"
            }
                
        }
        
        
    }
    func checkInfoFromHistory(_ data : TimeLogHistory, time_zone : String) {
        
        var stardate =  ""
        var enddate = ""
        var startlocation  = ""
        var  endlocation = ""
//        var typeShip = ""
        if  let timesCloc = data.data {
            if let sd =  timesCloc[0].START_DATE {
                stardate = sd
            }
            if let ed = timesCloc[0].END_DATE {
                enddate = ed
            }
            if let ls = timesCloc[0].START_LOC {
                startlocation = ls
            }
            if let le = timesCloc[0].END_LOC {
                endlocation = le
            }
//            typeShip =  timesCloc[0].SHIFT_TYPE ??  ""
        }
        
        if !stardate.isEmpty && !enddate.isEmpty {
//            self.clockInLastLabel.text = "Clock In : \(stardate)"
            self.clockInLocationLabel = endlocation
            
            self.colorButton = Color.green
            
            self.titleButton = "Clock In"
        
            return
        }
        
        // calculate diference the between start to current
        
        
        let start_date_format: Date =  self.convertToDate(stardate, "yyyy-MM-dd HH:mm:ss.000000")
        let timeZone: Date =  self.convertToDate(time_zone,"yyyy-MM-dd HH:mm:ss.000000")
 
         let  diff_ = Calendar.current.dateComponents([.hour, .minute, .second], from: start_date_format, to:   timeZone)
          if let hour = diff_.hour , let min = diff_.minute , let sec = diff_.second {
                self.hours_calculate = hour
                self.minutes_calculate = min
                self.seconds_calculate = sec + 1
            }
        
        
        
       
        showCurrentTime()
        
        
        self.clockInLocationLabel = startlocation
         
        self.colorButton = Color.red
        
        self.titleButton =  "Clock Out"
        
    }
    
    
    func convertToDate(_ fecha: String, _ formato : String)->Date {
        let dateformater = DateFormatter()
        dateformater.locale = Locale(identifier: "en_US")
        dateformater.dateFormat = formato
        return dateformater.date(from: fecha) ?? Date()
    }
    
    
    func getLastTimeClock() {
        
        ApiTimeClock.lastTimeClock() {
            (success, error, data) in
            if let error = error {
                self.messageError = error
                return
            }
            if let data =  data {
                self.timelogmodel = data
                return
            }
            
        }
    }
    
    
    func showCurrentTime() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire(timer:)), userInfo: nil, repeats: true)
        
        timer?.tolerance = 0.1
    }
    
    @objc func fire(timer: Timer) {
        
 
        if self.seconds_calculate == 59 {
               self.seconds_calculate = 0
               if self.minutes_calculate == 59 {
                 self.minutes_calculate = 0
                 self.hours_calculate = self.hours_calculate + 1
               } else {
                 self.minutes_calculate = self.minutes_calculate + 1
               }
        } else {
               self.seconds_calculate = self.seconds_calculate + 1
         }
        
 
       
        let formattedString = String(format: "%02ld:%02ld:%02ld", hours_calculate, minutes_calculate , seconds_calculate)
        self.timeStart  = formattedString
        
      
        

    }
    
}
