//
//  CarpetasViewController.swift
//  Dhamir
//
//  Created by MAC10 on 27/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class CarpetasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var carpetas = ["Mina PPP", "Constructora", "Depositorio SAC"]
    var nombre_carpeta = UITextField()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carpetas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "carpeta")
        cell.textLabel?.text = carpetas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Mis carpetas"
    }
    
    @IBAction func nuevaCarpetaTapped(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Nueva carpeta", message: "Nombre:", preferredStyle: .alert)
        alerta.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Mi carpeta"
            self.nombre_carpeta = textField
        })
        let okAccion = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.carpetas.append(self.nombre_carpeta.text!)
            self.tableView.reloadData()
        })
        let cancelAccion = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        alerta.addAction(okAccion)
        alerta.addAction(cancelAccion)
        self.present(alerta, animated: true, completion: nil)
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
