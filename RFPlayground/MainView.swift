//
//  MainView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import SwiftUI

struct MainView: View {
    
    let staticTimes = ["6 a", "8 a", "10 a", "12 p", "2 p", "4 p", "6 p", "8 p", "10 p", "12 a", "2 a", "4 a", "6 a"]
    let staticWeekDay = ["Sun", "Sat", "Fri", "Thur", "Wed", "Tue", "Mon", "Sun", "Sat", "Fri"]
    let staticWeekNum = ["29", "28", "27", "26", "25", "24", "23", "22", "21", "20"]
    let daysDisplayed = [0,1,2,3,4,5,6,7,8,9]
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
                        Text("Jan").fontWeight(.bold)
                        Text("2023").fontWeight(.bold)
                    }.frame(height: 46)
                        .background(Color.red)
                    VStack(spacing: 0) {
                        ForEach(staticTimes, id: \.self) {time in
                            Text(time).foregroundColor(Color.white).frame(height: CGFloat(twoHourContainerHeight))
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
                                        Text("\(staticWeekDay[i])")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white).padding(.horizontal)
                                        Text("\(staticWeekNum[i])")
                                            .foregroundColor(.white).padding(.horizontal)
                                        Divider().overlay(Color.white).frame(maxWidth: .infinity)
                                    }.frame(height: 50)
                                    
                                    // 2 Hour Container
                                    ForEach(staticTimes, id: \.self) {time in
                                        if time == staticTimes.last {
                                            TwoHourContainerView(twoHourContainerHeight: CGFloat(twoHourContainerHeight))
                                            
                                        } else {
                                            TwoHourContainerView(twoHourContainerHeight: CGFloat(twoHourContainerHeight))
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
    @State var sectionFills:[Bool] = [false,false,false,false,false,false,false,false]
    
    var body: some View {
        // 2 Hour Container
        VStack(spacing: 0) {
            // Hour Container
            VStack(spacing: 0) {
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 1
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[0] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 2
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[1] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 3
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[2] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 4
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[3] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
            }.frame(height: CGFloat(twoHourContainerHeight)/2)
            // Hour Container
            VStack(spacing: 0) {
                // 30 Min Container
                VStack(spacing: 0) {
                    // 15 Min Container 5
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[4] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
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
                        Rectangle().fill(sectionFills[6] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                    // 15 Min Container 8
                    VStack(spacing: 0) {
                        Rectangle().fill(sectionFills[7] == true ? .purple : .clear).frame(height: CGFloat(twoHourContainerHeight)/8)
                    }
                }.frame(height: CGFloat(twoHourContainerHeight)/4)
            }.frame(height: CGFloat(twoHourContainerHeight)/2)
        }.frame(height: CGFloat(twoHourContainerHeight))
    }
    
}
