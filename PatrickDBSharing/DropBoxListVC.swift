//
//  DropBoxListVC.swift
//  PatrickDBSharing
//
//  Created by indianic on 13/04/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit
import SwiftyDropbox

class DropBoxListVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var fileName :String?
    var fileUrl:URL?

    ///store dropbox entity's namek
    var dropboxData = [String]()
    
    ///store dropbox entity's path
    var dropboxDataPath = [String]()
    
    var searchActive : Bool = false
    
    var filtered:[String] = []
    var filteredDataPath = [String]()
    

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.showDropboxData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /// show dropbox data in tableview
    func showDropboxData() {
        
        // check user is authorizedClient or not
        // if yes then hit dropbox api and save data in dropboxData  and dropboxDataPath variables.
        if let client = DropboxClientsManager.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                print("*** List folder ***")
                print(response)
                
                if let result = response {
                    print("Folder contents:")
                    
                    for entry in result.entries {
                        let entryName  = entry.name as NSString
                        let pathExtension = entryName.pathExtension
                        
                        // check pathExtension of entity's and append data
                        if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
                            self.dropboxDataPath.append(entry.pathLower!)
                            self.dropboxData.append(entry.name)
                        }
                    }
                    //reload tableview
                    self.tableView.reloadData()
                } else {
                    //show error message
                    print("error")
                }
            }
        }
    }


}


extension DropBoxListVC
{
    //MARK: UITableViewDataSource and UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.searchActive {
            return self.filtered.count
        }
        return dropboxData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropBoxListingCell") as! DropBoxListingCell
        var currentfile = ""
        
        if self.searchActive {
            currentfile = filtered[indexPath.row]
        } else {
            // get current file name
            currentfile = dropboxData[indexPath.row]
        }
        
        // get current file extension
        let currentfileExtension = currentfile as NSString
        
        let pathExtension = currentfileExtension.pathExtension
        
        //set filename
        cell.fileName.text = currentfile
        
        // check if current file is pdf show pdf icon in cell
        // else if current file is doc show doc icon in cell
        //else show folder icon in cell
        if pathExtension == "pdf" {
            cell.listImageView.image = UIImage(named: "pdf_icon")
        } else if pathExtension == "doc" {
            cell.listImageView.image = UIImage(named: "doc_icon")
        } else if pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
            cell.listImageView.image = UIImage(named: "Image_icon")
        } else {
            cell.listImageView.image = UIImage(named: "folder_icon")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var currentFile = ""
        var path = ""
        
        if self.searchActive {
            currentFile = filtered[indexPath.row]
            path = filteredDataPath[indexPath.row]
        } else {
            // get current file name
            currentFile = dropboxData[indexPath.row]
            // get currentfile path
            path = dropboxDataPath[indexPath.row]
        }
        
        // get current file as NSString to check extension
        let filename = currentFile as NSString
        
        // if fileExtenstion is folder
        // add folder's data in dropboxData and dropboxDataPath variable and delete old data.
        // else download the file from dropbox
        if filename.pathExtension == "" {
            if let client = DropboxClientsManager.authorizedClient {
                
                // List folder
                client.files.listFolder(path: path).response { response, error in
                    // delet old data
                    self.dropboxData.removeAll()
                    self.dropboxDataPath.removeAll()
                    
                    print("*** List folder ***")
                    
                    if let result = response {
                        print(result)
                        print("Folder contents:")
                        for entry in result.entries {
                            
                            let str  = entry.name as NSString
                            let pathExtension = str.pathExtension
                            
                            // check pathExtension of entity's and append data
                            if pathExtension == "pdf" ||  pathExtension == "doc" || pathExtension == "" || pathExtension == "png" ||  pathExtension == "jpg" || pathExtension == "jpeg" {
                                
                                self.dropboxDataPath.append(entry.pathLower!)
                                self.dropboxData.append(entry.name)
                            }
                        }
                        //reload tableview
                        self.tableView.reloadData()
                    } else {
                        
                        //TODO: show message here to user
                    }
                }
            }
        } else {
            
            if let client = DropboxClientsManager.authorizedClient {
                // Download a file
                
                // create  unique destination for file.
                let destination : (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
                    let fileManager = FileManager.default
                    let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    
                    //          let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                    //
                    //          let documentsDirectory: AnyObject = paths[0] as AnyObject
                    let dataPath = directoryURL.appendingPathComponent("Resumes")
                    
                    if !FileManager.default.fileExists(atPath: dataPath.path) {
                        do {
                            // create Resumes folder
                            try fileManager.createDirectory(atPath: dataPath.path, withIntermediateDirectories: false, attributes: nil)
                        } catch let error as NSError {
                            print(error.localizedDescription);
                        }
                    }
                    
                    let pathComponent = directoryURL.appendingPathComponent("Resumes")
                    let path = pathComponent.appendingPathComponent(filename as String)
                    print(path)
                    
                    // if file is already exist then delete it first
                    if FileManager.default.fileExists(atPath: path.path) {
                        do {
                            try FileManager.default.removeItem(atPath: path.path)
                        }
                        catch let error as NSError {
                            print("Ooops! Something went wrong: \(error)")
                        }
                    }
                    return path
                }
                
                print(destination)
                
                // download file here in destination.
                client.files.download(path: path, destination: destination).response { response, error in
                    if let (metadata, url) = response {
                        print("*** Download file ***")
                        
                        print(url.pathExtension)
                        print(url)
                        
                        self.fileUrl = url
                        self.fileName = metadata.name
                        
                        let data = try? Data(contentsOf: url)
                        print("Downloaded file name: \(metadata.name)")
                        print("Downloaded file url: \(url)")
                        print("Downloaded file data: \(data)")
                        self.performSegue(withIdentifier: "FileViewerVC", sender: nil)
                        
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                        let dropboxVC = storyBoard.instantiateViewController(withIdentifier: "FileViewerVC") as! FileViewerVC
//                        self.navigationController?.pushViewController(dropboxVC, animated: true)
        
                        
                    } else {
                        print(error?.description)
                        
                        // Utilities.showAlertForMessage(message: (error?.description)!)
                    }
                }
            }
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "FileViewerVC" {
            if let destVC = segue.destination as?  FileViewerVC {
                destVC.fileUrl = self.fileUrl
            }
        }
    }
    
    
}
