//
//  ReceiptLotteryView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ReceiptLotteryView: View {
    @State private var codeDetail = ""
    @State private var isSharePresented: Bool = false
    @State private var analyzer = Analyzer()
    @State private var isLight = false
    @State private var isNavigationBarHidden = true
    @State private var isLottery = false
    @State private var show = false
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    ZStack(alignment: .leading){
                        CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                        HStack{
                            Image("qrcode")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150,height:150)
                            .padding(.leading, 80)
                            Spacer()
                            VStack(spacing: 30){
                                Button(action: {
                                    if self.isLight == false{
                                        self.isLight = true
                                    }else{
                                        self.isLight = false
                                    }
                                    self.toggleTorch(on: self.isLight)
                                }) {
                                    Image("idea")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30,height:30)
                                }
                                
                                NavigationLink(destination: ManualInputView()){
                                    Image("document")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30,height:30)
                                }
                                
                                Button(action: {
                                    self.isLottery = true
                                }) {
                                    Image("cup")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30,height:30)
                                }.sheet(isPresented: $isLottery,content: {
                                    LotteryView()
                                })
                                
                            }
                        .padding(30)
                        }
                    }
                }
                .frame(height: 300)
                Text("內文: \(codeDetail)")
                Text("辨識結果:\(analyzer.receiptDetail)")
                Text("發票號: \(analyzer.tempReceipt.ID)")
                Text("發票日期: \(analyzer.tempReceipt.Date)")
                Spacer()
            }
            .navigationBarTitle("掃描")
            .navigationBarHidden(self.isNavigationBarHidden)
            .onAppear{self.isNavigationBarHidden = true}
            .onDisappear{self.isNavigationBarHidden = false}
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
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}

struct ReceiptLotteryView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptLotteryView()
    }
}

