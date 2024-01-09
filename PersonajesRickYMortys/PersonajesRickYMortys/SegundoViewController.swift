//
//  SegundoViewController.swift
//  PersonajesRickYMortys
//
//  Created by dam2 on 18/12/23.
//

import UIKit

class SegundoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var episodios: UITableView!
    
    var personaje:PersonajeModel?
    
    @IBOutlet weak var imagenDetalle: UIImageView!
    
    @IBOutlet weak var nombreDetalles: UILabel!
    
    
    @IBOutlet weak var especieDetalle: UILabel!
    
    
    @IBOutlet weak var estadoDetalle: UILabel!
    
    @IBOutlet weak var generoDetalle: UILabel!
    
    @IBOutlet weak var origenDetalle: UILabel!
    
    @IBOutlet weak var localizacionDetalle: UILabel!
    
    @IBOutlet weak var alturaCeldas: NSLayoutConstraint!
    
    var urlPersonajes = [String]()
    var capitulosFavoritos = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        episodios.delegate = self
        episodios.dataSource = self
        
        if let personaje = personaje {
            let imageUrl = URL(string: personaje.image)
            
            URLSession.shared.dataTask(with: imageUrl!) { (data, _, _) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.imagenDetalle.image = UIImage(data: data)
                    }
                }
            }.resume()
            nombreDetalles.text = personaje.name
            especieDetalle.text = personaje.species
            estadoDetalle.text = personaje.status
            generoDetalle.text = personaje.gender
            origenDetalle.text = personaje.origin?.name
            localizacionDetalle.text = personaje.location?.name
        }
        
        alturaCeldas.constant =  CGFloat((personaje?.episode.count ?? 0) * 45)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (personaje?.episode.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)

        let capitulo = personaje?.episode[indexPath.row] ?? ""
        celda.textLabel?.text = capitulo

        if capitulosFavoritos.contains(capitulo) {
            // Cambia la apariencia de la celda para indicar que el capítulo está marcado como favorito
            celda.accessoryType = .checkmark
        } else {
            celda.accessoryType = .none
        }

        return celda
    }


    func episodios(_ episodios: UITableView, didSelectItemAt indexPath: IndexPath) {
        // se puede implementar navegacion en la pulsacion de la celda
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "primerView") as! ViewController
        // Pasa el personaje específico seleccionado usando el indexPath
        
        
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func sacarId(_ viewController: ViewController) {
        viewController.personajesId = []
         
    }
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoritosAction = UIContextualAction(style: .normal, title: "Favoritos"){ [ weak self ] (action, view, completedHandler) in
            
            self?.manejarFavoritos(indexPath.row)
            print("Pulsado favoritos")
            completedHandler(true)
            
        }
        favoritosAction.backgroundColor = .blue
        favoritosAction.image = UIImage(systemName: "star")
        
       
        
        return UISwipeActionsConfiguration(actions: [favoritosAction])
    }
    
    func manejarFavoritos(_ indexPath: Int) {
        guard let capitulo = personaje?.episode[indexPath] else { return }

        capitulosFavoritos.append(capitulo)
        print("Capítulo añadido a favoritos: \(capitulo)")

        // Recarga la tabla para actualizar la apariencia de las celdas
        episodios.reloadData()
    }


}



