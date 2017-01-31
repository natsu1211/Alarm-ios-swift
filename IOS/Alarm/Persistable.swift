//
//  Persistable.swift
//  Alarm-ios-swift
//
//  Created by natsu1211 on 2017/01/25.
//  Copyright © 2017年 LongGames. All rights reserved.
//

import Foundation

protocol Persistable{
    var ud: UserDefaults {get}
    var persistKey : String {get}
    func persist()
    func unpersist()
}
