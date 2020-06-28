//
//  ReceiptLottery.swift
//  IOS_Project
//
//  Created by 涂家瑋 on 2020/6/14.
//  Copyright © 2020 williamtuuu. All rights reserved.
//

import Foundation

struct ReceiptLottery {
    var Year: String
    var months: [String]
    var specialPrize: String
    var grandPrize: String
    var firstPrize: [String]
    var additionalSixthPrize: [String]
    var receivePrizeDate: String
}

let winningNumbers = [
    ReceiptLottery(Year: "109", months: ["03","04"], specialPrize: "91911374", grandPrize: "08501338", firstPrize: ["57161318","23570653","47332279"], additionalSixthPrize: ["519"], receivePrizeDate: "2020/06/06 - 2020/09/07"),
    ReceiptLottery(Year: "109", months: ["01","02"], specialPrize: "59647042", grandPrize: "01260528", firstPrize: ["01616970","69921388","53451508"], additionalSixthPrize: ["710","585","633"], receivePrizeDate: "2020/02/06 - 2020/05/05"),
       ReceiptLottery(Year: "108", months: ["11","12"], specialPrize: "12620024", grandPrize: "39793895", firstPrize: ["67913945","09954061","54574947"], additionalSixthPrize: ["007"], receivePrizeDate: "2020/04/06 - 2020/07/06"),
]
