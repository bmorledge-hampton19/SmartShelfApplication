//
//  ViewController.swift
//  SmartShelfApplication
//
//  Created by Ian J Busik on 4/25/18.
//  Copyright © 2018 Ian J Busik. All rights reserved.
//

import UIKit
import AVFoundation

// This class handles most of the view controllers in our project.
class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
    
    // This stuff is important for the barcode scanner
    let session         : AVCaptureSession = AVCaptureSession()
    var previewLayer    : AVCaptureVideoPreviewLayer!
    var highlightView   : UIView = UIView()
    var barcodeValue : Int = 0
    var foodItem : [[String : Any?]]?
    @IBOutlet weak var newFoodName: UITextField!
    @IBOutlet weak var foodInputBarcodeIDLabel: UILabel!
    @IBOutlet weak var Barcodescanner: UIImageView!
    
    // Sets a text value for the barcode ID that was scanned but not recognized
    func setFoodInputBarcodeIDLabel (text: String) {
        foodInputBarcodeIDLabel.text = text
    }
    
    // Sets a text value for the name associated with the recognized barcode ID
    @IBOutlet weak var foodNameForGivenBarcode: UILabel!
    func setFoodNameForGivenBarcode (text: String) {
        foodNameForGivenBarcode.text = text
    }
    // I'm not sure if this actually does anything, but I'm too scared to change it.
    @IBOutlet weak var barcodeText: UILabel!
    
    // Changes the barcode value currently stored in the main view controller
    func updateBarcodeValue(value:Int) {
        barcodeValue = value
    }
    
    // Involved in selecting a picture for the profile
    @IBOutlet weak var mylibrary: UIButton!
    var video = AVCaptureVideoPreviewLayer()
    @IBOutlet weak var barcode: UIImageView!
    @IBOutlet weak var rectangle: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc : ViewController = self
        
        // Passes the main view controller to the QRScannerController so it can modify barcode values.
        if let destinationViewController = segue.destination as? QRScannerController {
            destinationViewController.parentVC = vc
        }
        
        // Passes the stored barcode value between instances of the main view controller
        else if let destinationViewController = segue.destination as? ViewController {
            destinationViewController.barcodeValue = self.barcodeValue
        }
        
    }
    
    
    // These functions call segues!  I think they might be obselete now.
    @IBAction func goToSampleView(_ sender: UIButton) {
        performSegue(withIdentifier: "sampleSegue", sender: nil)
    }
    func goToSampleView2() {
        performSegue(withIdentifier: "sampleSegue", sender: nil)
    }
    
    // The following two functions let you choose a profile picture!  It was mostly copy-pasted from some Swift 2 code, and it might not work anymore.  We haven't tested it since we moved to Swift 3.0...
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
    
    // Add information about a newly scanned food item.
    @IBAction func addToDB(_ sender: UIButton) {
        
        // Setup the dispatch group to delay tasks until after the Database has been updated.
        let group = DispatchGroup()
        group.enter()
        
        print("attempting to add...")
        
        // Prepare the JSON to be used in the query.
        let name : String = newFoodName.text!
        print ("Name: \(name) BID: \(barcodeValue)")
        let parameters = ["Name": name, "BarcodeID" : String(barcodeValue)]
        
        // Prepare for the query...
        var request:URLRequest = URLRequest(url: URL(string: "http://smartshelfphp-env.us-east-1.elasticbeanstalk.com/AddFoodItem.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Do the query...(Hopefully)
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        print("A bunch of values have been stored.")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            // Hopefully none of these errors trigger.
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
                
                // Export the result of the PHP call, just in case an issue needs to be diagnosed.
                print("Finished.")
                print("Data was:")
                let errorData:NSString = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
                print(errorData)
                
            }
            
            group.leave()
            
        })
        
        task.resume()
        
        // We're done now!  Go to the shelf.
        group.notify(queue: .main) {
            // Go to the appropriate view.
            self.performSegue(withIdentifier: "nameInputToShelf", sender: nil)
        }
        
    }
    
    // Make sure it is possible to hide the keyboard by pressing enter.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Make sure it is posisble to hide the keyboard when accessing this text field.
        if newFoodName != nil {
            newFoodName.delegate = self
        }
        
    }
    
    // This is probably important.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    
}


