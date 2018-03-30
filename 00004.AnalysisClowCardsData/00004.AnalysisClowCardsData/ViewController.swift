//
//  ViewController.swift
//  00004.AnalysisClowCardsData
//
//  Created by Corotata on 2018/3/30.
//  Copyright © 2018年 Corotata. All rights reserved.
//

import UIKit
import HandyJSON

/*
 1.风(The Windy)
 现在: 好像无意间将采取跟自己所想的正相反的态度，看来不诚意不行哦。
 障碍: 会出现爱情的妨碍者，要象樱似的，光明正大地将其拨掉。
 未来: 将有新风味来，看来你将会舍去现在喜欢的人，而另有所爱。
 对策: 不要太紧张，只要你大胆地看着对方眼睛说话，就会意外地镇静。
 幸运项目: 大一点的书，明朗的绿色服饰，团扇。
 2.影(The Shadow)
 现在: 是有点令人担忧的关系。即使隐藏，也总有一日暴露给大家。
 障碍: 看来象有一堵高 ，不过别滞气，总有找到解决方法的。
 对策: 暂时没有信心时，要看着自己的影子，连说三次"魔鬼走开"，就会产生新的精神。
 幸运项目: 建筑物的背阳地，带洞黑色的上衣，摄像机。
 */

//需求描述
//1. 将data.txt这份数据转化为Divination相应的模型数据
//2. 风为中文名字
//3. The Windy为英文名字
//4. 再者现在、障碍、未来、对策、幸运项目为可有可无



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(analysisData().toJSONString(prettyPrint: true) ?? "")
        let cards = analysisData2()
        let divinations = analysisData()
        
        for card in cards {
            if let divination = divinations.filter({ $0.name?.lowercased() == card.name?.lowercased()}).first{
                card.isDivination = true
            }
        }
        print(cards.toJSONString(prettyPrint: true) ?? "")
        
        for div in divinations {
            if let divination = cards.filter({ $0.name?.lowercased() == div.name?.lowercased()}).first{
                
            }else {
                print(div.name)
            }
        }
        
        let str: NSString = cards.toJSONString(prettyPrint: true)! as NSString
        try? str.write(toFile: "/Users/corotata/Desktop/Card/card.json", atomically: true, encoding: String.Encoding.utf8.rawValue)
        
        
        
        let divinationStr: NSString = divinations.toJSONString(prettyPrint: true)! as NSString
        try? divinationStr.write(toFile: "/Users/corotata/Desktop/Card/divination.json", atomically: true, encoding: String.Encoding.utf8.rawValue)
        
    }
    
    func analysisData2() -> [Card]{
        var cards: [Card] = [Card]()
        guard let resourceDataPath = Bundle.main.path(forResource: "data2", ofType: "txt") else {
            return [Card]()
        }
        
        var txtStr: NSString = try! NSString(contentsOfFile: resourceDataPath, encoding: String.Encoding.utf8.rawValue)
        
        txtStr = txtStr.replacingOccurrences(of: ": ", with: ":") as NSString
        txtStr = txtStr.replacingOccurrences(of: "）", with: "") as NSString
        txtStr = txtStr.replacingOccurrences(of: "：", with: ":") as NSString
        
        var mArray = txtStr.components(separatedBy: "（")
        mArray.removeFirst()
        
        for itemStr in mArray {
            let card = Card()
            for (index,item) in itemStr.components(separatedBy: "\n").enumerated()
            {
                if index == 0 {
                    card.name = item.capitalized
                }else if item.contains("象征"){
                    if item.contains(":"){
                        card.emblem = item.components(separatedBy: ":").last
                    }else if item.contains(" "){
                        card.emblem = item.components(separatedBy: " ").last
                    }
                }else if item.contains("简介"){
                    if item.contains(":"){
                        card.introduction = item.components(separatedBy: ":").last
                    }else if item.contains(" "){
                        card.introduction = item.components(separatedBy: " ").last
                    }
                }
                
            }
            cards.append(card)
        }
       return cards
    }
    
    func analysisData() -> [Divination]{
        guard let resourceDataPath = Bundle.main.path(forResource: "data", ofType: "txt") else {
            return [Divination]()
        }
        
        var txtStr: NSString = try! NSString(contentsOfFile: resourceDataPath, encoding: String.Encoding.utf8.rawValue)
        
        /***
         由于"（）" ，"："，由于这些数据都是我们不需要的，那么我们需要去除他们，清理完后的数据
         
         1.风:The Windy
         现在:好像无意间将采取跟自己所想的正相反的态度，看来不诚意不行哦。
         障碍:会出现爱情的妨碍者，要象樱似的，光明正大地将其拨掉。
         未来:将有新风味来，看来你将会舍去现在喜欢的人，而另有所爱。
         对策:不要太紧张，只要你大胆地看着对方眼睛说话，就会意外地镇静。
         幸运项目:大一点的书，明朗的绿色服饰，团扇。
         
         ***/
        
        txtStr = txtStr.replacingOccurrences(of: ": ", with: ":") as NSString
        txtStr = txtStr.replacingOccurrences(of: "(", with: ":") as NSString
        txtStr = txtStr.replacingOccurrences(of: ")", with: "") as NSString
        
        /***
         2.先通过.进行分割，那么可以分割成为一个含有41个元素的数据，其中首项为"1",其他的如：""
         风(The Windy)
         现在: 好像无意间将采取跟自己所想的正相反的态度，看来不诚意不行哦。
         障碍: 会出现爱情的妨碍者，要象樱似的，光明正大地将其拨掉。
         未来: 将有新风味来，看来你将会舍去现在喜欢的人，而另有所爱。
         对策: 不要太紧张，只要你大胆地看着对方眼睛说话，就会意外地镇静。
         幸运项目: 大一点的书，明朗的绿色服饰，团扇。
         2
         ***/
        var divinations = [Divination]()
        var mArray = txtStr.components(separatedBy: ".")
        
        //3.由于首项为1，为无效数据，切除掉
        mArray.removeFirst()
        
        //4.继续切掉如2，3，4等无效数据
        for itemSourceStr in mArray {
            //5.通过换行，将每项进行分割，除了数组最后一项，
            var itemArray:[String] = itemSourceStr.components(separatedBy: "\n")
            
            if let last = itemArray.last {
                //6. 每个数组的最后一项都会存在如2，3等无效数组，去除掉
                if !last.contains(":"){
                    itemArray.removeLast()
                }
            }
            
            print(itemArray)
            let divination: Divination = Divination()
            for (index,item) in itemArray.enumerated() {
                
                //7.最后按：分割，开始取值
                let lineArray = item.components(separatedBy: ":")
                if let key = lineArray.first,let value = lineArray.last {
                    if index == 0 {
                        divination.zName = key
                        divination.name = value
                    } else if key == "现在"{
                        divination.now =  value
                    } else if key == "障碍"{
                        divination.obstacle =  value
                    } else if key == "未来"{
                        divination.future =  value
                    } else if key == "对策"{
                        divination.countermeasure =  value
                    }else if key == "幸运项目"{
                        divination.luckyThing =  value
                    }
                }
            }
            
            divinations.append(divination)
            
        }
        
        return divinations
        
    }
}

