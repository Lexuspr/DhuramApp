//
//  CarpetasViewController.swift
//  Dhamir
//
//  Created by MAC10 on 4/07/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class CarpetasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var sede:DataS?
    var usuario:[Result] = []
    var lista_carpetas:Carpeta?
    var carpetas_sede:[DataC] = []
    var nombre_carpeta = UITextField()
    var descripcion_carpeta = UITextField()
    var nueva_carpeta:CarpetaN?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate  = self
        // Do any additional setup after loading the view.
        let ruta = "http://35.237.186.173/api/carpetas"
        let token = usuario[0].token
        obtenerCarpetas(ruta: ruta, token: token) {
            for carpeta in self.lista_carpetas!.data{
                if carpeta.sedes.id == self.sede!.id {
                    self.carpetas_sede.append(carpeta)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sede?.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "carpeta")
        cell.textLabel?.text = carpetas_sede[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carpetas_sede.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carpeta_seleccionada = carpetas_sede[indexPath.row]
        //        print(sede_seleccionada!)
        performSegue(withIdentifier: "archivoSegue", sender: carpeta_seleccionada)
    }
    
    //-----------------------------------------------------------------------------
    func obtenerCarpetas(ruta:String, token:String, completed: @escaping ()->()) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do {
                    self.lista_carpetas = try JSONDecoder().decode(Carpeta.self, from: data!)
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
    //-------------------------------------------------------------------------
    
    func crearCarpeta(ruta: String, token: String, datos:[String:Any], completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        let name = datos["name"] as! String
        let descript = datos["description"] as! String
        let fecha = datos["fecha"] as! String
        let sede = datos["sedes"] as! String
        let postDataString = "name=\(name)&description=\(descript)&fecha=\(fecha)&sedes=\(sede)"
        let postData:NSData = postDataString.data(using: String.Encoding.utf8)! as NSData
        
        request.httpBody = postData as Data
//        print("Primer do catch")
        
        request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-type")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                do {
                    self.nueva_carpeta = try JSONDecoder().decode(CarpetaN.self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    let alerta = UIAlertController(title: "ERROR", message: "Pon un nombre diferente baka!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Reintentar", style: .default, handler: nil)
                    alerta.addAction(okAction)
                    self.present(alerta, animated: true, completion: nil)
                    print(error)
                }
            } else {
                print(error!)
            }
            }.resume()
    }
    
    //-------------------------------------------------------------------------
    @IBAction func nuevaCarpetaTapped(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Nueva carpeta", message: "Nombre y Descripcion:", preferredStyle: .alert)
        alerta.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Nombre..."
            self.nombre_carpeta = textField
        })
        alerta.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Descripcion..."
            self.descripcion_carpeta = textField
        })
        let okAccion = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            let ruta1 = "http://35.237.186.173/api/carpetas/"
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM.dd.yyyy"
            let result = formatter.string(from: date)
            let datos = ["name":self.nombre_carpeta.text!, "description":self.descripcion_carpeta.text!, "fecha": result, "sedes": self.sede!.id]
            self.crearCarpeta(ruta: ruta1, token: self.usuario[0].token, datos: datos) {
                print("crearSede Passed")
                let ruta = "http://35.237.186.173/api/carpetas"
                let token = self.usuario[0].token
                self.obtenerCarpetas(ruta: ruta, token: token) {
                    self.carpetas_sede.removeAll()
                    for carpeta in self.lista_carpetas!.data{
                        if carpeta.sedes.id == self.sede!.id {
                            self.carpetas_sede.append(carpeta)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        })
        let cancelAccion = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alerta.addAction(okAccion)
        alerta.addAction(cancelAccion)
        self.present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func atrasTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let siguienteVC = segue.destination as! ArchivosViewController
        siguienteVC.carpeta = sender as? DataC
        siguienteVC.usuario = usuario as [Result]
    }
 

}
