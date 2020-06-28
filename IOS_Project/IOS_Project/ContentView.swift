//
//  ContentView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var analyzer: Analyzer
    var body: some View {
        TabView{
            ReceiptLotteryView().tabItem {
                NavigationLink(destination: ReceiptLotteryView().environmentObject(Analyzer())){
                        Image(systemName: "qrcode.viewfinder")
                        Text("掃描")
                    }
                }
            ReceiptListView().tabItem{
                NavigationLink(destination: ReceiptListView()){
                    Image(systemName: "doc.text.fill")
                    Text("列表")
                }
            }
           
        }.onAppear {
            self.analyzer.loadData()
        }
         .accentColor(.orange)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
