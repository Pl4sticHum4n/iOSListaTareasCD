//
//  ViewController.swift
//  ListaTareasCD
//
//  Created by mac16 on 11/05/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tablaTareas: UITableView!
    
    // MARK: - Conexion a la BD o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listaTareas=[Tarea]()
    var tareaEnviar: Tarea?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegados
        tablaTareas.delegate = self
        tablaTareas.dataSource = self
        
        //Leer info de la base de datos
        leerTareas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leerTareas()
    }
    
    func leerTareas(){
        let solicitud: NSFetchRequest<Tarea> = Tarea.fetchRequest()
        do {
            //Guardar en el arreglo los datos de la entidad tarea
            listaTareas = try contexto.fetch(solicitud)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        tablaTareas.reloadData()
    }

    @IBAction func agregarTareaBtn(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "agregarTarea", sender: self)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaTareas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tablaTareas.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = listaTareas[indexPath.row].titulo
        let formatter1 = DateFormatter()
        formatter1.locale = Locale(identifier: "es_MX")
        formatter1.dateStyle = .full
        print(formatter1.string(from: listaTareas[indexPath.row].fecha!))
        //celda.detailTextLabel?.text = "\(listaTareas[indexPath.row].fecha ?? Date())"
        celda.detailTextLabel?.text = formatter1.string(from: listaTareas[indexPath.row].fecha!)
        celda.imageView?.image = UIImage(data: listaTareas[indexPath.row].imagen!)
        celda.imageView?.layer.cornerRadius = 15
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tareaEnviar = listaTareas[indexPath.row]
        performSegue(withIdentifier: "editarTarea", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editarTarea"{
            let objetoDestino = segue.destination as! EditartareaViewController
            objetoDestino.recibirTarea = tareaEnviar
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Borrar") { (_, _, _) in
            self.contexto.delete(self.listaTareas[indexPath.row])
            self.listaTareas.remove(at: indexPath.row)
            
            do {
                try self.contexto.save()
                print("Datos guardados en coredata")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            self.tablaTareas.reloadData()
        }
        accionEliminar.image = UIImage(systemName: "trash.fill")
        accionEliminar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
}
