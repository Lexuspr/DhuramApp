//
//  ListUsuariosViewController.swift
//  Dhamir
//
//  Created by MAC10 on 27/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class ListUsuariosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var usuario:[Result] = []
    var lista_usuarios:[Usuarios] = []
    var token:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        token = usuario[0].token
//        print("didload")
//        print(lista_usuarios)
        // Do any additional setup after loading the view.
        let url = "http://35.237.186.173/api/user/"
        listarUsuarios(ruta: url, token: token){
//            print("did load listar")
            self.tableView.reloadData()
        }
//        print(lista_usuarios)
//        tableView.reloadData()
//            self.tableView.reloadData()
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lista_usuarios.count != 0{
            return lista_usuarios[0].count!
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if lista_usuarios.count != 0 {
            cell.textLabel?.text = lista_usuarios[0].data[indexPath.row].name
            //        print("celdas \(indexPath.row)")
            return cell
        } else {
            return cell
        }
    }
    
    func listarUsuarios(ruta:String, token:String, completed: @escaping () -> ()) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        
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
//                    print(self.lista_usuarios[0])
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
    
    override func viewWillAppear(_ animated: Bool) {
        let url = "http://35.237.186.173/api/user/"
        token = usuario[0].token
        print("apunto will appear")
        listarUsuarios(ruta: url, token: token){
            print("Will appear")
            //print(self.lista_usuarios)
        }
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
