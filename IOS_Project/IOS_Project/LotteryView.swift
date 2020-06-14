//
//  LotteryView.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import SwiftUI

struct LotteryView: View {
    @State private var tempReceiptLottery: ReceiptLottery = winningNumbers[0]
    @State private var tempNumber = 0
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    if self.tempNumber < winningNumbers.count-1{
                        self.tempNumber += 1
                        self.tempReceiptLottery = winningNumbers[self.tempNumber]
                    }
                }){
                    Image("back")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height:30)
                }
                .buttonStyle(PlainButtonStyle())
                Text("\(self.tempReceiptLottery.Year)年\(self.tempReceiptLottery.months[0])月/\(self.tempReceiptLottery.months[1])月")
                    .font(.system(size: 24))
                Button(action: {
                    if self.tempNumber > 0{
                        self.tempNumber -= 1
                        self.tempReceiptLottery = winningNumbers[self.tempNumber]
                    }
                }){
                    Image("next")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30,height:30)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding([.top, .bottom], 10)
            Text("統一發票中獎號碼")
                .font(.system(size: 30))
            VStack(alignment: .leading, spacing: 10){
                HStack(alignment: .top){
                    Text("特別獎")
                        .font(.system(size: 24))
                    VStack(alignment: .leading){
                        Text("\(self.tempReceiptLottery.specialPrize)")
                        .font(.system(size: 24))
                    }
                }
                HStack(alignment: .top){
                    Text("特獎    ")
                        .font(.system(size: 24))
                    VStack(alignment: .leading){
                        Text("\(self.tempReceiptLottery.grandPrize)")
                        .font(.system(size: 24))
                    }
                    
                }
                HStack(alignment: .top){
                    Text("頭獎    ")
                        .font(.system(size: 24))
                    VStack(alignment: .leading){
                        Text("\(self.tempReceiptLottery.firstPrize[0])")
                        .font(.system(size: 24))
                        Text("\(self.tempReceiptLottery.firstPrize[1])")
                        .font(.system(size: 24))
                        Text("\(self.tempReceiptLottery.firstPrize[2])")
                        .font(.system(size: 24))
                    }
                    
                }
                HStack(alignment: .top){
                    Text("增開獎")
                        .font(.system(size: 24))
                    VStack(alignment: .leading){
                        ForEach(self.tempReceiptLottery.additionalSixthPrize, id: \.self){ index in
                            Text("\(index)")
                        }
                        .font(.system(size: 24))
                    }
                    
                }
                Text("領獎時間\(self.tempReceiptLottery.receivePrizeDate)")
                    .font(.system(size: 24))
            }
            .padding(10)
            Spacer()
        }
    }
}

struct LotteryView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryView()
    }
}
