//
//  NuevaTareaViewController.swift
//  ListaTareasCD
//
//  Created by mac16 on 11/05/22.
//

import UIKit
import CoreData

class NuevaTareaViewController: UIViewController, UITextFieldDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var textoTarea: UITextField!
    @IBOutlet weak var imagenTarea: UIImageView!
    @IBOutlet weak var fechaTareaPicker: UIDatePicker!
    
    // MARK: - Conexion a la BD o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //Habilitar escritura al crear nueva tarea
        textoTarea.delegate = self
        textoTarea.becomeFirstResponder()
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
    
    @IBAction func guardarTarea(_ sender: UIBarButtonItem) {
        // MARK: - Validar que no hay una cadena vacia
        if let tituloTarea = textoTarea.text, !tituloTarea.isEmpty{
            let fechaTarea = fechaTareaPicker.date
            
            //Crear un nuevo objeto tarea
            let nuevoElemento = Tarea(context: self.contexto)
            
            nuevoElemento.titulo = tituloTarea
            nuevoElemento.fecha = fechaTarea
            nuevoElemento.imagen = imagenTarea.image?.pngData()
            
            do {
                try contexto.save()
                print("Datos guardados en coredata")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            //Regresar a la pantalla anterior
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("Datos necesarios")
            textoTarea.placeholder = "No puede dejar vacio este campo"
        }
    }
    
}

extension NuevaTareaViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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

