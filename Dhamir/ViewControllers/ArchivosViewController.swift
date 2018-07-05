//
//  ArchivosViewController.swift
//  Dhamir
//
//  Created by MAC10 on 4/07/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class ArchivosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var carpeta:DataC?
    var usuario:[Result] = []
    var lista_archivos:Archivo?
    var archivos_carpeta:[DataA] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        let ruta = "http://35.237.186.173/api/files/"
        let token = usuario[0].token
        obtenerArchivos(ruta: ruta, token: token) {
            for archivo in self.lista_archivos!.data{
                if archivo.carpeta != nil {
                    print("Archivo:")
                    print(archivo.carpeta!)
                    print("Carpeta:")
                    print(self.carpeta!.id)
                    if archivo.carpeta! == self.carpeta!.id {
                        self.archivos_carpeta.append(archivo)
                        print(archivo)
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        print(archivos_carpeta)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !archivos_carpeta.isEmpty {
            return archivos_carpeta.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return carpeta!.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "file")
        cell.textLabel?.text = archivos_carpeta[indexPath.row].name
        return cell
    }
    //------------------------------------------------------------------------
    func obtenerArchivos(ruta:String, token:String, completed: @escaping ()->() ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do {
                    self.lista_archivos = try JSONDecoder().decode(Archivo.self, from: data!)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let archivo_elegido:DataA = archivos_carpeta[indexPath.row]
        performSegue(withIdentifier: "verArchivoSegue", sender: archivo_elegido)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! VerFilesViewController
        siguienteVC.archivo = sender as! DataA
    }
 

}
