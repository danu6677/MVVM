//
//  FilmsTableViewController.swift
//  GiftedTask
//
//  Created by zone on 8/21/21.
//

import UIKit

class FilmsTableViewController: UITableViewController {
    
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
    var viewModel = FilmsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        self.fetchData()
        tableView.register(UINib(nibName: Constants.CARD_VIEW_CELL, bundle: nil), forCellReuseIdentifier: Constants.CARD_VIEW)
        NotificationCenter.default.addObserver(self, selector: #selector(offline(notification:)), name: .NetworkDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(online(notification:)), name: .NetworkConnected, object: nil)
    }
    
    func fetchData(_ network_changed:Bool? = false) {
        viewModel.fetchFilms (completion:{[weak self] (result) in
            switch result {
            case .success():
                //Reload the table
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.view.isUserInteractionEnabled =  true
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                    self?.view.isUserInteractionEnabled =  true
                    self?.showAlert(title: Constants.ALERT_TITLE, message: error.localizedDescription)
                }
            }
        },network_changed!)
    }
    
    private func configureView() {
        //UIView Related
         tableView.tableFooterView = UIView()
         self.title = "Films"
         self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26)]
         //Setup the activity indicator
         spinner.backgroundColor = UIColor(white: 0, alpha: 0.2) // make bg darker for greater contrast
         tableView.addSubview(spinner)
         spinner.frame = view.frame // center it
         let transform: CGAffineTransform = CGAffineTransform(scaleX: 2.5, y: 2.5)
         spinner.transform = transform
         spinner.startAnimating()
         self.view.isUserInteractionEnabled =  false
     
    }
    
    @objc private func online(notification: Notification) {
           print("Online")
        DispatchQueue.main.async {
            if !self.spinner.isAnimating {
                self.spinner.startAnimating()
                self.fetchData(true)
            }
        }
    }
    
    @objc private func offline(notification: Notification) {
           print("offline")
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return viewModel.films.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CARD_VIEW, for: indexPath) as! CardVwTableViewCell
        cell.separator(hide: true)
        
        configureCell(cell: cell, film: viewModel.films[indexPath.row])
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 159
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected_movie = viewModel.films[indexPath.row]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilmDetailedVC") as! FilmDetailsTableViewController
        vc.film =  selected_movie
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


extension FilmsTableViewController {
    
    func configureCell(cell:CardVwTableViewCell,film:Film) {
      
        cell.nameLbl.text = film.title
        if let image_data = film.image_data {
           cell.imageVw?.image = UIImage(data: image_data)
        }
    }
}
