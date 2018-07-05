//
//  VerFilesViewController.swift
//  Dhamir
//
//  Created by MAC10 on 5/07/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class VerFilesViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    var archivo:DataA?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var pdfDoc = archivo!.file as Data
//        webView.loadRequest(<#T##request: URLRequest##URLRequest#>)
        print(archivo?.file!)
        // Do any additional setup after loading the view.
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
