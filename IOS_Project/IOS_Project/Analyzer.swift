//
//  Analyzer.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Analyzer:ObservableObject {
    let receiptPattern = "[A-Z]{2}[0-9]{8}"
    var receiptLotterys: [ReceiptLottery] = winningNumbers
    @Published var receipts: [Receipt] = []
    @Published var tempReceipt: Receipt = Receipt(id: "", date: "", prize: 0, isDrawn: false, amount: 0)
    @Published var repeatInput: Bool = false
    @Published var analyzeResult: String = ""
    
    let myEntityName = "Receipts"
    let myContext = (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer.viewContext
    
    // 處理QR-code資訊
    func transform(data: String){
        tempReceipt = Receipt(id: "", date: "", prize: 0, isDrawn: false, amount: 0)
        let matcher = MyRegex(self.receiptPattern)
        let receipt = String(data.prefix(10))
        if matcher.match(input: receipt) {
            tempReceipt.id = receipt
            tempReceipt.date = (data as NSString).substring(with: NSMakeRange(10, 7))
            if let amount = UInt8(((data as NSString).substring(with: NSMakeRange(29, 8)) as String), radix: 16) {
                tempReceipt.amount = Int(amount)
            }
            analyzeLottery()
        }else{
            tempReceipt.id = ""
            tempReceipt.date = ""
            analyzeResult = "非發票號碼"
        }
    }
    
    // 處理手動輸入資訊
    func manual(ID: String, Date: String, Amount: Int) {
        let year = String(Int(String(Date.prefix(4)))! - 1911)
        let month = (Date as NSString).substring(with: NSMakeRange(4, 4))
        tempReceipt.id = ID
        tempReceipt.date = year + month
        tempReceipt.amount = Amount
        analyzeLottery()
    }
    
    // 發票對獎主區域
    func analyzeLottery(){
        if checkReceipt(){
            checkReceiptLottery()
            receipts.append(tempReceipt)
            insertData()
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
    
    // 發票重複檢查
    func checkReceipt() -> Bool{
        for receipt in receipts{
            if receipt.id == tempReceipt.id{
                return false
            }
        }
        return true
    }
    
    // 特別獎及特獎檢查
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
    
    // 頭獎到六獎檢查
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
                        print("nothing")
                    }
                }
            }
        }
        // 增開獎
        for sixPrize in receiptLottery.additionalSixthPrize{
            let receiptNumber = (receiprID as NSString).substring(with: NSMakeRange(5, 3))
            if receiptNumber == sixPrize{
                tempReceipt.prize = 200
            }
        }
    }
    
    // core data 讀取
    func loadData(){
        let coreDataConnect = CoreDataConnect(context: myContext)
        let selectResult = coreDataConnect.retrieve(
            myEntityName, predicate: nil, sort: [["id":true]], limit: nil)
        if let results = selectResult {
            for result in results {
                receipts.append(Receipt(id: result.value(forKey: "id")! as! String , date: result.value(forKey: "date")! as! String, prize: result.value(forKey: "prize")! as! Int, isDrawn: result.value(forKey: "isDrawn")! as! Bool, amount: result.value(forKey: "amount")! as! Int))
            }
        }
    }
    
    // core data 寫入
    func insertData(){
        let coreDataConnect = CoreDataConnect(context: myContext)
        let insertResult = coreDataConnect.insert(
        myEntityName, attributeInfo: [
            "date" : "\(tempReceipt.date)",
            "id" : "\(tempReceipt.id)",
            "isDrawn" : "\(tempReceipt.isDrawn)",
            "prize" : "\(tempReceipt.prize)",
            "amount" : "\(tempReceipt.amount)"
        ])
        if insertResult {
            print("新增資料成功")
        }
    }
}

// 正規化
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
