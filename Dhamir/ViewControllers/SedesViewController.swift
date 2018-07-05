//
//  CarpetasViewController.swift
//  Dhamir
//
//  Created by MAC10 on 27/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class SedesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    var carpetas = ["Mina PPP", "Constructora", "Depositorio SAC"]
    var nombre_sede = UITextField()
    var descripcion_sede = UITextField()
    var lista_sedes:Sedes?
    var usuario:[Result] = []
    var nuevaSede:SedeN?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btn_sede: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        if usuario[0].data.tipo_user != "alto" {
            btn_sede.isHidden = true
        }
        let ruta = "http://35.237.186.173/api/sedes/"
        obtenerSedes(ruta: ruta, token: usuario[0].token) {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if lista_sedes != nil {
            return lista_sedes!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "sede")
        cell.textLabel?.text = lista_sedes?.data[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sede_seleccionada = lista_sedes?.data[indexPath.row]
//        print(sede_seleccionada!)
        performSegue(withIdentifier: "navSegue", sender: sede_seleccionada!)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sedes"
    }
    
    @IBAction func nuevaCarpetaTapped(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Nueva sede", message: "Nombre y Descripcion:", preferredStyle: .alert)
        alerta.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Nombre..."
            self.nombre_sede = textField
        })
        alerta.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Descripcion..."
            self.descripcion_sede = textField
        })
        let okAccion = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let ruta1 = "http://35.237.186.173/api/sedes/"
            let datos = ["name":self.nombre_sede.text!, "description":self.descripcion_sede.text!]
            self.crearSede(ruta: ruta1, token: self.usuario[0].token, datos: datos) {
                print("crearSede Passed")
                let ruta = "http://35.237.186.173/api/sedes/"
                self.obtenerSedes(ruta: ruta, token: self.usuario[0].token) {
                    self.tableView.reloadData()
                }
            }
        })
        let cancelAccion = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alerta.addAction(okAccion)
        alerta.addAction(cancelAccion)
        self.present(alerta, animated: true, completion: nil)
    }
    
    //--------------------------------------------------------------------
    func obtenerSedes(ruta: String, token: String, completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do {
                    self.lista_sedes = try JSONDecoder().decode(Sedes.self, from: data!)
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
    //--------------------------------------------------------------------
    func crearSede(ruta: String, token: String, datos:[String:Any], completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        let name = datos["name"] as! String
        let descript = datos["description"] as! String
        let postDataString = "name=\(name)&description=\(descript)"
        let postData:NSData = postDataString.data(using: String.Encoding.utf8)! as NSData
      
            request.httpBody = postData as Data
            print("Primer do catch")
      
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.nuevaSede = try JSONDecoder().decode(SedeN.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print(error)
                }
            } else {
                print(error!)
            }
        }.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination.childViewControllers[0] as! CarpetasViewController
        siguienteVC.sede = sender as? DataS
        siguienteVC.usuario = usuario as [Result]
    }
 

}
