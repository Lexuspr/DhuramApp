//
//  RegistrarFinalViewController.swift
//  Dhamir
//
//  Created by MAC10 on 26/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class RegistrarFinalViewController: UIViewController {
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var datosUsuario:Dictionary<String, Any> = [:]
    
    var users:[ResultR] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func registrarseTapped(_ sender: UIButton) {
        let usuario = txtUsuario.text!
        let password = txtPassword.text!
        let url = "http://localhost:6060/api/user/signup"
        datosUsuario.updateValue(usuario, forKey: "email")
        datosUsuario.updateValue(password, forKey: "password")
        registrarUsuario(ruta: url, datos: datosUsuario, completed: {
            if self.users.count != 0 {
                let alertaEx = UIAlertController(title: "Exito!!!!", message: "Te registraste correctamente", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    self.performSegue(withIdentifier: "registradoSegue", sender: nil)
                })
                alertaEx.addAction(okAction)
                self.present(alertaEx, animated: true, completion: nil)
            } else {
                let alertaRe = UIAlertController(title: "Error", message: "Algo salio mal", preferredStyle: .alert)
                let reAction = UIAlertAction(title: "Reintentar", style: .default, handler: nil)
                alertaRe.addAction(reAction)
                self.present(alertaRe, animated: true, completion: nil)
            }
        })
        
    }
    @IBAction func atrasTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "retrocederNextSegue", sender: datosUsuario)
    }
    
    func registrarUsuario(ruta:String, datos:[String:Any], completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
       
        let params = datos
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
         
        } catch {
            // Catch any exception here
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) { (data,response,error) in
            if (data != nil) {
                do {
                  
                    self.users = [try JSONDecoder().decode(ResultR.self, from: data!)]
                    print(self.users)
                  
                    DispatchQueue.main.async {
                        completed()
                    }
                  
                } catch {
                    
                    print(error)
                    DispatchQueue.main.async {
                        completed()
                    }
                }
              
            }
            }.resume()
        print("task resumido")
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "retrocederNextSegue" {
            let anteriorVC = segue.destination as! RegistrarViewController
            anteriorVC.datosUsuario = sender as! Dictionary<String, Any>
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
