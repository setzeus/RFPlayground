//
//  TabView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/23/23.
//

import SwiftUI

struct TabViewTest: View {
    
    @EnvironmentObject private var purchaseManager:PurchaseManager
    //@State private var selectedTab = "One"

        var body: some View {
            
            TabView {
                ContentView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                }
                MainView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                }
            }
            
        }
}
