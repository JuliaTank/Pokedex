//
//  ViewController.swift
//  Pokedex
//
//  Created by Julia Tankiewicz on 09/03/2022.
//

import UIKit
//controller for main view with list of pokemons
class ViewController: UIViewController,UITableViewDataSource ,UIScrollViewDelegate, UITableViewDelegate{
    
    private let pokemonService = PokeService()
    @IBOutlet weak var pokemonTable: UITableView!
    var pokemons = [Pokemon]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = pokemonTable.dequeueReusableCell(withIdentifier: "tableViewCell") as! TableViewCell
        let cellPokemon = pokemons[indexPath.row]
        tableViewCell.name?.text = cellPokemon.name
        tableViewCell.pokemonImg.image = cellPokemon.image
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let indexPath = self.pokemonTable.indexPathForSelectedRow!
            let detailView = segue.destination as? DetailsViewController
            let selectedPokemon = pokemons[indexPath.row]
            detailView!.pokemon = selectedPokemon
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonTable.dataSource = self
        pokemonTable.delegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonService.fetchPokemons(pagination: false){ result in
            switch result {
            case .success(let fetchedPokemons as [Pokemon]):
                self.pokemons.append(contentsOf: fetchedPokemons)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {//small delay so that all data fetches
                    self.pokemonTable.reloadData()
                }
            case.failure(let error):
                print("ViewController/viewDidLayoutSubviews: error while trying to fetch first pokemons\(error.localizedDescription)")
                break
            case .success(_):
                print("")//happens when other calls(for each pokemon) are being completed
            }
            
        }
    }
    private func createSpinner()->UIView{
        let footer = UIView(frame: CGRect(x:0,y:0,width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        spinner.color = .darkGray
        footer.addSubview(spinner)
        return footer
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > pokemonTable.contentSize.height - 600{
            //user scrolled all way down, fetch more pokemons
            guard !pokemonService.isInPaginationState else{
                //already trying to fetch more pokemons
                return
            }
            self.pokemonTable.tableFooterView = createSpinner()
            pokemonService.fetchPokemons(pagination: true){ [weak self] result in
                DispatchQueue.main.async {
                    self?.pokemonTable.tableFooterView = nil
                }
                switch result {
                case .success(let fetchedPokemons as [Pokemon]):
                    self?.pokemons.append(contentsOf: fetchedPokemons)
                    DispatchQueue.main.async {
                        self?.pokemonTable.reloadData()
                    }
                case .failure(let error):
                    print("ViewController/scrollViewDidScroll: Error while trying to fetch new pokemons when scrolled down\(error.localizedDescription)")
                case .success(_):
                    print("")
                }
                
            }
        }
    }

}



