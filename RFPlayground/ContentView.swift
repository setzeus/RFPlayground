//
//  ContentView.swift
//  RFPlayground
//
//  Created by Jesus Najera Restfully on 1/12/23.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    
    // 1. Never been a client -> can consult or purchase care package
    // 2. Never been a client -> can purchase care package
    // 3. Active client -> in care package
    // 4. Active client -> in trial subscription
    // 5.A Active client -> subscribed
    // 5.B Not subscribed  -> re-subscribe button
    
    @EnvironmentObject private var purchaseManager:PurchaseManager
    
    var body: some View {
        VStack(spacing: 20) {
            
            switch purchaseManager.status {
                
                case .neverConsulted:
                    NeverConsultedView(purchaseManager: purchaseManager)
                
                case .neverBought:
                    ConsultedNeverBoughtView(purchaseManager: purchaseManager)
                        
                case .activeCore:
                
                if !purchaseManager.check20Secs(purchaseDate: purchaseManager.datePurchased) {
                        VStack {
                            Spacer()
                            Text("Active Client - Core")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("RF2Text"))
                            Spacer()
                            VStack {
                                
                                Text("An active client currently in the two-week Core program.")
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                            Button(action: {
                                purchaseManager.updateClientStatus(newStatus: .inactiveSubscriptionShort)
                            }, label: {
                                Text("Fast-Forward 2 Weeks / Complete Core")
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(Color(red: 0, green: 0, blue: 0.5))
                                    .clipShape(Capsule())
                            })
                            Spacer()
                        }
                    } else {
                        VStack {
                            Spacer()
                            Text("Active Client - Core Ended")
                                .fontWeight(.heavy)
                                .font(.title2)
                                .multilineTextAlignment(.center)
                            Text("An active client with a core program that just ended. ")
                                .multilineTextAlignment(.center)
                            Spacer()
                            ForEach(purchaseManager.products) { product in
                                
                                if product.id == "01" {
                                    Button(action: {

                                        _ = Task<Void, Never> {
                                            do {
                                                try await purchaseManager.purchase(product)
                                            } catch {
                                                print(error)
                                            }
                                        }


                                    }, label: {
                                        
                                        Text("Restfully Support - $30/Mo")
                                            .foregroundColor(Color.white)
                                            .padding()
                                            .background(Color(red: 0, green: 0.5, blue: 0))
                                            .clipShape(Capsule())
                                    })
                                }
                                
                            }
                            Button(action: {
                                purchaseManager.updateClientStatus(newStatus: .inactiveSubscriptionShort)
                            }, label: {
                                Text("Not Now, Thanks")
                                    .foregroundColor(Color.white)
                                    .padding()
                                    .background(Color(red: 0.5, green: 0, blue: 0))
                                    .clipShape(Capsule())
                            })
                            Spacer()
                        }
                    }
                    
                case .activeSubscription:
                    VStack {
                        Spacer()
                        Text("Active Subscription")
                            .fontWeight(.heavy)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("An active monthly subscription. For testing reasons this subscription is set to 20 secs.")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button(action: {
                            purchaseManager.updateClientStatus(newStatus: .inactiveSubscriptionShort)
                        }, label: {
                            Text("Fast-Forward A Month")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0.5))
                                .clipShape(Capsule())
                        })
                        Spacer()
                    }
                    
                case .inactiveSubscriptionShort:
                    VStack {
                        Spacer()
                        Text("Inactive Client")
                            .fontWeight(.heavy)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text("Either just finished core or was recent subcriber < 3 months ago")
                            .multilineTextAlignment(.center)
                        Spacer()
                        Button(action: {
                            purchaseManager.updateClientStatus(newStatus: .inactiveSubscriptionShort)
                        }, label: {
                            Text("Fast-Forward A Quarter")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0.5))
                                .clipShape(Capsule())
                        })
                        Button(action: {
                            purchaseManager.updateClientStatus(newStatus: .inactiveSubscriptionShort)
                        }, label: {
                            Text("Resubscribe")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0.5))
                                .clipShape(Capsule())
                        })
                        Spacer()
                    }
                    
                case .inactiveSubscriptionLong:
                    Text("Inactive client, more than 3 months")
                
                case .graceSubscription:
                Text("Active client currently in grace period")
                    
                default:
                    Text("test")
                
            }
            
        }.task {
            Task {
                do {
                    try await purchaseManager.loadProducts()
                } catch {
                    print(error)
                }
            }
        }.background(Image("RFDummyBackground").resizable())
        .ignoresSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width, height: .infinity)
    }

    
}

struct NeverConsultedView: View {
    
    @ObservedObject var purchaseManager:PurchaseManager
    @State private var neverConsultedWalkthroughCounter = 0
    let walkthroughTitle:[String] = ["Constant Coach Care","Educational Content","Community of Moms"]
    let walkthroughDescription:[String] = ["Constant on-coach connection with your assigned coach. Through text or video chat","Access to a library of Restfully-created early childhood development resources","Become an active part of a coach-led community of moms also finding their way."]
    let featureImage:[String] = ["featureImage0","featureImage1", "featureImage2"]
    
    var body: some View {
        VStack {
            Spacer()
            // Header, not carousel
            Text("Start Your Care Support")
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("RF2Text"))
                .padding(.horizontal, 16)
            
            Spacer()

            // Carousel here
            Button(action: {
                if neverConsultedWalkthroughCounter == 2 {
                    neverConsultedWalkthroughCounter = 0
                } else {
                    neverConsultedWalkthroughCounter = neverConsultedWalkthroughCounter + 1
                }
            }, label: {
                VStack {
                    Text(walkthroughTitle[neverConsultedWalkthroughCounter])
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("RF2Text"))
                    Text(walkthroughDescription[neverConsultedWalkthroughCounter])
                        .multilineTextAlignment(.center)
                    Image(featureImage[neverConsultedWalkthroughCounter])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 192, height: 192)
                    // dot indicators here
                }.padding(.horizontal, 56)
            }).buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            VStack {
                //Spacer()
                Text("Rest Care - $400")
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("RF2Text"))
                Button(action: {
                    purchaseManager.didConsultStorage = true
                    purchaseManager.updateClientStatus(newStatus: .neverBought)
                    //zpurchaseManager.didConsult = true
                }, label: {
                    Text("Complimentary Consult")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding(.vertical)
                        .frame(width: 256)
                        .background(Color("RF2Text"))
                        .cornerRadius(8)
                })
                ForEach(purchaseManager.products) { product in
                    
                    if product.id == "03" {
                        Button(action: {

                            _ = Task<Void, Never> {
                                do {
                                    try await purchaseManager.purchase(product)
                                } catch {
                                    print(error)
                                }
                            }


                        }, label: {
                            
                            Text("Restfully Care - \(product.displayPrice)")
                                .foregroundColor(Color.white)
                                .padding()
                                .background(Color(red: 0.188, green: 0.78, blue: 0.71))
                                .clipShape(Capsule())
                        })
                    }
                    
                }
                Text("This is our core Restfully sleep service - where we assign you a personal coach to get your sleep back in 14 days.")
                    .fontWeight(.ultraLight)
                    .multilineTextAlignment(.center)
                //Spacer()
            }.padding(.bottom, 96).padding(.top, 32).background(Color.white)
           // Spacer()
        }
    }
    
}

struct ConsultedNeverBoughtView: View {
    
    @ObservedObject var purchaseManager:PurchaseManager
    
    var body: some View {
        VStack {
            Spacer()
            Text("Never Been A Client, Has Consulted")
                .fontWeight(.heavy)
                .font(.title2)
                .multilineTextAlignment(.center)
            Text("A new download that has now done one consult either here or on the website & therefore can only buy the core Restfully Care package.")
                .multilineTextAlignment(.center)
            Spacer()
            ForEach(purchaseManager.products) { product in
                
                if product.id == "03" {
                    Button(action: {

                        _ = Task<Void, Never> {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }


                    }, label: {
                        
                        Text("Restfully Care - \(product.displayPrice)")
                            .foregroundColor(Color.white)
                            .padding()
                            .background(Color(red: 0, green: 0.5, blue: 0))
                            .clipShape(Capsule())
                    })
                }
                
            }
            Spacer()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
