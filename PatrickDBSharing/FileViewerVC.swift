//
//  FileViewerVC.swift
//  PatrickDBSharing
//
//  Created by indianic on 13/04/17.
//  Copyright © 2017 indianic. All rights reserved.
//

import UIKit

class FileViewerVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var fileUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
  
        if let url = self.fileUrl {
            
            let requestObj = URLRequest(url: url);
            webView.loadRequest(requestObj);
        }
    
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
