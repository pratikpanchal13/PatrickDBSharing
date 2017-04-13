//
//  ViewController.swift
//  PatrickDBSharing
//
//  Created by indianic on 12/04/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {

    let client = DropboxClientsManager.authorizedClient
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnLoginWithDropBox(_ sender: Any) {

        self.myButtonInControllerPressed()   // For Authorized

        
    }
    
    
    
    @IBAction func btnShareData(_ sender: Any) {
        
        self.uploadToDropbox()          // Share Data on DropBox

        
    }
    
    @IBAction func btnShareImage(_ sender: Any) {
     
        Utility.sharedInstance.takeOrChoosePhoto(self) { (selectedImage) in
            
            print("Image is \(String(describing: selectedImage))")

            var currentTimeStamp = NSDate().timeIntervalSince1970.toString()
            let filename = "\(currentTimeStamp)_img.jpg"
            
            UtilityUserDefault().setUDObject(ObjectToSave: "\(filename)" as AnyObject, KeyToSave: "saveImgName")

            
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filename)
            let image = selectedImage
            print(paths)
            let imageData = UIImageJPEGRepresentation(image!, 0.5)
            fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
            
            
            
            self.uploadToDropbox()          // Share Data on DropBox

            
            
        }
    }
    
    
   
    
    func uploadToDropbox() {
        
        let filename = UtilityUserDefault().getUDObject(KeyToReturnValye: "saveImgName") as! String
        
//        let tmpURL = NSURL(fileURLWithPath: NSTemporaryDirectory())
//        let fileURL = tmpURL.appendingPathComponent("Pratik.jpeg")

        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(filename)
        
        let urlstring: String = imagePAth
        let url = NSURL.fileURL(withPath: urlstring)
        
        if fileManager.fileExists(atPath: imagePAth){

            
        }else{
            print("No Image")
        }
        
        if let client = DropboxClientsManager.authorizedClient {
            client.files.upload(path: "/Pratik11/\(filename)", mode: .overwrite, autorename: true, clientModified: NSDate() as Date, mute: false, input: url).response{ response, error in
                
                if let metadata = response {
                    print("Uploaded file name: \(metadata.name)")
                } else {
                    print(error!)
                }
            }
        }
        
    }
    
    func getDirectoryPath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // For Authorization Check
    func myButtonInControllerPressed() {
        DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })

    }
   
    
}


extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f" as NSString, self) as String
    }
    
    func toString() -> String {
        return String(format: "%.1f",self)
    }
    
    func toInt() -> Int{
        let temp:Int64 = Int64(self)
        return Int(temp)
    }
}
