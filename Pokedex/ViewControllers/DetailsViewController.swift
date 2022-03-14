//
//  DetailsViewController.swift
//  Pokedex
//
//  Created by Julia Tankiewicz on 09/03/2022.
//
import UIKit

class DetailsViewController: UIViewController{
    
    var pokemon:Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pokemonImage: UIImageView!
  
    
    @IBOutlet weak var height: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var species: UILabel!
    
    @IBOutlet weak var defense: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBOutlet weak var attack: UILabel!
    
    @IBOutlet weak var baseExperience: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
        pokemonImage.image = pokemon.image
        height.text = "\(pokemon.height ?? 0)"
        weight.text = "\(pokemon.weight ?? 0)"
        id.text = "\(pokemon.id ?? 0)"
        defense.text = "\(pokemon.defense ?? 0)"
        attack.text = "\(pokemon.attack ?? 0)"
        species.text = "\(pokemon.species ?? "")"
        baseExperience.text = "\(pokemon.baseExperience ?? 0)"
    }
}

