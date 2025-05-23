//
//  View+Extension.swift
//  ScannixScanner
//
//  Created by apple on 23/05/25.
//

import UIKit

var scanImageArray = [UIImage]()
let blueColor = UIColor.init(rgb: 0x23A2FF)
let scanBlueColor = UIColor.init(rgb: 0x2C78D4)

//MARK: - View Extension
extension UIView {
    
    func setBorderToView(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, backgroundColor: UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
    }
}

//MARK: - Color Extension
extension UIColor {
    
    // Convert Color Values UInt to RGB
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK: - Label Extension
extension UILabel {
    
    func setUpLabel(titleText: String, textColor: UIColor, textFont: UIFont) {
        self.text = titleText
        self.textColor = textColor
        self.font = textFont
    }
}

//MARK: - Button Extension
extension UIButton {
    
    func setUpButtonWithBorder(buttonText: String, textColor: UIColor, textFont: UIFont, backgroundColor: UIColor, cornerRadius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.setTitle(buttonText, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.titleLabel?.font = textFont
        self.setTitleColor(textColor, for: .normal)
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}

//MARK: - Font Constant
struct FontConsant {
    func light(size: CGFloat) -> UIFont {
        return UIFont(name: "Campton-Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Campton-Book", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Campton-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    func semibold(size: CGFloat) -> UIFont {
        return UIFont(name: "Campton-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Campton-Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
