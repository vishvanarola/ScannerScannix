//
//  ViewController.swift
//  ExampleUIKit
//
//  Created by apple on 23/05/25.
//

import UIKit
import ScannixScanner

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func navigate(_ sender: Any) {
        FrameworkManager.shared.showCustomCamera(from: self, defaultSelection: .doc)
    }
    
}
