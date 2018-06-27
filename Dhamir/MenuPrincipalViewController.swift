//
//  MenuPrincipalViewController.swift
//  Dhamir
//
//  Created by MAC10 on 25/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class MenuPrincipalViewController: UIViewController {
    
    var lista_usuarios:[Usuarios] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "http://localhost:6060/api/user/"
        print("antes de listar")
        listarUsuarios(ruta: url) {
            print("hey")
            print(self.lista_usuarios)
            print("cantidad")
            print(self.lista_usuarios[0].count)
            for usuario in self.lista_usuarios[0].data {
                print(usuario.name)
            }
            
        }
        print("luego de listar")
        // Do any additional setup after loading the view.
    }
    @IBAction func atrasTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    func listarUsuarios(ruta:String, completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YjMyODgyZjVhZGJjYWM4YmE1NGM1NDAiLCJuYW1lIjoiSmVzdXMiLCJlbWFpbCI6ImxleHVzcHJAaG90bWFpbC5jb20iLCJpYXQiOjE1MzAxMTc4MjYsImV4cCI6MTUzMDIwNDIyNn0.rlEYwPhPLvG9dmU117qLBSGZ0bDyL51BYiysZcrRWYE"
//        let session = URLSession.shared
//        request.httpMethod = "GET"
//        request.addValue("application/json", forHTTPHeaderField: "Content-type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        print("cabecera lista")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("hola")
            if error == nil{
                do {
                    self.lista_usuarios = [try JSONDecoder().decode(Usuarios.self, from: data!)]
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
            } else {
                print("error")
                DispatchQueue.main.async {
                    completed()
                }
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
