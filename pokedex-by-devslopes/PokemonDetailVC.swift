//
//  PokemonDetailVC.swift
//  pokedex-by-devslopes
//
//  Created by Felipe Soares on 24/03/16.
//  Copyright © 2016 Felipe Soares. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    
    @IBOutlet weak var nameLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = pokemon.name
        
    }


}
