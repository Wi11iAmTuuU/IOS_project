//
//  ReceiptLotteryView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI
import AVFoundation

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: 150 , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.black)
                
                Rectangle().frame(width: min(CGFloat(self.value)*150, 150), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}
struct ReceiptLotteryView: View {
    @State private var temp: Int = 0
    @State private var brightness: Double = 0.0
    @State private var blur: CGFloat = 0
    @State var progressValue: Float = 0.0
    @EnvironmentObject var analyzer: Analyzer
    @State private var codeDetail = ""
    @State private var colorChange = false
    @State private var isLight = false
    @State private var isLottery = false
    @State private var isManual = false
    @State private var isScan = false
    @State private var level:Int = 1
    @State private var name:String = "Image-2"
    @State var add: Float = 1
    var body: some View {
        VStack(){
            VStack{
                ZStack(alignment: .leading){
                    CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                    HStack{
                        Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150,height:150)
                        .padding(.leading, 80)
                        .opacity(0.5)
                        Spacer()
                        
                        VStack(spacing: 10){
                            Button(action: {
                                if self.isLight == false{
                                    self.isLight = true
                                }else{
                                    self.isLight = false
                                }
                                self.toggleTorch(on: self.isLight)
                                self.colorChange.toggle()
                            }) {
                                Image(systemName: "flashlight.off.fill")
                                .frame(width: 20,height:20)
                                .padding(10)
                                    .foregroundColor(colorChange ? .orange : .gray )
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.142))
                                   
                            }
                            .cornerRadius(100)
                            .padding(.leading,80)
                            .buttonStyle(PlainButtonStyle())
                            Button(action: {
                                self.isManual = true
                            }) {
                                Image(systemName: "square.and.pencil")
                                .frame(width: 20,height:20)
                                .padding(10)
                                .foregroundColor(.gray )
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.142))
                            }.sheet(isPresented: $isManual,content: {
                                ManualInputView().environmentObject(self.analyzer)
                            })
                            .cornerRadius(100)
                                .foregroundColor(Color.orange )
                             .padding(.leading,80)
                            Button(action: {
                                self.isLottery = true
                            }) {
                                Image(systemName: "rosette")
                                .frame(width: 20,height:20)
                                .padding(10)
                                .foregroundColor(.gray )
                                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.142))
                            }.sheet(isPresented: $isLottery,content: {
                                LotteryView()
                            })
                            .cornerRadius(100)
                             .padding(.leading,80)
                            
                        }
                    .padding(30)
                    }
                }
            }
            .frame(height: 250)
            // 小怪獸放置處
            
            
            Spacer()
            ZStack(alignment: .leading){
                Image("下載")
                    .resizable()
                    .padding(5.0)
                VStack(alignment: .center){
                    Button(action: {
                        
            
                    }) {
                        Image(self.name)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 150.0, height: 150.0)
                        .brightness(brightness)
                        .blur(radius: blur)
                        
                    }
                   
                    Text("level \(level)")
                        .padding(.horizontal, 10)
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.142))
                    .cornerRadius(45.0)
                    
                    HStack(){
                        ProgressBar(value: $progressValue).frame(height: 10)
                    }
                    
                   
                }
                
            }
        }
        .toast(isPresented: self.$isScan){
            HStack{
                Text("\(self.analyzer.analyzeResult)")
            }
        }
    }
    func startProgressBar(i: Float) {
        for _ in 0...1000 {
                self.progressValue += i/1000
        }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        if(self.progressValue >= 1){
            self.resetProgressBar()
        }
        if(self.level == 3){
            for i in 0...100 {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01*Double(i)) {
                      self.brightness += 0.01
                      self.blur += 0.01
                  }
              }
              for i in 100...105 {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01*Double(i)) {
                      self.name = "Image-1"
                  }
                  
              }
            for i in 100...200 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01*Double(i)) {
                    self.brightness -= 0.01
                    self.blur -= 0.01
                }
            }
            
        }
        }
    }
    
    func resetProgressBar() {
        self.level += 1
        self.add /= Float(self.level)
        self.progressValue = 0.0
    }
    // 處理QR-code
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        switch result {
        case .success(let code):
            
            codeDetail = code
            analyzer.transform(data: codeDetail)
            if(!analyzer.repeatInput){
                startProgressBar(i: self.add)
                
                
            }
            withAnimation {
                self.isScan = true
            }
        case .failure(let error):
            print("Scanning failed \(error)")
        }
    }
    
    // 手電筒啓閉
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

