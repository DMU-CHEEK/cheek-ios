//
//  Utils.swift
//  CHEEK
//
//  Created by 김태은 on 10/13/24.
//

import Foundation
import SwiftUI

class Utils {
    // 키보드 숨기기
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // 한국어 숫자 포맷
    func formatKoreanNumber(number: Int64) -> String {
        if number >= 100000000 {
            let divided = Double(number) / 100000000
            return String(format: "%.1f억", divided)
        } else if number >= 10000 {
            let divided = Double(number) / 10000
            return String(format: "%.1f만", divided)
        } else if number >= 1000 {
            let divided = Double(number) / 1000
            return String(format: "%.1f천", divided)
        } else {
            return "\(number)"
        }
    }
    
    // 현재 기준 지난 날짜 계산 (미국 시간대 -> 한국 시간대)
    func timeAgo(dateString: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        formatter.timeZone = TimeZone(identifier: "America/New_York")
        
        guard let date = formatter.date(from: dateString) else { return nil }
        
        let kstTimeZone = TimeZone(identifier: "Asia/Seoul")
        
        let koreanDate = date.addingTimeInterval(TimeInterval(kstTimeZone!.secondsFromGMT(for: date) - TimeZone.current.secondsFromGMT(for: date)))
        
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: koreanDate, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)일 전"
        } else if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
