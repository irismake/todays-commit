import SwiftUI

extension Color {
  static let lv_0 = Color(hex: "#EBEDF0")
  static let lv_1 = Color(hex: "#9BE9A8")
  static let lv_2 = Color(hex: "#41C464")
  static let lv_3 = Color(hex: "#31A14E")
  static let lv_4 = Color(hex: "#206E39")
}

extension Color {
  init(hex: String) {
    let scanner = Scanner(string: hex)
    _ = scanner.scanString("#")
        
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)
        
    let r = Double((rgb >> 16) & 0xff) / 255.0
    let g = Double((rgb >> 8) & 0xff) / 255.0
    let b = Double(rgb & 0xff) / 255.0
        
    self.init(red: r, green: g, blue: b)
  }
}
