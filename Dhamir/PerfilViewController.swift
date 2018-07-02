//
//  PerfilViewController.swift
//  Dhamir
//
//  Created by MAC10 on 27/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imagePerfil: UIButton!
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtCelular: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnModificar: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    var estadoBtnModificar = false
    var usuario:[Result] = []
    var usuarioI:UsuarioU?
    var token:String = ""
    var imagePicker = UIImagePickerController()
    var rutaUsuario = ""
    var imagenRecibida:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = usuario[0].token
        txtNombre.text? = usuario[0].data.name
        imagePicker.delegate = self
        txtCelular.text? = "\(usuario[0].data.cel)"
        btnCancelar.isHidden = true
        txtCelular.isEnabled = false
        txtEmail.text? = usuario[0].data.email
        txtEmail.isEnabled = false
        txtNombre.isEnabled = false
        // Do any additional setup after loading the view.
        rutaUsuario = "http://localhost:6060/api/user/\(usuario[0].data.id)"
        obtenerUsuario(ruta: rutaUsuario, token: token) {
            let imagenID = self.usuarioI?.data.imagen
            
            let ruta = "http://localhost:6060/api/user/get-img-users/" + imagenID!
            self.obtenerImagen(ruta: ruta, token: self.token) {
                
                self.imagePerfil.setImage(self.imagenRecibida, for: .normal)
            }
        }
    }
    
    func actualizarUsuario(ruta:String, datos:[String:Any], token: String, completed: @escaping () -> ()) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        let params = datos
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            // Catch any exception here
            print(error)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data,response,error) in
           print(response!)
            DispatchQueue.main.async {
                completed()
            }
        }.resume()
        
    }
    func subirImagen(ruta: String, datos: [String:Any], token: String, completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        let params = datos
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            // Catch any exception here
            print(error)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data,response,error) in
            if (error == nil) {
                print(response!)
                print("sin error")
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                print("Error subirImagen")
                print(error!)
            }
            
            }.resume()
    }
    
    func obtenerImagen(ruta:String, token:String, completed: @escaping () -> () ) {
        print("obtenerImage ruta: " + ruta)
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                self.imagenRecibida = UIImage(data: data!)
               
                    DispatchQueue.main.async {
                        completed()
                    }
            } else {
                print("error")
            }
            }.resume()
    }
    
    func obtenerUsuario(ruta:String, token:String, completed: @escaping () -> ()){
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil{
                do {
                    self.usuarioI = try JSONDecoder().decode(UsuarioU.self, from: data!)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagenSeleccionada = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePerfil.setImage(imagenSeleccionada, for: .normal)
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func imagenTapped(_ sender: UIButton) {
        let alerta = UIAlertController(title: "Aviso", message: "Escoga la fuente:", preferredStyle: .alert)
        let camaraAction = UIAlertAction(title: "Camera", style: .default, handler: {(action) in
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
            })
        let galeriaAction = UIAlertAction(title: "Galeria", style: .default, handler: {(action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = false
            self.present(self.imagePicker, animated: true, completion: nil)
            })
        alerta.addAction(camaraAction)
        alerta.addAction(galeriaAction)
        self.present(alerta, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func modificarTapped(_ sender: UIButton) {
        if btnModificar.currentTitle == "Guardar" {
            let datos = ["email": txtEmail.text!, "cel": txtCelular.text!, "name": txtNombre.text!] as Dictionary<String, Any>
            let url = "http://localhost:6060/api/user/\(usuario[0].data.id)"
            actualizarUsuario(ruta: url, datos: datos, token: token, completed: {
                let alerta = UIAlertController(title: "Exito", message: "Se actualizaron los datos correctamente", preferredStyle: .alert)
                let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                alerta.addAction(okAccion)
                self.present(alerta, animated: true, completion: nil)
                self.btnModificar.setTitle("Modificar", for: .normal)
                self.btnCancelar.isHidden = true
                self.txtNombre.borderStyle = UITextBorderStyle.none
                self.txtNombre.isEnabled = false
                self.txtCelular.isEnabled = false
                self.txtEmail.isEnabled = false
                })
            
            let ruta = "http://localhost:6060/api/user/upload-img-user/\(usuario[0].data.id)"
            let imageData = UIImageJPEGRepresentation(imagePerfil.currentImage!, 0.9)
            let base64String = imageData?.base64EncodedString()
            let data = ["imageFile": base64String]
            subirImagen(ruta: ruta, datos: data, token: token) {
                print("imagenSubida")
                
            }
        }
        txtNombre.borderStyle = UITextBorderStyle.roundedRect
        btnModificar.setTitle("Guardar", for: .normal)
        btnCancelar.isHidden = false
        txtCelular.isEnabled = true
        txtEmail.isEnabled = true
        txtNombre.isEnabled = true
        
    }
    @IBAction func cancelarTapped(_ sender: UIButton) {
        btnModificar.setTitle("Modificar", for: .normal)
        btnCancelar.isHidden = true
        txtCelular.isEnabled = false
        txtEmail.isEnabled = false
        txtNombre.isEnabled = false
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
