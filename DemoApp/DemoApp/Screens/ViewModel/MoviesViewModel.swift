//
//  FlickerViewModel.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 17/10/24.
//

import Foundation

class MoviesViewModel {
    
    private var movies: [Movie] = []
    private var filteredMovies: [Movie] = []
    
    func fetchMovies() {
        if let moviesData: [Movie] = loadJSON(fileName: "Movie", type: [Movie].self) {
            self.movies = moviesData
        }
    }
    
    
    func uniqueYears() -> [String] {
        let years = Set(movies.map { $0.year.trimmingCharacters(in: .whitespaces) })
        return years.sorted()
    }
    func uniqueDirectors() -> [String] {
        var uniqueDirectorsSet = Set<String>()
        for movie in movies {
            let directors = movie.director.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            uniqueDirectorsSet.formUnion(directors)
        }
        
        return Array(uniqueDirectorsSet).sorted()
    }
    
    func uniqueActors() -> [String] {
        var uniqueActorsSet = Set<String>()
        for movie in movies {
            let actors = movie.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            uniqueActorsSet.formUnion(actors)
        }
        
        return Array(uniqueActorsSet).sorted()
    }
    func uniqueGenre() -> [String] {
        var uniqueGenreSet = Set<String>()
        for movie in movies {
            let genre = movie.genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            uniqueGenreSet.formUnion(genre)
        }
        
        return Array(uniqueGenreSet).sorted()
    }
    func allMovies() -> [Movie] {
        return movies
    }
    func filterMovies(byYear year: String) -> [Movie] {
        return movies.filter { $0.year == year }
    }
    
    func filterMovies(byDirector director: String) -> [Movie] {
        
        let directorList = director.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return movies.filter { movie in
            let movieDirectors = movie.director.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            return directorList.contains { director in
                movieDirectors.contains(director)
            }
        }
    }
    
    func filterMovies(byActor actors: String) -> [Movie] {
        let actorList = actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return movies.filter { movie in
            let movieActors = movie.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            return actorList.contains { actor in
                movieActors.contains(actor)
            }
        }
    }
    func filterMovies(byGenre genre: String) -> [Movie] {
        let genreList = genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        return movies.filter { movie in
            let movieGenre = movie.genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            return genreList.contains { genre in
                movieGenre.contains(genre)
            }
        }
    }
    
    func loadJSON<T: Decodable>(fileName: String, type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("File not found: \(fileName)")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
    
    
}
