//
//  Card.swift
//  00004.AnalysisClowCardsData
//
//  Created by Corotata on 2018/3/30.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit
import HandyJSON
class Card: HandyJSON {
    
    var name: String?
    var emblem: String?
    var introduction: String?
    var isDivination: Bool = false
//    var divination: Divination?
    required init(){}
}
