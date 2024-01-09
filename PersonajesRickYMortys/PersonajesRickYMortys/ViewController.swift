//
//  ViewController.swift
//  PersonajesRickYMortys
//
//  Created by dam2 on 18/12/23.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.downloadData()    }
    
    
    var personajes = [PersonajeModel]()
    var personajesId = [Int]()
    
    /**
     Lanza una peticion para obtener un Array de objetos
     */
    func downloadData() {
        let urlString = "https://rickandmortyapi.com/api/character"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            guard let data = data else { return }
            
            let personajes = try? JSONDecoder().decode(Model.self, from: data)
            let personajesObtenidos = personajes?.results
            if personajes != nil {
                self.personajes = personajesObtenidos!
                DispatchQueue.main.async {
                    self.collectionView.reloadData() // Una vez obtenidos los datos tras la peticion, se recarga el collection view con los datos recibidos
                }
            } else {
                print("Se ha producido un error en los datos")
            }
        }.resume()
    }
    
    /**
     Lanza una peticion para obtener un Array de objetos
     */
    /**
     Establece el numero de celdas que contendra el CollectionView
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        personajes.count
    }
    
    /**
     Establece la configuracion de la celda que contendra el CollectionView para cada item
     Para la imagen, es necesario lanzar una peticion a la url para obtener la imagen. Para ello, hay que hacerlo de forma asincrona para evitar que la aplicacion se ralentice.
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Celda", for: indexPath) as! CeldaPersonajesCollectionViewCell
        cell.especiePersonaje.text = personajes[indexPath.item].species
        cell.nombrePersonaje.text = personajes [indexPath.item].name
        let imageUrl = URL(string: personajes[indexPath.item].image)
        
        URLSession.shared.dataTask(with: imageUrl!) { (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.imagenPersonaje.image = UIImage(data: data)
                }
            }
        }.resume()
        return cell
        
    }
    
    /**
     Establece el tamaño de cada celda.
     Se ha configurado teniendo en cuenta el ancho de ViewPort de la pantalla en pixeles
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = collectionView.frame.width
        var celdaWidth = 0
        
        if screenWidth > 700 {
            celdaWidth = Int(screenWidth / 5 - 12)
        } else {
            celdaWidth = Int(screenWidth / 2 - 6)
        }
        
        return CGSize(width: celdaWidth, height: celdaWidth)
    }
    
    /**
     Se ejecuta al pulsar un boton
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // se puede implementar navegacion en la pulsacion de la celda
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "segundoView") as! SegundoViewController
        //Le paso el personaje entero para no pasar todas las propiedades
        vc.personaje = personajes[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

