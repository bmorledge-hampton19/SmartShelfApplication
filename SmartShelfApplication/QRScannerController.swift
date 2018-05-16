//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

// This view controller only handles the barcode scanner.
class QRScannerController: UIViewController {

    // Components of the view controller.
    @IBOutlet var messageLabel2: UILabel!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var backView: UIStackView!
    
    // These are important for capturing the barcode.
    var captureSession = AVCaptureSession()
    var parentVC : ViewController?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    // These are important for passing and receiving information about the barcode to and from the database.
    var barcodeValue: Int = 1
    var foodItem : [[String:Any?]]?
    var foodFound : Bool?
    var barcodeFound : Bool = false
    
    // This isn't being used... But maybe we'll use it later!
    func changeText(newText: String) {
        messageLabel2.text = newText
    }
    
    // These are functions for the two buttons at the top left corner of the application.  The first one takes you back to the previous page, and the second one runs a check on either the default barcode value or the one most recently scanned.
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func test(_ sender: UIButton) {
        checkBarcode()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        if let destinationViewController = segue.destination as? ViewController {
            
            // Pre-load the view controller so we can alter the text fields in it.
            destinationViewController.loadViewIfNeeded()
            
            // If the barcode was not recognized, pass the barcode value over to the main view controller and display it in the next page.
            if !foodFound! {
                destinationViewController.barcodeValue = self.barcodeValue
                destinationViewController.setFoodInputBarcodeIDLabel(text: "Barcode ID: \(self.barcodeValue)")
            }
                
            // If the barcode was recognized, pass information about it back to the main view controller and display its name in the next page.
            else if foodFound! {
                destinationViewController.foodItem = self.foodItem
                let foodName : String = foodItem![0]["FoodName"] as! String
                destinationViewController.setFoodNameForGivenBarcode(text: "Food Name: \(foodName)")
            }
            
        }
        
    }
    
    // Segues back to the main view controller
    func goToInputInfoView() {
        performSegue(withIdentifier: "toItemInfoInput", sender: nil)
        print("Segue Activated 1")
    }
    func goToDisplayFoodItemView() {
        performSegue(withIdentifier: "toDisplayFoodItem", sender: nil)
        print("Segue Activated 2")
    }
    
    func checkBarcode() {
        
        // Create the JSON to send to the PHP file
        let parameters = ["BarcodeID": String(barcodeValue)];
        
        print("Beginning Check for the barcode...")
        
        // Important for PHP connection
        var request:URLRequest = URLRequest(url: URL(string: "http://smartshelfphp-env.us-east-1.elasticbeanstalk.com/BarcodeScan.php")!)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let session = URLSession.shared
        
        print("Here goes nothing!")
        
        // Setup the dispatch group to delay tasks until after the Database has been updated.
        let group = DispatchGroup()
        group.enter()
        
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
                print("Trying to do something with the results...")
                
                
                // Create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    print("Here are the results:")
                    print("")
                    
                    // Get the foodFound variable from JSON
                    guard let foodFoundTemp = json["FoodFound"] as? Bool else {
                        print("FoodFound was not correctly cast to a boolean value")
                        return
                    }
                    self.foodFound = foodFoundTemp
                    
                    // Take action depending on whether or not the food item was found.
                    if self.foodFound! {
                        
                        print("A food item was found with the given ID!")
                        print("Preparing to pass over information about the item...")
                        
                        // Get the foodItem from JSON (If it even exists)
                        guard let foodItemTemp = json["FoodItem"] as? [[String: Any]] else {
                            print("Something went wrong unpacking the food item.")
                            return
                        }
                        self.foodItem = foodItemTemp
                        
                    }
                    else if !self.foodFound! {
                        
                        print("No food item found with the given ID")
                        print("Preparing to pass the ID over to the next dialogue...")
                        
                    }
                    
                    group.leave()
                    
                }
                
            } catch let error {
                // If something went wrong, print out the result of the PHP code to diagnose the issue.
                print(error.localizedDescription)
                print("Data error! Data was:")
                let errorData:NSString = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
                print(errorData)
            }
        })
        
        
        task.resume()
        
        // When the query has finished, run this code.
        group.notify(queue: .main) {
            // Go to the appropriate view.
            if self.foodFound! {
                self.goToDisplayFoodItemView()
            }
            else if !self.foodFound! {
                self.goToInputInfoView()
            }
        }
    }
    
    // From here on, this is code we copy pasted to help run our barcode scanner.
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
//            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel2)
        view.bringSubview(toFront: backView)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods

    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel2.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                //launchApp(decodedURL: metadataObj.stringValue!)
                //messageLabel2.text = metadataObj.stringValue
                
                // The first time a barcode is scanned during this instance of this view controller, send it to the database for processing.
                barcodeValue = Int(metadataObj.stringValue!)!
                if (!barcodeFound) {
                    checkBarcode()
                    barcodeFound = true
                }
                
            }
        }
    }
    
}
