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
  
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var height: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = pokemon.name
        pokemonImage.image = pokemon.image
        descriptionLabel.text = pokemon.description
        height.text = "\(pokemon.height ?? 0)"
        weight.text = "\(pokemon.weight ?? 0)"
        type.text = pokemon.type
        id.text = "\(pokemon.id ?? 0)"
        
    }
}

