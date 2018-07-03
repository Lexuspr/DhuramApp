//
//  ViewController.swift
//  Dhamir
//
//  Created by MAC10 on 20/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var users:[Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func iniciarSesionTapped(_ sender: UIButton) {
        let url = "http://localhost:6060/api/user/signin"
        let usuario = txtUsuario.text!
        let contrasena = txtPassword.text!
        let datos = ["email": usuario, "password": contrasena] as Dictionary<String, Any>
        print("Antes de funcion validar")
        validarUsuario(ruta: url, datos: datos) {
            print("Yoh")
            if self.users.count != 0 {
                print("Hay usuarios")
                print(self.users.count)
                let alertaEx = UIAlertController(title: "Exito!!!!", message: "Te logeaste correctamente", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    self.performSegue(withIdentifier: "logeadoSegue", sender: self.users)
                })
                alertaEx.addAction(okAction)
                self.present(alertaEx, animated: true, completion: nil)
            } else {
                print("Usuario o password incorrecto")
                print(self.users.count)
                let alertaRe = UIAlertController(title: "Error", message: "Usuario o password incorrecto / no existe", preferredStyle: .alert)
                let reAction = UIAlertAction(title: "Reintentar", style: .default, handler: nil)
                alertaRe.addAction(reAction)
                
                let registrarseAction = UIAlertAction(title: "Registrarse", style: .default, handler: {(action) in
                    self.performSegue(withIdentifier: "registrarseSegue", sender: nil)
                })
                alertaRe.addAction(registrarseAction)
                self.present(alertaRe, animated: true, completion: nil)
            }
        }
        print("saliendo funcion validar")
    }
    
    @IBAction func registrarTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "registrarseSegue", sender: nil)
    }
    
    
    
    func validarUsuario(ruta:String, datos:[String:Any], completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        print("Entro funcion validar")
        let params = datos
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
            print("Primer do catch")
        } catch {
            // Catch any exception here
        }
        print("saliendo primer do catch")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print("antes del segundo do catch")
        session.dataTask(with: request) { (data,response,error) in
            if (data != nil) {
                do {
                    //let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print("entro segundo catch")
                    self.users = [try JSONDecoder().decode(Result.self, from: data!)]
                    print("Si se valido")
                    DispatchQueue.main.async {
                        completed()
                    }
                    //completed()
                    print("saliendo segundo do catch")
                } catch {
                    /*print("Aqui comienza el error catch################")
                    print(error)*/
                    print("Entro al catch error :v")
                    DispatchQueue.main.async {
                        completed()
                    }
                }
                print("salio segundo do catch")
            }
        }.resume()
        print("task resumido")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logeadoSegue" {
            let menuPrincipalVC = segue.destination.childViewControllers[1] as! ListUsuariosViewController
            menuPrincipalVC.usuario = sender as! [Result]
            let perfilVC = segue.destination.childViewControllers[0] as! PerfilViewController
            perfilVC.usuario = sender as! [Result]
            let sedesVC = segue.destination.childViewControllers[2] as! SedesViewController
            sedesVC.usuario = sender as! [Result]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtPassword.text = ""
        users.removeAll()
    }
    
}

