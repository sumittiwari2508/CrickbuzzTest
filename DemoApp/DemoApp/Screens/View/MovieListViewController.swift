//
//  MovieListViewController.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 24/10/24.
//

import UIKit

class MovieListViewController: UIViewController {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var selectedItem: String?
    private var moviesViewModel = MoviesViewModel()
    private var filteredMovies: [Movie] = []
    var isSelected = String()
    
    var tableView: UITableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Movie List", comment: "")
        filteredMovies = moviesViewModel.filterMovies(byYear: selectedItem ?? "")
        moviesViewModel.fetchMovies()
        if isSelected == "Year" {
            filteredMovies = moviesViewModel.filterMovies(byYear: selectedItem ?? "")
        }else if isSelected == "Genre" {
            filteredMovies = moviesViewModel.filterMovies(byGenre: selectedItem ?? "")
        }else if isSelected == "Directors" {
            filteredMovies = moviesViewModel.filterMovies(byDirector: selectedItem ?? "")
        } else if isSelected == "Actors" {
            filteredMovies = moviesViewModel.filterMovies(byActor: selectedItem ?? "")
        }else{
            filteredMovies = moviesViewModel.allMovies()
        }
        
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(UINib(nibName: "MovieDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "movie")
        if filteredMovies.count == 0 {
            
            let alert = UIAlertController(title: "Alert", message: "No Movie Found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { action in
                
                self.navigationController?.popViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}


extension MovieListViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.moviesTableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieDetailsTableViewCell
        cell.selectionStyle = .none
        let movie = filteredMovies[indexPath.row]
        cell.movieTitle.text = movie.title
        cell.movieYear.text = movie.year
        cell.movieLanguages.text = movie.language
        
        if let url = URL(string: movie.poster) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.movieThumbnail.image = image
                    }
                }
            }.resume()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = filteredMovies[indexPath.row]
        
        let bundle = Bundle(for: MovieListViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        
        let detailsVC: MovieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        
        detailsVC.movie = selectedMovie
        navigationController?.pushViewController(detailsVC, animated: true)
        
    }
}

