//
//  PerfilViewController.swift
//  Dhamir
//
//  Created by MAC10 on 27/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit
import UTIKit


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
    var imageStr:Data?
    
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
            if imagenID != nil {
                let ruta = "http://localhost:6060/api/user/get-img-users/" + imagenID!
                self.obtenerImagen(ruta: ruta, token: self.token) {
                    
                    self.imagePerfil.setImage(self.imagenRecibida, for: .normal)
                }
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
    //------------------------------------------------------------------------------
    func subirImagen(ruta: String, datos: Data, token: String, completed: @escaping () -> () ) {
        let url:URL = URL(string: ruta)!
        let boundary = generateBoundaryString()
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        
        var body = Data()
        let data = datos // Imagen
        let mimetype = UTI(filenameExtension: "jpeg")!.mimeTypes
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"imageFile\"; filename=\"NewFile.png\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
            // Catch any exception here
    
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.addValue(token, forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { (data,response,error) in
            if (error == nil) {
                print(response!)
                print(data! )
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
    //-------------------------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagenSeleccionada = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePerfil.setImage(imagenSeleccionada, for: .normal)
        imageStr = UIImageJPEGRepresentation(imagenSeleccionada, 0.9)
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
            //let data = ["imageFile": imageStr]
            if imageStr != nil {
                subirImagen(ruta: ruta, datos: imageStr!, token: token) {
                    print("imagenSubida")
                }
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
        txtNombre.borderStyle = UITextBorderStyle.none
        // ------------------------------------------------
        rutaUsuario = "http://localhost:6060/api/user/\(usuario[0].data.id)"
        obtenerUsuario(ruta: rutaUsuario, token: token) {
            let imagenID = self.usuarioI?.data.imagen
            if imagenID != nil {
                let ruta = "http://localhost:6060/api/user/get-img-users/" + imagenID!
                self.obtenerImagen(ruta: ruta, token: self.token) {
                    
                    self.imagePerfil.setImage(self.imagenRecibida, for: .normal)
                }
            }
        }
        txtNombre.text? = usuario[0].data.name
        txtEmail.text? = usuario[0].data.email
        txtCelular.text? = "\(usuario[0].data.cel)"
        btnCancelar.isHidden = true
        txtCelular.isEnabled = false
        txtEmail.isEnabled = false
        txtNombre.isEnabled = false
        
    }
    
    @IBAction func salirTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    /*
    /// Create request
    ///
    /// - parameter userid:   The userid to be passed to web service
    /// - parameter password: The password to be passed to web service
    /// - parameter email:    The email address to be passed to web service
    ///
    /// - returns:            The `URLRequest` that was created
    
    func createRequest(userid: String, password: String, email: String) throws -> URLRequest {
        let parameters = [
            "user_id"  : userid,
            "email"    : email,
            "password" : password]  // build your dictionary however appropriate
        
        let boundary = generateBoundaryString()
        
        let url = URL(string: "https://example.com/imageupload.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let path1 = Bundle.main.path(forResource: "image1", ofType: "png")!
        request.httpBody = try createBody(with: parameters, filePathKey: "file", paths: [path1], boundary: boundary)
        
        return request
    }
    
    /// Create body of the `multipart/form-data` request
    ///
    /// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
    /// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// - parameter paths:        The optional array of file paths of the files to be uploaded
    /// - parameter boundary:     The `multipart/form-data` boundary
    ///
    /// - returns:                The `Data` of the body of the request
    
    private func createBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String) throws -> Data {
        var body = Data()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        for path in paths {
            let url = URL(fileURLWithPath: path)
            let filename = url.lastPathComponent
            let data = try Data(contentsOf: url)
            let mimetype = UTI(filenameExtension: "jpeg")!.mimeTypes
            
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
            body.append("Content-Type: \(mimetype)\r\n\r\n")
            body.append(data)
            body.append("\r\n")
        }
        
        body.append("--\(boundary)--\r\n")
        return body
    }
    */
    /// Create boundary string for multipart/form-data request
    ///
    /// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires `import MobileCoreServices`.
    ///
    /// - parameter path:         The path of the file for which we are going to determine the mime type.
    ///
    /// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.
    /*
    private func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(UTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, UTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
    
        return "application/octet-stream"
    }
    */
    
    

}
