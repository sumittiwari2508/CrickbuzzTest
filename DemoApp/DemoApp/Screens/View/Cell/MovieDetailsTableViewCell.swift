//
//  MoveiDetailsTableViewCell.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 24/10/24.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var movieThumbnail: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieYear: UILabel!
    @IBOutlet weak var movieLanguages: UILabel!
    
    // Method to configure the cell with a Movie object
    func configure(with movie: Movie) {
            movieTitle.text = movie.title
            movieYear.text = movie.year
            movieLanguages.text = movie.language

        if let url = URL(string: movie.poster) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.movieThumbnail.image = image
                    }
                }
            }.resume()
        }

        }
    
}
