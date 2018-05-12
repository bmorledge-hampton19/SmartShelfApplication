//
//  ViewController.swift
//  SmartShelfApplication
//
//  Created by Ian J Busik on 4/25/18.
//  Copyright © 2018 Ian J Busik. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var barcodeValue : Int = 0
    
    @IBOutlet weak var barcodeText: UILabel!
    
    @IBOutlet weak var sampleText: UILabel!
    @IBAction func updateSample(_ sender: UIButton) {
        sampleText.text = String(barcodeValue)
    }
    
    func updateBarcodeValue(value:Int) {
        barcodeValue = value
        barcodeText.text = String(value)
    }
    
    @IBOutlet weak var mylibrary: UIButton!
    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var barcode: UIImageView!
    
    @IBOutlet weak var rectangle: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var Barcodescanner: UIImageView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : ViewController = self
        
        if let destinationViewController = segue.destination as? QRScannerController {
            destinationViewController.parentVC = vc
        }
        
        else if let destinationViewController = segue.destination as? ViewController {
            destinationViewController.barcodeValue = self.barcodeValue
        }
        
    }
    
    
    @IBAction func goToSampleView(_ sender: UIButton) {
        performSegue(withIdentifier: "sampleSegue", sender: nil)
    }
    
    func goToSampleView2() {
        performSegue(withIdentifier: "sampleSegue", sender: nil)
    }
    
    @IBAction func myimage2(_ sender: UIButton) {
        print("myimageview")
        let image = UIImagePickerController()
        image.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true)
        {
            
        }

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            myImageView.image = image
        }
        else
        {
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    
}


