//
//  CustomCameraViewController.swift
//  ScannixScanner
//
//  Created by apple on 23/05/25.
//

import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flashImageView: UIImageView!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var scanUpperView: UIView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var mainImgView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var mainFlashView: UIView!
    @IBOutlet weak var flashOnImgView: UIImageView!
    @IBOutlet weak var flashOffImgView: UIImageView!
    @IBOutlet weak var flashAutoImgView: UIImageView!
    @IBOutlet weak var flashlightImgView: UIImageView!
    @IBOutlet weak var flashOnLabel: UILabel!
    @IBOutlet weak var flashOffLabel: UILabel!
    @IBOutlet weak var flashAutoLabel: UILabel!
    @IBOutlet weak var flashlightLabel: UILabel!
    @IBOutlet weak var flashCloseButton: UIButton!
    
    
    
    //MARK: - Declaration
    var typeArray = ["Book", "Document", "ID Card", "Passport", "QR Scanner"]
    var scanType: ScanType?
    var idScanSide = IdScanSide.one
    var backFacingCamera: AVCaptureDevice?
    var frontFacingCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice!
    var stillImageOutput: AVCapturePhotoOutput!
    var stillImage = UIImage()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureSession = AVCaptureSession()
    let metadataOutput = AVCaptureMetadataOutput()
    var previousSelection: ScanType?
    var cancelSelection = ScanType.doc
    var flashType = FlashType.auto
    var isFromFolder = false
    var isBookEdit = false
    var isDocEdit = false
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.setUp()
        })
//        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//            self.setUpCamera()
//        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.captureButton.isUserInteractionEnabled = true
        if (scanImageArray.count) > 0 {
            self.imgView.image = scanImageArray[scanImageArray.count-1]
            self.countLabel.text = "\(scanImageArray.count)"
            self.mainImgView.isHidden = false
            self.saveButton.isHidden = false
        }
        if self.scanType == .idCard {
//            if isFrontDone {
//                self.sideLabel.text = TextMessage.backSide
//            } else {
//                self.sideLabel.text = TextMessage.frontSide
//            }
        } else if self.scanType == .passport {
            self.switchSelection(.doc)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Set Up Func
    func setUp() {
        self.view.backgroundColor = .clear
        self.headerView.backgroundColor = .black.withAlphaComponent(0.6)
        self.footerView.backgroundColor = .black
        self.scanUpperView.setBorderToView(cornerRadius: 1, borderWidth: 0, borderColor: .clear, backgroundColor: scanBlueColor)
        self.listCollectionView.backgroundColor = .clear
        self.listCollectionView.register(UINib(nibName: ScanTypeCollectionViewCell.identifier, bundle: Bundle(for: ScanTypeCollectionViewCell.self)), forCellWithReuseIdentifier: ScanTypeCollectionViewCell.identifier)
        let floawLayout = UPCarouselFlowLayout()
        floawLayout.itemSize = CGSize(width: 100, height: self.listCollectionView.frame.size.height)
        floawLayout.scrollDirection = .horizontal
        floawLayout.sideItemScale = 1.0
        floawLayout.sideItemAlpha = 1.0
        floawLayout.spacingMode = .fixed(spacing: 5.0)
        self.listCollectionView.collectionViewLayout = floawLayout
        self.listCollectionView.delegate = self
        self.listCollectionView.dataSource = self
        DispatchQueue.main.async {
            self.switchSelection(self.scanType ?? .doc)
        }
//        self.sideLabel.isHidden = true
//        self.sideLabel.setUpLabel(titleText: TextMessage.frontSide, textColor: whiteColor, textFont: AppFont.size18.sFontCamptonDisplayMedium)
//        self.sideLabel.dropShadow(opacity: 1.0, offset: CGSize(width: 0, height: 5.0), radius: 5.0, color: .black.withAlphaComponent(0.7))
        self.mainImgView.setBorderToView(cornerRadius: 7, borderWidth: 0.7, borderColor: .white, backgroundColor: .clear)
        self.imgView.setBorderToView(cornerRadius: 5, borderWidth: 0, borderColor: .clear, backgroundColor: .clear)
        self.countView.setBorderToView(cornerRadius: self.countView.frame.height / 2, borderWidth: 0, borderColor: .clear, backgroundColor: scanBlueColor)
        self.countLabel.setUpLabel(titleText: "0", textColor: .white, textFont: FontConsant().regular(size: 8))
//        self.mainImgView.isHidden = true
//        self.saveButton.isHidden = true
//        scanImageArray.removeAll()
//        bookImageData.removeAll()
//        bookResultImageArray.removeAll()
//        bookSelectedIndex = 0
        self.mainFlashView.transform = CGAffineTransform(translationX: 0, y: -210)
        self.mainFlashView.backgroundColor = .black.withAlphaComponent(0.9)
        self.flashCloseButton.setUpButtonWithBorder(buttonText: "Close", textColor: .white, textFont: FontConsant().regular(size: 16), backgroundColor: .clear, cornerRadius: 5, borderColor: .white, borderWidth: 1)
        self.flashOnImgView.tintColor = .white
        self.flashOffImgView.tintColor = .white
        self.flashAutoImgView.tintColor = blueColor
        self.flashlightImgView.tintColor = .white
        self.flashOnLabel.textColor = .white
        self.flashOffLabel.textColor = .white
        self.flashAutoLabel.textColor = blueColor
        self.flashlightLabel.textColor = .white
        
        self.flashOnLabel.setUpLabel(titleText: "Flash\n[ON]", textColor: .white, textFont: FontConsant().bold(size: 15))
        self.flashOffLabel.setUpLabel(titleText: "Flash\n[OFF]", textColor: .white, textFont: FontConsant().medium(size: 15))
        self.flashAutoLabel.setUpLabel(titleText: "Auto\nFlash", textColor: .white, textFont: FontConsant().medium(size: 15))
        self.flashlightLabel.setUpLabel(titleText: "Flash\nLight", textColor: .white, textFont: FontConsant().medium(size: 15))
//        self.flashImageView.image = UIImage(named: "ic_flash_auto")
//        self.docDisplay.append(NewDocumentsList(id: self.getMaxId(), folderId: self.isFromFolder ? self.folderData?.id ?? 0 : 0, editImage: [UIImage](), name: "", dateTime: Date.getCurrentDate(), modifyDate: Date.getCurrentDate(), isSelect: false, protect: ""))
//        self.bookScanView.isHidden = true
    }
    
    //MARK: - Button Action
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func flashButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.mainFlashView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    @IBAction func autoFlashButtonAction(_ sender: UIButton) {
        let flashlightManager = FlashlightManager.shared
        self.flashOnImgView.tintColor = .white
        self.flashOnLabel.textColor = .white
        self.flashOffImgView.tintColor = .white
        self.flashOffLabel.textColor = .white
        self.flashAutoImgView.tintColor = .white
        self.flashAutoLabel.textColor = .white
        self.flashlightImgView.tintColor = .white
        self.flashlightLabel.textColor = .white
        switch sender.tag {
        case 1:
            self.flashOnImgView.tintColor = blueColor
            self.flashOnLabel.textColor = blueColor
            self.flashType = .on
            self.flashImageView.image = UIImage(named: "ic_flash_on")
            flashlightManager.offFlashlight()
        case 2:
            self.flashOffImgView.tintColor = blueColor
            self.flashOffLabel.textColor = blueColor
            self.flashType = .off
            self.flashImageView.image = UIImage(named: "ic_flash_off")
            flashlightManager.offFlashlight()
        case 3:
            self.flashAutoImgView.tintColor = blueColor
            self.flashAutoLabel.textColor = blueColor
            self.flashType = .auto
            self.flashImageView.image = UIImage(named: "ic_flash_auto")
            flashlightManager.offFlashlight()
        case 4:
            self.flashlightImgView.tintColor = blueColor
            self.flashlightLabel.textColor = blueColor
            self.flashImageView.image = UIImage(named: "ic_flashlight")
            flashlightManager.onFlashlight()
        default: break
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.mainFlashView.transform = CGAffineTransform(translationX: 0, y: -210)
        })
    }
    
    @IBAction func flashCloseButtonAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.mainFlashView.transform = CGAffineTransform(translationX: 0, y: -210)
        })
    }
    
    @IBAction func imageButtonAction(_ sender: Any) {
    }
    
    @IBAction func captureButtonAction(_ sender: Any) {
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
    }
    
    //MARK: - Other Func
    func doneScrollingCollection(_ index: Int) {
        self.previousSelection = self.scanType
        print("previous = \(self.previousSelection ?? .doc)")
        print("\(index) - \(self.typeArray[index])")
//        self.sideLabel.isHidden = true
//        self.bookScanView.isHidden = true
        switch self.typeArray[index] {
            
        case "ID Card":
            self.scanType = .idCard
//            if scanImageArray.count > 0 {
//                self.discardAlert()
//            } else {
//                let nav = AppStoryboard.PopUp.instance.instantiateViewController(withIdentifier: VCIdentifier.idCardViewController) as! IdCardViewController
//                nav.delegate = self
//                nav.providesPresentationContextTransitionStyle = true
//                nav.definesPresentationContext = true
//                nav.modalPresentationStyle = .custom
//                nav.modalTransitionStyle = .crossDissolve
//                self.present(nav, animated: true)
//            }
            
        case "Document":
            self.scanType = .doc
//            if scanImageArray.count > 0 {
//                self.discardAlert()
//            }
            
        case "Passport":
            self.scanType = .passport
//            if scanImageArray.count > 0 {
//                self.discardAlert()
//            } else {
//                let nav = AppStoryboard.PopUp.instance.instantiateViewController(withIdentifier: VCIdentifier.passportPopUpViewController) as! PassportPopUpViewController
//                nav.delegate = self
//                nav.providesPresentationContextTransitionStyle = true
//                nav.definesPresentationContext = true
//                nav.modalPresentationStyle = .custom
//                nav.modalTransitionStyle = .crossDissolve
//                self.present(nav, animated: true)
//            }
            
        case "QR Scanner":
            self.scanType = .qr
//            if scanImageArray.count > 0 {
//                self.discardAlert()
//            }
            
        case "Book":
            self.scanType = .book
//            if scanImageArray.count > 0 {
//                self.discardAlert()
//            } else {
//                let nav = AppStoryboard.PopUp.instance.instantiateViewController(withIdentifier: VCIdentifier.passportPopUpViewController) as! PassportPopUpViewController
//                nav.delegate = self
//                nav.isBook = true
//                nav.providesPresentationContextTransitionStyle = true
//                nav.definesPresentationContext = true
//                nav.modalPresentationStyle = .custom
//                nav.modalTransitionStyle = .crossDissolve
//                self.present(nav, animated: true)
//            }
            
        default: break
        }
    }
    
    func switchSelection(_ scanType: ScanType) {
        switch scanType {
        case .idCard:
//            self.bookScanView.isHidden = true
            if let index = self.typeArray.firstIndex(of: "ID Card") {
                let indexPath = IndexPath(row: index, section: 0)
                self.listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        case .doc:
//            self.bookScanView.isHidden = true
            if let index = self.typeArray.firstIndex(of: "Document") {
                let indexPath = IndexPath(row: index, section: 0)
                self.listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        case .passport:
//            self.bookScanView.isHidden = true
            if let index = self.typeArray.firstIndex(of: "Passport") {
                let indexPath = IndexPath(row: index, section: 0)
                self.listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        case .qr:
//            self.bookScanView.isHidden = true
            if let index = self.typeArray.firstIndex(of: "QR Scanner") {
                let indexPath = IndexPath(row: index, section: 0)
                self.listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        case .book:
//            self.bookScanView.isHidden = false
            if let index = self.typeArray.firstIndex(of: "Book") {
                let indexPath = IndexPath(row: index, section: 0)
                self.listCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
}

//MARK: - Collection View Set Up
extension CustomCameraViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.typeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScanTypeCollectionViewCell.identifier, for: indexPath) as! ScanTypeCollectionViewCell
        cell.setUpData(type: self.typeArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.doneScrollingCollection(indexPath.row)
    }
}
