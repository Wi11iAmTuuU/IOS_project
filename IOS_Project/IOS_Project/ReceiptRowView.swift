//
//  ReceiptRowView.swift
//  IOS_Project
//
//  Created by 黃彥穎 on 2020/6/25.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct ReceiptRowView: View {
    let receipt: Receipt
    var body: some View {
        HStack {
            if receipt.isDrawn {
                Text("中獎")
                .background(Circle()
                    .fill(Color.red)
                    .frame(width:60, height:60))
                    .padding(.leading, 9.0)
                    .padding(.trailing, 9.0)
            } else {
                Text("未中獎")
                .background(Circle()
                    .fill(Color.gray)
                    .frame(width:60, height:60))
            }
            
            Text(receipt.date)
                .padding(.leading)
            Spacer()
            Text(receipt.id)
            Spacer()
            VStack() {
                Text("TWD")
                    .foregroundColor(.gray)
                Text(String(receipt.amount))
            }
        }
        .padding(.all)
    }
}

struct ReceiptRowView_Previews: PreviewProvider {
    static var previews: some View {
//        ReceiptRowView(receipt: self.analyzer.receipts[0])
        Text("Hello World")
    }
}
