//
//  ReceiptListView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct ReceiptListView: View {
    @EnvironmentObject var analyzer: Analyzer
    var body: some View {
        List(self.analyzer.receipts.indices) { (index) in
            ReceiptRowView(receipt: self.analyzer.receipts[index])
        }
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptListView()
    }
}
