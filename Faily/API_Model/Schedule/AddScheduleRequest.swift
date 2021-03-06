//
//  AddScheduleRequest.swift
//  Faily
//
//  Created by 구본의 on 2021/10/23.
//

import Foundation

struct AddScheduleRequest: Encodable {
    var calendar_category: String
    var calendar_name: String
    var calendar_place: String
    var calendar_memo: String
    var calendar_start_time: String
    var calendar_end_time: String
}
