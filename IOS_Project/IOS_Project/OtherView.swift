//
//  OtherView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI
import AVFoundation

struct OtherView: View {
    @State private var isLight = false
    @State private var isManual = false
    @State private var isLottery = false
    
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
    
    var body: some View {
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
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height:30)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    self.isManual = true
                }) {
                    Image("document")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height:30)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isManual, content: {
                    ManualInputView()
                })
                
                Button(action: {
                    self.isLottery = true
                }) {
                    Image("cup")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height:30)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $isLottery, content: {
                    LotteryView()
                })
            }
        .padding(30)
        }
    }
}

struct OtherView_Previews: PreviewProvider {
    static var previews: some View {
        OtherView()
    }
}
