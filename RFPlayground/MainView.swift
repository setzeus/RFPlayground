//
//  MainView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import SwiftUI

struct MainView: View {
    
    // State Object because only this view & it's children need to have access to this initialized instance of CalendarManager
    // Children of this view should use passed-down ObservedObjects
    @StateObject var calendarManager:CalendarManager = CalendarManager()
    @State var calendarDays:[Date] = Array(repeating: Date(), count: 14)
    @State var calendarDaysE:[String] = Array(repeating: "", count: 14)
    @State var calendarDaysD:[String] = Array(repeating: "", count: 14)
    @State var loadTime = Date()
    @State var startDate:Date = Date()
    @State var endDate:Date = Date()
    @State var datesReady:Bool = false
    let staticTimes = [0,2,4,6,8,10,12,14,16,18,20,22]
    let daysDisplayed = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
    let twoHourContainerHeight = 45
    
    //
    
    var body: some View {
        // View Container
        
        VStack {
            
            HStack {
                if datesReady {
                    Button(action: {
                        print(startDate)
                        print(endDate)
                        calendarManager.updateLastTwoWeeksFiveMinContainer(sessionStartTime: startDate, sessionEndTime: endDate)
                    }, label: {
                        Text("Test Date Overlay")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(.purple)
                            .clipShape(Capsule())
                    })
                } else {
                    Spacer()
                    VStack {
                        HStack{
                            Spacer()
                            Text("Start Time")
                            DatePicker("", selection: $startDate)
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text("End Time")
                            DatePicker("", selection: $endDate)
                            Spacer()
                        }
                        Button(action: {
                            calendarManager.updateLastTwoWeeksFiveMinContainer(sessionStartTime: startDate, sessionEndTime: endDate)
                        }, label: {
                            Text("Go")
                        })
                    }
                    Spacer()
                }
               
            }.padding(.top,16).background(Color(red: 0.98, green: 0.98, blue: 0.98)).frame(maxWidth: .infinity)
            
            // Main Container
            HStack {
                
                // Legend
                VStack(spacing: 0) {
                    VStack {
                        Text("Feb").fontWeight(.bold)
                        Text("2023").fontWeight(.bold)
                    }.frame(height: 46)
                    ForEach(Array(staticTimes.enumerated()), id: \.offset) { index, element in
                        VStack {
                            Text(calendarManager.hoursLater(startDate: Date(), hoursLater: -element)).padding(.top, 5)
                            Spacer()
                        }.frame(height: CGFloat(twoHourContainerHeight))
                    }
                    Spacer()
                }
                
                // Scrollview Body
                ScrollView(.horizontal) {
                    
                    
                    // HStack -> All vertical columns
                    HStack(spacing: 0) {
                        // Last 30 days
                        ForEach(Array(calendarDays.enumerated()), id: \.offset) { i, e in
                            // Each day column
                            VStack(spacing: 0) {
                                // Day details -> "Mon 14"
                                VStack {
                                    Text("\(calendarDaysE[i])")
                                        .fontWeight(.semibold)
                                        .padding(.horizontal)
                                    Text("\(calendarDaysD[i])")
                                        .padding(.horizontal)
                                    Divider().overlay(Color.gray).frame(maxWidth: .infinity)
                                }.frame(height: 60)
                                
                                // The 288 5-minute segments for eacn day
                                ForEach(Array(calendarManager.thiryDayFiveMinArray.enumerated()), id: \.offset) { j, f in
                                    if j >= 288*i && j < 288*(i+1) {
                                        if j == 288*i {
                                            if (calendarManager.thiryDayFiveMinArray[j].sectionStatus == true) {
                                                Rectangle().fill(Color(red: 0.4, green: 0.345, blue: 0.792)).frame(height: CGFloat(1.875))
                                            } else {
                                                Rectangle().fill(.clear).frame(height: CGFloat(1.875))
                                            }
                                        } else {
                                            if j%24 == 0 {
                                                VStack(spacing: 0) {
                                                    Divider().overlay(Color.gray).frame(height: 0.1)
                                                    if (calendarManager.thiryDayFiveMinArray[j].sectionStatus == true) {
                                                        Rectangle().fill(Color(red: 0.4, green: 0.345, blue: 0.792)).frame(height: CGFloat(1.875))
                                                    } else {
                                                        Rectangle().fill(.clear).frame(height: CGFloat(1.875))
                                                    }
                                                }
                                            } else {
                                                VStack(spacing: 0) {
                                                    if (calendarManager.thiryDayFiveMinArray[j].sectionStatus == true) {
                                                        Rectangle().fill(Color(red: 0.4, green: 0.345, blue: 0.792)).frame(height: CGFloat(1.875))
                                                    } else {
                                                        Rectangle().fill(.clear).frame(height: CGFloat(1.875))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                    }
                    
                    
                    
                }
                Spacer()
            }
                .background(Color.white)
        }.onAppear {
            
            // Now
            let today = Date()
            let calendar = Calendar.current
            
            // Formats
            let dateFormatterE = DateFormatter()
            dateFormatterE.dateFormat = "E"
            let dateFormatterD = DateFormatter()
            dateFormatterD.dateFormat = "d"
            
            loadTime = Date()
            endDate = loadTime
            startDate = loadTime
            
            // Initialize 15-min sessions for the last 30 days, round to the previous 5 mins
            calendarManager.initializeLastThirtyDaysEveryMinTuple(startDate: startDate)
            
            
            
            for i in 0...13 {
                calendarDays[i] = calendar.date(byAdding: .day, value: -i, to: today) ?? Date()
                calendarDaysE[i] = dateFormatterE.string(from: calendarDays[i])
                calendarDaysD[i] = dateFormatterD.string(from: calendarDays[i])
            }
        }
    }
}
