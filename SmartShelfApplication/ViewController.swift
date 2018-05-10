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
    
    @IBOutlet weak var mylibrary: UIButton!
    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var barcode: UIImageView!
    
    @IBOutlet weak var rectangle: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var Barcodescanner: UIImageView!
    
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


