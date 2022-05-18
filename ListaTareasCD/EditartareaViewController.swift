//
//  EditartareaViewController.swift
//  ListaTareasCD
//
//  Created by mac16 on 11/05/22.
//

import UIKit
import CoreData

class EditartareaViewController: UIViewController {
    var recibirTarea: Tarea?
    @IBOutlet weak var fechaTarea: UIDatePicker!
    @IBOutlet weak var imagenTarea: UIImageView!
    @IBOutlet weak var tituloTarea: UITextField!
    
    // MARK: - Conexion a la BD o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        tituloTarea.text = recibirTarea?.titulo ?? ""
        fechaTarea.date = recibirTarea?.fecha ?? Date()
        imagenTarea.image = UIImage(data: (recibirTarea?.imagen)!)
        // Do any additional setup after loading the view.
        // agregar la gestura a la imagen
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        imagenTarea.addGestureRecognizer(gestureRecognizer)
        imagenTarea.isUserInteractionEnabled = true
    }
    
    @objc func clickImagen(gesture: UITapGestureRecognizer){
        print("Cambiar imagen")
        // crear VC temporal
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    @IBAction func acncelarBtn(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func guardarBtn(_ sender: Any) {
        // Definir què vamos a guardar
        recibirTarea?.titulo = tituloTarea.text
        recibirTarea?.fecha = fechaTarea.date
        recibirTarea?.imagen = imagenTarea.image?.pngData()
        
        do {
            try contexto.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension EditartareaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imagenTarea.image = imagenSeleccionada
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
