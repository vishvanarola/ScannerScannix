//
//  FlashlightManager.swift
//  ScannixScanner
//
//  Created by apple on 23/05/25.
//

import AVFoundation

class FlashlightManager {
    static let shared = FlashlightManager()
    
    private var isFlashlightOn = false
    
    private init() {
        // Initialize and configure AVCaptureDevice
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("No video device found")
            return
        }
        
        do {
            try device.lockForConfiguration()
        } catch {
            print("Error locking device for configuration: \(error.localizedDescription)")
        }
        
        if device.hasTorch {
            if device.isTorchModeSupported(.on) {
                isFlashlightOn = device.torchMode == .on
            } else {
                print("Torch mode is not supported")
            }
        } else {
            print("Device doesn't have a torch")
        }
        
        device.unlockForConfiguration()
    }
    
    func onFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("No video device found")
            return
        }
        
        do {
            try device.lockForConfiguration()
        } catch {
            print("Error locking device for configuration: \(error.localizedDescription)")
        }
        do {
            try device.setTorchModeOn(level: 1.0)
        } catch {
            print("Error enabling torch mode: \(error.localizedDescription)")
        }
    }
    
    func offFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("No video device found")
            return
        }
        
        do {
            try device.lockForConfiguration()
        } catch {
            print("Error locking device for configuration: \(error.localizedDescription)")
        }
        device.torchMode = .off
    }
    
    func toggleFlashlight() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            print("No video device found")
            return
        }
        
        do {
            try device.lockForConfiguration()
        } catch {
            print("Error locking device for configuration: \(error.localizedDescription)")
        }
        
        if device.hasTorch {
            if isFlashlightOn {
                device.torchMode = .off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print("Error enabling torch mode: \(error.localizedDescription)")
                }
            }
            
            isFlashlightOn = !isFlashlightOn
        }
        
        device.unlockForConfiguration()
    }
}
