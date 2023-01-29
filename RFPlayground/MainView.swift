//
//  MainView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import SwiftUI

struct MainView: View {
    
    let staticTimes = ["6 a", "8 a", "10 a", "12 p", "2 p", "4 p", "6 p", "8 p", "10 p", "12 a", "2 a", "4 a"]
    let staticWeekDay = ["Sun", "Sat", "Fri", "Thur", "Wed", "Tue", "Mon", "Sun", "Sat", "Fri"]
    let staticWeekNum = ["29", "28", "27", "26", "25", "24", "23", "22", "21", "20"]
    let daysDisplayed = [0,1,2,3,4,5,6,7,8,9]
    
    var body: some View {
        // View Container
        
        VStack {
            Text("Calendar View").font(.title2)
            HStack {
                VStack {
                    VStack {
                        Text("Jan").fontWeight(.bold)
                        Text("2023").fontWeight(.bold)
                    }.frame(height: 50)
                        .background(Color.red)
                    VStack {
                        ForEach(staticTimes, id: \.self) {time in
                            if time == staticTimes[0] {
                                Text(time)
                            } else {
                                Spacer()
                                Text(time)
                                Spacer()
                            }
                        }
                    }
                }
                ScrollView(.horizontal) {
                    
                    ForEach(daysDisplayed, id: \.self) { i in
                        
                        HStack(spacing: 20) {
                                ForEach(0..<10) {
                                    Text("Item \($0)")
                                        .foregroundColor(.white)
                                        .font(.largeTitle)
                                        .background(.red)
                                }
                            }
                        //Text(staticWeekDay[i]).fontWeight(.bold)
//                        VStack {
//                            VStack {
//                                Text(staticWeekDay[i]).fontWeight(.bold)
//                                Text(staticWeekNum[i]).fontWeight(.bold)
//                            }.frame(height: 75)
//                                .background(Color.red)
//                        }
                    }
                    
                }
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
