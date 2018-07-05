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
    var usuario:[Result] = []
    var archivo_recibido:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var rutaArchivo = archivo?.file!
        var token = usuario[0].token
        var ruta = "http://35.237.186.173/api/files/get-img-files/"
        obtenerArchivo(ruta: ruta, token: token, nameFile: rutaArchivo!) {
            self.webView.load(self.archivo_recibido!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL() as URL)
        }
        //var pdfDoc = archivo!.file as Data
//        webView.loadRequest(<#T##request: URLRequest##URLRequest#>)
//        print(archivo?.file!)
        // Do any additional setup after loading the view.
    }

    func obtenerArchivo(ruta:String, token:String, nameFile:String, completed: @escaping ()->() ) {
        let ruta_final = ruta + nameFile
        let url:URL = URL(string: ruta_final)!
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do {
                    self.archivo_recibido = data!
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
            } else {
                print("error")
            }
            }.resume()
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
