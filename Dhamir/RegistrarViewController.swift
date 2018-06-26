//
//  RegistrarViewController.swift
//  Dhamir
//
//  Created by MAC10 on 26/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class RegistrarViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDNI: UITextField!
    @IBOutlet weak var txtCelular: UITextField!
    @IBOutlet weak var btnContinuar: UIButton!
    
    var datosUsuario:Dictionary<String, Any> = [:]
    var estado1 = false
    var estado2 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnContinuar.isHidden = true
        txtDNI.delegate = self
        txtCelular.delegate = self
        print("vista cargada")
        if !datosUsuario.isEmpty {
            txtNombre.text! = datosUsuario["name"] as! String
            txtDNI.text! = datosUsuario["dni"] as! String
            txtCelular.text! = datosUsuario["cel"] as! String
            btnContinuar.isHidden = false
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func continuarTapped(_ sender: UIButton) {
        datosUsuario = ["name":txtNombre.text!, "dni":txtDNI.text!, "cel":txtCelular.text!]
        print(datosUsuario)
        performSegue(withIdentifier: "registrarseNextSegue", sender: datosUsuario)
    }
    @IBAction func cancelarTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "cancelarRegistroSegue", sender: nil)
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Find out what the text field will be after adding the current edit
        
        if textField == txtDNI {
            let textDNI = (txtDNI.text! as NSString).replacingCharacters(in: range, with: string)
            if let intValD = Int(textDNI) {
                if textDNI.count == 8 {
                    estado1 = true
                    print("DNI: \(estado1)")
                }
                else {
                    estado1 = false
                }
            }
            
        } else if textField == txtCelular {
            let textCelular = (txtCelular.text! as NSString).replacingCharacters(in: range, with: string)
            if let intValC = Int(textCelular) {
                if textCelular.count == 9 {
                    estado2 = true
                    print("Cel: \(estado2)")
                } else {
                    estado2 = false
                }
            }
        }
        print("estados: DNI: \(estado1) y CEL: \(estado2)")
        if estado1 && estado2 {
            // Text field converted to an In
                btnContinuar.isHidden = false
        } else {
            // Text field is not an Int
                btnContinuar.isHidden = true
        }
        
        // Return true so the text field will be changed
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registrarseNextSegue" {
            let siguienteVC = segue.destination as! RegistrarFinalViewController
            siguienteVC.datosUsuario = sender as! Dictionary<String,Any>
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
