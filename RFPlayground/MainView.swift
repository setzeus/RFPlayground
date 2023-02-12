//
//  MainView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import SwiftUI

struct MainView: View {
    
    @State var calendarDays:[Date] = [Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date(),Date()]
    @State var calendarDaysE:[String] = Array(repeating: "", count: 14)
    @State var calendarDaysD:[String] = Array(repeating: "", count: 14)
    let staticTimes = [0,2,4,6,8,10,12,14,16,18,20,22]
    let staticWeekDay = ["Sun", "Sat", "Fri", "Thur", "Wed", "Tue", "Mon", "Sun", "Sat", "Fri"]
    let staticWeekNum = ["29", "28", "27", "26", "25", "24", "23", "22", "21", "20"]
    let daysDisplayed = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
    @State var thirtyDayFifteenMinTuple:[(sectionTime: Date, sectionStatus: Bool)] = [(sectionTime: Date, sectionStatus: Bool)]()
    let twoHourContainerHeight = 45
    
    var body: some View {
        // View Container
        
        VStack {
            Text("Calendar View").font(.title2)
            
            // Main Container
            HStack {
                
                // Legend
                VStack(spacing: 0) {
                    VStack {
                        Text("Feb").fontWeight(.bold)
                        Text("2023").fontWeight(.bold)
                    }.frame(height: 46)
                        .background(Color.red)
                    VStack(spacing: 0) {
                        ForEach(Array(staticTimes.enumerated()), id: \.offset) { index, element in
                            Text(PurchaseManager().hoursLater(startDate: Date(), hoursLater: -element)).foregroundColor(Color.white).frame(height: CGFloat(twoHourContainerHeight))
                        }
                    }
                    Spacer()
                }
                
                // Scrollview Body
                ScrollView(.horizontal) {
                    
                    
                    // HStack -> all vertical columns
                    // VStack -> vertical (day) column
                    // Vstack -> fixed title (day)
                    // Body -> hourly time slots
                    HStack(spacing: 0) {
                        ForEach(daysDisplayed, id: \.self) { i in
                                
                            VStack(spacing: 0) {
                                    
                                    
                                    VStack {
                                        Text("\(calendarDaysE[i])")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white).padding(.horizontal)
                                        Text("\(calendarDaysD[i])")
                                            .foregroundColor(.white).padding(.horizontal)
                                        Divider().overlay(Color.white).frame(maxWidth: .infinity)
                                    }.frame(height: 50)
                                    
                                    // 2 Hour Container
                                    ForEach(staticTimes, id: \.self) {time in
                                        if time == staticTimes.last {
                                            TwoHourContainerView(twoHourContainerHeight: CGFloat(twoHourContainerHeight), twoHourStartTime: Date())
                                            
                                        } else {
                                            Divider().overlay(Color.white).frame(height: 0.1)
                                            TwoHourContainerView(twoHourContainerHeight: CGFloat(twoHourContainerHeight), twoHourStartTime: Date())
                                            Divider().overlay(Color.white).frame(height: 0.1)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    
                                }.padding(.top, 16)
                            
                        }
                        
                    }
                    
                }
                Spacer()
            }.frame(maxHeight: .infinity)
                .background(Color.blue)
                .padding(.bottom, 24)
        }.onAppear {
            let today = Date()
            let calendar = Calendar.current
            let dateFormatterE = DateFormatter()
            dateFormatterE.dateFormat = "E"
            let dateFormatterD = DateFormatter()
            dateFormatterD.dateFormat = "d"
            for i in 0...13 {
                calendarDays[i] = calendar.date(byAdding: .day, value: -i, to: today) ?? Date()
                calendarDaysE[i] = dateFormatterE.string(from: calendarDays[i])
                calendarDaysD[i] = dateFormatterD.string(from: calendarDays[i])
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct TwoHourContainerView: View {
    
    let twoHourContainerHeight:CGFloat
    let twoHourStartTime:Date
    @State var sectionFills:[Bool] = [true,true,true,true,true,true,true,true]
    
    var body: some View {
        // 2 Hour Container
        VStack(spacing: 0) {
            // Hour Container
            VStack(spacing: 0) {
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 1
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[0] == true ? .black : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 2
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[1] == true ? .brown : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 3
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[2] == true ? .cyan : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 4
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[3] == true ? .yellow : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
            }.frame(height: CGFloat(twoHourContainerHeight)/2)
            // Hour Container
            VStack(spacing: 0) {
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 5
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[4] == true ? .pink : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 6
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[5] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 7
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[6] == true ? .red : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 8
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[7] == true ? .orange : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
            }.frame(height: CGFloat(twoHourContainerHeight)/2)
        }.frame(height: CGFloat(twoHourContainerHeight))
    }
    
}
