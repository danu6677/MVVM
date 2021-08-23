//
//  FilmDetailsTableViewController.swift
//  GiftedTask
//
//  Created by zone on 8/21/21.
//

import UIKit

class FilmDetailsTableViewController: UITableViewController {
    var film: Film?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Film Details"
        tableView.register(UINib(nibName: Constants.DETAILED_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.DETAILED_VIEW)
        tableView.register(UINib(nibName: Constants.CARD_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.CARD_VIEW)
        tableView.estimatedRowHeight = 416
        tableView.rowHeight = UITableView.automaticDimension
    }

    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1 : film?.characters?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CARD_VIEW, for: indexPath) as! CardVwTableViewCell
            
            if let film = self.film {
                configureCharacterCell(cell: cell, film: film, indexPath: indexPath)
            }
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.DETAILED_VIEW, for: indexPath) as! FilmDetailsTableViewCell
            if let film = self.film {
                configureFilmDetailsCell(cell: cell, film: film)
            }
           
            return cell
        }
       
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 1 ? 159 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Characters: \( film?.characters?.count ?? 0)" : ""
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 60 : 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let movie = self.film, let allCharacters = movie.characters {
                let selected_character: Character = allCharacters.toArray()[indexPath.row]
               
                var popUpWindow: PopUpWindow!
                popUpWindow = PopUpWindow(title: selected_character.name ?? "", text: "Birth Year: \(selected_character.birth_year ?? "unknown")", buttontext: "OK", gender: selected_character.gender ?? "male")
                self.present(popUpWindow, animated: true, completion: nil)

            }
        }
    }
}

extension FilmDetailsTableViewController {
    
    fileprivate func configureCharacterCell(cell:CardVwTableViewCell,film:Film,indexPath:IndexPath) {
        cell.separator(hide: true)
        if let movie = self.film, let allCharacters = movie.characters {
            let character: Character = allCharacters.toArray()[indexPath.row]
            cell.nameLbl.text = character.name
            cell.imageView?.image = UIImage(named: character.gender ?? "male")
        }
    }
    
    fileprivate func configureFilmDetailsCell(cell:FilmDetailsTableViewCell,film:Film) {
        cell.titleLbl.text = film.title
        cell.directorNameLbl.text = film.director
        cell.producerNameLbl.text = film.producer
        cell.releaseDataLbl.text = film.release_date
        cell.openingCrawlLbl.text = film.opening_crawl
        if let image_data = film.image_data {
           cell.imageVw?.image = UIImage(data: image_data)
        }
    }
}
