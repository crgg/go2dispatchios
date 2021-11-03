//
//  TimeClockRow.swift
//  go2dispatch
//
//  Created by Ramon Gajardo on 10/28/21.
//

import SwiftUI

struct TimeClockRow: View {
    
    let timeHistory :  TimeLogModelHistory
    @State var typeColor = Color.black
    
    var body: some View {
        ZStack {
            Color("time_clock_bg")
                .ignoresSafeArea()
            HStack(spacing : 10) {
            Text(formatoFecha(timeHistory.START_DATE!)).frame(width: 60,
                                                              alignment: .leading)
           
            Text(formatoHora(timeHistory.START_DATE!)).frame(alignment: .trailing)
            
            Text("-")
            Text(formatoHora(timeHistory.END_DATE ?? "")).frame(alignment: .trailing)
            
            
            Text(formatoType(timeHistory.SHIFT_TYPE ?? "")).foregroundColor(typeColor).frame(alignment: .trailing)
            Text(totalTime(timeHistory.START_DATE ?? "", timeHistory.END_DATE ?? "")).frame(maxWidth: .infinity, alignment: .trailing)
            
            
        }
            
        }
    }
    
    func totalTime(_ start_date : String ,_ endDate : String) -> String {
        guard !endDate.isEmpty, !start_date.isEmpty else {
            return ""
        }
        
        let result_date1: Date =  self.convertToDate(start_date, "yyyy-MM-dd HH:mm:ss.000000")
        let result_date2: Date =  self.convertToDate(endDate, "yyyy-MM-dd HH:mm:ss.000000")
        let TotalHours_calculate = Calendar.current.dateComponents([.hour, .minute, .second], from: result_date1, to:  result_date2)
        
        if let hour = TotalHours_calculate.hour , let min = TotalHours_calculate.minute , let sec = TotalHours_calculate.second {
            
            return  String(format: "%02ld:%02ld:%02ld", hour, min , sec)
//            self.timeStart.text  = formattedString
         }
        
        return ""
    }
    
    func formatoType(_ typeShift : String) -> String {
        guard !typeShift.isEmpty else {
            return ""
        }
        
        let prefix = String(typeShift.prefix(1))
        DispatchQueue.main.async {
            self.typeColor =  prefix == "B" ?  Color.red : Color.green
        }
        
        return prefix
    }
    
    
    func formatoFecha(_ fecha : String) -> String {
        let formattter_new = DateFormatter()
        formattter_new.dateFormat = "EE dd"
        formattter_new.locale = Locale(identifier: "en_US")
        let result_date: Date =  self.convertToDate(fecha, "yyyy-MM-dd HH:mm:ss.000000")
        return formattter_new.string(from: result_date)

    }
    
    func formatoHora(_ fecha : String) -> String {
        guard !fecha.isEmpty else {
            return ""
        }
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
        let result_date: Date =  self.convertToDate(fecha, "yyyy-MM-dd HH:mm:ss.000000")
          return  formatter.string(from: result_date)
        }
    
    func convertToDate(_ fecha: String, _ formato : String)->Date {
        let dateformater = DateFormatter()
        dateformater.locale = Locale(identifier: "en_US")
        dateformater.dateFormat = formato
        return dateformater.date(from: fecha) ?? Date()
    }
}

struct TimeClockRow_Previews: PreviewProvider {
    static var previews: some View {
        TimeClockRow(timeHistory: TimeLogModelHistory())
        
    }
}
