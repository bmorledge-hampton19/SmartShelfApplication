//
//  ViewController.swift
//  SmartShelfApplication
//
//  Created by Ian J Busik on 4/25/18.
//  Copyright © 2018 Ian J Busik. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
    
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var barcodeValue : Int = 0
    var foodItem : [[String : Any?]]?
    @IBOutlet weak var newFoodName: UITextField!
    
    @IBOutlet weak var foodInputBarcodeIDLabel: UILabel!
    func setFoodInputBarcodeIDLabel (text: String) {
        foodInputBarcodeIDLabel.text = text
    }
    
    @IBOutlet weak var foodNameForGivenBarcode: UILabel!
    func setFoodNameForGivenBarcode (text: String) {
        foodNameForGivenBarcode.text = text
    }
    
    @IBOutlet weak var barcodeText: UILabel!
    
    func updateBarcodeValue(value:Int) {
        barcodeValue = value
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
        image.delegate = (self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        
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
    
    @IBAction func addToDB(_ sender: UIButton) {
        
        let group = DispatchGroup()
        group.enter()
        
        print("attempting to add...")
        
        let name : String = newFoodName.text!
        print ("Name: \(name) BID: \(barcodeValue)")
        
        let parameters = ["Name": name, "BarcodeID" : String(barcodeValue)]
        
        var request:URLRequest = URLRequest(url: URL(string: "http://smartshelfphp-env.us-east-1.elasticbeanstalk.com/AddFoodItem.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        print("A bunch of values have been stored.")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                print("This first error triggered.")
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let data = data else {
                print("Some sort of data error happened.")
                return
            }
            
            do {
                
                print("Finished.")
                print("Data was:")
                let errorData:NSString = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
                print(errorData)
                
            }
            
            group.leave()
            
        })
        
        task.resume()
        
        group.notify(queue: .main) {
            // Go to the appropriate view.
            self.performSegue(withIdentifier: "nameInputToShelf", sender: nil)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if newFoodName != nil {
            newFoodName.delegate = self
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    
}


