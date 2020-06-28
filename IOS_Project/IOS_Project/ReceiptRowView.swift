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
                .font(.system(size: 14))
                .padding(20)
                .background(Circle()
                    .fill(Color.orange)
                    .frame(width:55, height:55))
            } else {
                Text("未中")
                    .font(.system(size: 14))
                     .padding(20)
                .background(Circle()
                .fill(Color.gray)
                .frame(width:55, height:55))
            }
            
            Text(receipt.date)
                .font(.system(size: 14))
                .padding(.leading)
            Spacer()
            Text(receipt.id)
            .font(.system(size: 14))
            Spacer()
            VStack() {
                Text("TWD")
                    .font(.system(size: 14))
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
