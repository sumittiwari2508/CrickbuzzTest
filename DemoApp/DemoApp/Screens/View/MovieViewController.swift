//
//  FlickrViewController.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 17/10/24.
//

import UIKit

class MovieViewController: UIViewController {
    
    @IBOutlet weak var searchController: UISearchBar!
    @IBOutlet weak var movieDatatableView: UITableView!
    
    private var moviesViewModel = MoviesViewModel()
    var filteredItems: [ParentItem] = []
    var isSearching = false
    private var uniqueYearList: [String] = []
    private var uniqueDirectorList: [String] = []
    private var uniqueActorList: [String] = []
    private var uniqueGenreList: [String] = []
    var filteredMovies: [Movie] = []
    var items: [ParentItem] = []
    var movies: [Movie] = []
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("Movie Database", comment: "main grid title")
        searchController.delegate = self
        searchController.isUserInteractionEnabled = true
        movieDatatableView.delegate = self
        movieDatatableView.dataSource = self
        movieDatatableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChildCell")
        movieDatatableView.register(UINib(nibName: "MovieDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "movie")
        movieDatatableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        moviesViewModel.fetchMovies()
        uniqueYearList = moviesViewModel.uniqueYears()
        uniqueDirectorList = moviesViewModel.uniqueDirectors()
        uniqueActorList = moviesViewModel.uniqueActors()
        uniqueGenreList = moviesViewModel.uniqueGenre()
        
        movies = moviesViewModel.allMovies()
        items = [
            ParentItem(title: "Year", isExpanded: false, childItems: uniqueYearList),
            ParentItem(title: "Genre", isExpanded: false, childItems: uniqueGenreList),
            ParentItem(title: "Directors", isExpanded: false, childItems: uniqueDirectorList),
            ParentItem(title: "Actors", isExpanded: false, childItems: uniqueActorList),
            ParentItem(title: "All Movies", isExpanded: false, childItems: [])
        ]
    }
}

// MARK: - TableView delegate and datasource

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearching ? filteredMovies.count : items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !isSearching {
            let currentItems = isSearching ? filteredItems : items
            return currentItems[section].isExpanded ? currentItems[section].childItems.count : 0
        }else{
            return filteredMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSearching {
            let cell = self.movieDatatableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieDetailsTableViewCell
            cell.selectionStyle = .none
            let movie = filteredMovies[indexPath.row]
            cell.configure(with: movie)
            
            return cell
        }else{
            let currentItems = isSearching ? filteredItems : items
            let cell = movieDatatableView.dequeueReusableCell(withIdentifier: "ChildCell", for: indexPath)
            let childItem = currentItems[indexPath.section].childItems[indexPath.row]
            cell.textLabel?.text = childItem
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        movieDatatableView.deselectRow(at: indexPath, animated: true)
        if isSearching {
            let selectedMovie = filteredMovies[indexPath.row]
            
            let bundle = Bundle(for: MovieListViewController.self)
            let storyboard = UIStoryboard(name: "Main", bundle: bundle)
            
            let detailsVC: MovieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
            
            detailsVC.movie = selectedMovie
            navigationController?.pushViewController(detailsVC, animated: true)
        }else{
            
            let bundle = Bundle(for: MovieListViewController.self)
            let storyboard = UIStoryboard(name: "Main", bundle: bundle)
            
            let viewController: MovieListViewController = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
            
            
            let selectedChildItem = items[indexPath.section].childItems[indexPath.row]
            let selectedSection = items[indexPath.section].title
            if selectedSection == "Year" {
                viewController.isSelected = "Year"
            }else if selectedSection == "Genre" {
                viewController.isSelected = "Genre"
            }else if selectedSection == "Directors" {
                viewController.isSelected = "Directors"
            } else if selectedSection == "Actors" {
                viewController.isSelected = "Actors"
            }
            
            viewController.selectedItem = selectedChildItem
            
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! CustomHeaderView
        if !isSearching {
            
            let currentItems = isSearching ? [] : items
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView") as! CustomHeaderView
            headerView.textLabel?.text = currentItems[section].title
            headerView.updateArrow(isExpanded: currentItems[section].isExpanded)
            headerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:))))
            headerView.tag = section
            return headerView
        }else{
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSearching {
            return 100
        }else{
            return 44
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isSearching ? 0 : 40
    }
    
    
    @objc func headerTapped(_ sender: UITapGestureRecognizer) {
        guard let headerView = sender.view as? UITableViewHeaderFooterView else { return }
        let section = headerView.tag
        
        guard section < items.count else { return }
        
        if section == 4{
            let bundle = Bundle(for: MovieListViewController.self)
            let storyboard = UIStoryboard(name: "Main", bundle: bundle)
            
            let viewController: MovieListViewController = storyboard.instantiateViewController(withIdentifier: "MovieListViewController") as! MovieListViewController
            viewController.isSelected = "All Movies"
            
            navigationController?.pushViewController(viewController, animated: true)
        }else{
            
            items[section].isExpanded.toggle()
        }
        if let customHeaderView = headerView as? CustomHeaderView {
            customHeaderView.updateArrow(isExpanded: items[section].isExpanded)
        }
        
        movieDatatableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
// MARK: - UISearchBar delegate

extension MovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredMovies = []
            movieDatatableView.reloadData()
        } else {
            isSearching = true
            filteredMovies = movies.filter { movie in
                movie.title.lowercased().contains(searchText.lowercased()) ||
                movie.genre.lowercased().contains(searchText.lowercased()) ||
                movie.director.lowercased().contains(searchText.lowercased()) ||
                movie.actors.lowercased().contains(searchText.lowercased())
            }
            movieDatatableView.reloadData()
        }
    }
}

