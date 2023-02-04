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
    
    var body: some View {
        // View Container
        
        VStack {
            Text("Calendar View").font(.title2)
            
            // Main Container
            HStack {
                
                // Legend
                VStack {
                    VStack {
                        Text("Jan").fontWeight(.bold)
                        Text("2023").fontWeight(.bold)
                    }.frame(height: 50)
                        .background(Color.red)
                    VStack {
                        ForEach(staticTimes, id: \.self) {time in
                            Text(time)
                                .frame(height: 33)
//                            if time == staticTimes[0] {
//                                Text(time)
//                            } else {
//                                Spacer()
//                                Text(time)
//                                Spacer()
//                            }
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
                                    
                                    ForEach(staticTimes, id: \.self) {time in
                                        VStack(spacing: 0) {
                                            Spacer()
                                            Rectangle().fill(.red).frame(height: 16.5)
                                            Spacer()
                                            Divider().overlay(Color.white).frame(maxWidth: .infinity)
                                        }.frame(height: 33)
//                                        if time == staticTimes[0] {
//                                            Text("")
//                                            Divider().overlay(Color.white).frame(maxWidth: .infinity)
//                                        } else {
//                                            Spacer()
//                                            Text("")
//                                            Spacer()
//                                            Divider().overlay(Color.white).frame(maxWidth: .infinity)
//                                        }
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
