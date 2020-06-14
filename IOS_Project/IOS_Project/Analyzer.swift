//
//  Analyzer.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import Foundation

struct Analyzer {
    let receiptPattern = "[A-Z]{2}[0-9]{8}"
    
    var receiptDetail: String = ""
    var tempReceipt: Receipt = Receipt(id: "", date: "")
    var receipts: [Receipt] = []
    
    mutating func transform(data: String){
        let matcher = MyRegex(self.receiptPattern)
        let receipt = String(data.prefix(10))
        if matcher.match(input: receipt) {
            self.receiptDetail = "辨識成功"
            tempReceipt.ID = receipt
            tempReceipt.Date = (data as NSString).substring(with: NSMakeRange(10, 7))
        }else{
            self.receiptDetail = "非發票號碼"
            tempReceipt.ID = ""
            tempReceipt.Date = ""
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
