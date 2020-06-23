//
//  Analyzer.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import Foundation

class Analyzer:ObservableObject {
    let receiptPattern = "[A-Z]{2}[0-9]{8}"
    var receiptLotterys: [ReceiptLottery] = winningNumbers
    @Published var receiptDetail: String = ""
    @Published var receipts: [Receipt] = []
    @Published var tempReceipt: Receipt = Receipt(id: "", date: "", prize: 0, isDrawn: false)
    @Published var repeatInput: Bool = false
    @Published var analyzeResult: String = ""
    
    func transform(data: String){
        tempReceipt = Receipt(id: "", date: "", prize: 0, isDrawn: false)
        let matcher = MyRegex(self.receiptPattern)
        let receipt = String(data.prefix(10))
        if matcher.match(input: receipt) {
            self.receiptDetail = "辨識成功"
            tempReceipt.id = receipt
            tempReceipt.date = (data as NSString).substring(with: NSMakeRange(10, 7))
            if checkReceipt(){
                checkReceiptLottery()
                receipts.append(tempReceipt)
                repeatInput = false
            }
            else{
                repeatInput = true
            }
            
            if repeatInput{
                analyzeResult = "發票已掃過"
            }else{
                if tempReceipt.isDrawn{
                    if tempReceipt.prize == 0{
                        analyzeResult = "未中獎"
                    }
                    else{
                        analyzeResult = "恭喜獲得\(tempReceipt.prize)元"
                    }
                }else{
                    analyzeResult = "尚未開獎"
                }
            }
        }else{
            self.receiptDetail = "非發票號碼"
            tempReceipt.id = ""
            tempReceipt.date = ""
            analyzeResult = "非發票號碼"
        }
    }
    
    func manual(ID: String,Date: String) {
        let year = String(Int(String(Date.prefix(4)))! - 1911)
        let month = (Date as NSString).substring(with: NSMakeRange(4, 4))
        self.receiptDetail = "辨識成功"
        tempReceipt.id = ID
        tempReceipt.date = year + month
        if checkReceipt(){
            checkReceiptLottery()
            receipts.append(tempReceipt)
            repeatInput = false
        }
        else{
            repeatInput = true
        }
        
        if repeatInput{
            analyzeResult = "發票已掃過"
        }else{
            if tempReceipt.isDrawn{
                if tempReceipt.prize == 0{
                    analyzeResult = "未中獎"
                }
                else{
                    analyzeResult = "恭喜獲得\(tempReceipt.prize)元"
                }
            }else{
                analyzeResult = "尚未開獎"
            }
        }
    }
    func checkReceipt() -> Bool{
        for receipt in receipts{
            if receipt.id == tempReceipt.id{
                return false
            }
        }
        return true
    }
    
    func checkReceiptLottery(){
        let year = String(tempReceipt.date.prefix(3))
        let month = (tempReceipt.date as NSString).substring(with: NSMakeRange(3, 2))
        let ID = (tempReceipt.id as NSString).substring(with: NSMakeRange(2, 8))
        for receiptLottery in receiptLotterys{
            if receiptLottery.Year == year && (receiptLottery.months[0] == month || receiptLottery.months[1] == month){
                if ID == receiptLottery.specialPrize{tempReceipt.prize = 10000000}
                else if ID == receiptLottery.grandPrize{tempReceipt.prize = 2000000}
                else{checkFirstPrize(receiptLottery: receiptLottery, receiprID: ID)}
                tempReceipt.isDrawn = true
            }
        }
    }
    
    func checkFirstPrize(receiptLottery: ReceiptLottery,receiprID: String){
        for firstPrize in receiptLottery.firstPrize{
            for number in 3...8 {
                let prizeNumber = (firstPrize as NSString).substring(with: NSMakeRange(8 - number, number))
                let receiptNumber = (receiprID as NSString).substring(with: NSMakeRange(8 - number, number))
                if prizeNumber == receiptNumber{
                    switch number {
                    case 3:
                        tempReceipt.prize = 200
                    case 4:
                        tempReceipt.prize = 1000
                    case 5:
                        tempReceipt.prize = 4000
                    case 6:
                        tempReceipt.prize = 10000
                    case 7:
                        tempReceipt.prize = 40000
                    case 8:
                        tempReceipt.prize = 200000
                    default:
                        print("no thing")
                    }
                }
            }
        }
    }
}

struct MyRegex {
    let regex: NSRegularExpression?
     
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern,
                                         options: .caseInsensitive)
    }
     
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
            options: [],
            range: NSMakeRange(0, (input as NSString).length)) {
                return matches.count > 0
        } else {
            return false
        }
    }
}
