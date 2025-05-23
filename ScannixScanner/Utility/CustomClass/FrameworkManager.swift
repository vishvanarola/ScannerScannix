//
//  FrameworkManager.swift
//  ScannixScanner
//
//  Created by apple on 23/05/25.
//

import UIKit

public class FrameworkManager {
    
    public static let shared = FrameworkManager()
    
    private init() {}
    
    public func showCustomCamera(from viewController: UIViewController, defaultSelection: ScanType = .doc) {
        let cameraVC = CustomCameraViewController(nibName: "CustomCameraViewController", bundle: Bundle(for: CustomCameraViewController.self))
        cameraVC.scanType = defaultSelection
        viewController.navigationController?.pushViewController(cameraVC, animated: true)
    }
    
}
