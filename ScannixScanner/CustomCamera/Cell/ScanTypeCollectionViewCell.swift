//
//  ScanTypeCollectionViewCell.swift
//  DocScanner
//
//  Created by LogicGo Mac on 16/02/24.
//

import UIKit

class ScanTypeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    
    //MARK: - Declaration
    static let identifier = "ScanTypeCollectionViewCell"
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }
    
    //MARK: - Set Up Func
    func setUp() {
        self.mainView.backgroundColor = .clear
        self.typeLabel.setUpLabel(titleText: "", textColor: .white, textFont: FontConsant().regular(size: 13))
    }
    
    func setUpData(type: String) {
        self.typeLabel.text = type
    }
}
