import SwiftUI

// 헤드라인1
struct Headline1: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 24))
            .foregroundColor(color)
            .fontWeight(bold ? .bold : .regular)
            .lineSpacing(32 - UIFont(name: font, size: 24)!.lineHeight) // 32
            .tracking(-0.02) // -2%
    }
}

// 제목1
struct Title1: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 20))
            .foregroundColor(color)
            .fontWeight(bold ? .semibold : .regular)
            .lineSpacing(28 - UIFont(name: font, size: 20)!.lineHeight) // 28
            .tracking(-0.015) // -1.5%
    }
}

// 내용1
struct Body1: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 16))
            .foregroundColor(color)
            .fontWeight(bold ? .semibold : .regular)
            .lineSpacing(24 - UIFont(name: font, size: 16)!.lineHeight) // 24
            .tracking(0) // 0%
    }
}

// 내용2
struct Body2: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 15))
            .foregroundColor(color)
            .fontWeight(bold ? .semibold : .regular)
            .lineSpacing(22 - UIFont(name: font, size: 15)!.lineHeight) // 22
            .tracking(0.005) // 0.5%
    }
}

// 라벨1
struct Label1: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 16))
            .foregroundColor(color)
            .fontWeight(bold ? .semibold : .regular)
            .lineSpacing(24 - UIFont(name: font, size: 16)!.lineHeight) // 24
            .tracking(0) // 0%
    }
}

// 라벨2
struct Label2: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 14))
            .foregroundColor(color)
            .fontWeight(bold ? .semibold : .regular)
            .lineSpacing(20 - UIFont(name: font, size: 14)!.lineHeight) // 20
            .tracking(0.005) // 0.5%
    }
}

// 설명1
struct Caption1: ViewModifier {
    var font: String
    var color: Color
    var bold: Bool
    
    func body(content: Content) -> some View {
        content
            .font(.custom(font, size: 12))
            .foregroundColor(color)
            .fontWeight(bold ? .semibold : .regular)
            .lineSpacing(16 - UIFont(name: font, size: 12)!.lineHeight) // 16
            .tracking(0.01) // 1%
    }
}

extension View {
    // 헤드라인1
    func headline1(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Headline1(font: font, color: color, bold: bold))
    }
    
    // 제목1
    func title1(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Title1(font: font, color: color, bold: bold))
    }
    
    // 내용1
    func body1(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Body1(font: font, color: color, bold: bold))
    }
    
    // 내용2
    func body2(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Body2(font: font, color: color, bold: bold))
    }
    
    // 라벨1
    func label1(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Label1(font: font, color: color, bold: bold))
    }
    
    // 라벨2
    func label2(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Label2(font: font, color: color, bold: bold))
    }
    
    // 설명1
    func caption1(font: String, color: Color, bold: Bool) -> some View {
        self.modifier(Caption1(font: font, color: color, bold: bold))
    }
}
