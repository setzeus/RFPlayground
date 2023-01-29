//
//  MainView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import SwiftUI

struct MainView: View {
    
    let staticTimes = ["6 a", "8 a", "10 a", "12 p", "2 p", "4 p", "6 p", "8 p", "10 p", "12 a", "2 a", "4 a"]
    
    var body: some View {
        // View Container
        
        VStack {
            Text("Calendar View").font(.title2)
            HStack {
                VStack {
                    VStack {
                        Text("Jan").fontWeight(.bold)
                        Text("2023").fontWeight(.bold)
                    }
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
                    VStack {
                        Text("Jan")
                        Text("2023")
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
