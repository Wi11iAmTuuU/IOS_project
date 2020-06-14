//
//  ContentView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            ReceiptListView().tabItem{
                NavigationLink(destination: ReceiptListView()){
                    Text("列表")
                }
            }
            ReceiptLotteryView().tabItem {
                NavigationLink(destination: ReceiptLotteryView()){
                    Text("掃描")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
