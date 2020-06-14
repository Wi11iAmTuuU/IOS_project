//
//  ReceiptLotteryView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct ReceiptLotteryView: View {
    @State private var codeDetail = ""
    @State private var isSharePresented: Bool = false
    @State private var analyzer = Analyzer()
    var body: some View {
        VStack{
            VStack{
                ZStack(alignment: .leading){
                    CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                    OtherView()
                }
            }
            .frame(height: 300)
            Text("內文: \(codeDetail)")
            Text("辨識結果:\(analyzer.receiptDetail)")
            Text("發票號: \(analyzer.tempReceipt.ID)")
            Text("發票日期: \(analyzer.tempReceipt.Date)")
            Spacer()
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isSharePresented = false
            switch result {
            case .success(let code):
                codeDetail = code
                analyzer.transform(data: codeDetail)
            case .failure(let error):
                print("Scanning failed \(error)")
            }
        }
}

struct ReceiptLotteryView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptLotteryView()
    }
}

