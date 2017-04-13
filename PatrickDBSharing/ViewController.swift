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

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshDropboxList), name: NSNotification.Name(rawValue: "Dropboxlistrefresh"), object: nil)

        
    }
    
    func refreshDropboxList() {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let dropboxVC = storyBoard.instantiateViewController(withIdentifier: "DropBoxListVC") as! DropBoxListVC
        self.navigationController?.pushViewController(dropboxVC, animated: true)
        
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //----------------------------------------------------
    //MARK: - For Authorization with DropBox
    //----------------------------------------------------
    
    @IBAction func btnLoginWithDropBox(_ sender: Any) {

        self.linkToDropboxClicked()   // For Authorized

        
        // Download to Data
        client?.files.download(path: "/Pratik11")
            .response { response, error in
                if let response = response {
                    let responseMetadata = response.0
                    print(responseMetadata)
                    let fileContents = response.1
                    print(fileContents)
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
    }
    
    
    
    @IBAction func btnShareData(_ sender: Any) {
        
//        self.uploadToDropbox()          // Share Data on DropBox
        // Download a file
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let dropboxVC = storyBoard.instantiateViewController(withIdentifier: "DropBoxListVC") as! DropBoxListVC
        self.navigationController?.pushViewController(dropboxVC, animated: true)
        
        
    }
    
    
    
    //----------------------------------------------------
    //MARK: - For Upload Images to DropBox
    //----------------------------------------------------
    
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
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(filename)
        
        let urlstring: String = imagePAth
        let url = NSURL.fileURL(withPath: urlstring)
        
        if fileManager.fileExists(atPath: imagePAth){

            if let client = DropboxClientsManager.authorizedClient {
                client.files.upload(path: "/Pratik11/\(filename)", mode: .overwrite, autorename: true, clientModified: NSDate() as Date, mute: false, input: url).response{ response, error in
                    
                    if let metadata = response {
                        print("Uploaded file name: \(metadata.name)")
                    } else {
                        print(error!)
                    }
                }
            }

        }else{
            print("No Image")
        }
        
        
    }
    
    func getDirectoryPath() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // For Authorization Check
    func linkToDropboxClicked() {

        if (DropboxClientsManager.authorizedClient == nil) {
            //authorize a user
            DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                          controller: self,
                                                          openURL: { (url: URL) -> Void in
                                                            UIApplication.shared.openURL(url)
            })
        } else {
            print("User is already authorized!")
            self.refreshDropboxList()
        }
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
