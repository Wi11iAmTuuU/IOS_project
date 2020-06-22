//
//  ManualInputView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct ManualInputView: View {
    let receiptPattern = "^[A-Z]{2}[0-9]{8}$"
    @State private var receiptDate = Date()
    @State private var receiptID = ""
    @State private var wrongInput = false
    
    var body: some View {
        VStack{
            VStack(alignment: .center){
                Text("請輸入發票資訊")
                .font(.title)
            }
            .padding([.top, .bottom], 10)
            VStack(alignment: .leading, spacing: 10){
                Text("發票日期")
                DatePicker("",selection: $receiptDate, displayedComponents: .date)
                .labelsHidden()
                Text("發票號碼")
                TextField("英文２碼＋數字８碼", text: $receiptID)
            }
            .padding([.leading, .trailing], 30)
            VStack(alignment: .center){
                Button(action:
                    {
                        let matcher = MyRegex(self.receiptPattern)
                        if matcher.match(input: self.receiptID) {
                            self.wrongInput = false
                        }else {
                            self.wrongInput = true
                        }
                    }){
                        Text("確認")
                            .padding(EdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 25))
                            .font(.system(size: 18))
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(40)
                    }
                    .alert(isPresented: $wrongInput){
                        Alert(title: Text("發票規格錯誤"))
                    }
            }
            .padding(.top, 10)
            Spacer()
        }
    }
}

struct ManualInputView_Previews: PreviewProvider {
    static var previews: some View {
        ManualInputView()
    }
}
