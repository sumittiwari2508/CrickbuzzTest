//
//  MovieDetailsViewController.swift
//  DemoApp
//
//  Created by Sumit Tiwari on 24/10/24.
//

import UIKit


class MovieDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePlot: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var textField: UITextField!
    var pickerView: UIPickerView!
    var movie: Movie?
    var ratings: [Rating] = []
    
    var filteredItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        view.backgroundColor = .white
        navigationItem.title = NSLocalizedString("Movie Details", comment: "")
        
        displayMovieDetails()
        setupPickerView()
        setupToolbar()
    }
    
    private func setupPickerView() {
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textField.inputView = pickerView
    }
    
    func displayMovieDetails() {
        guard let movie = movie else { return }
        movieTitle.text = movie.title
        releaseDate.text = movie.released
        ratings = movie.ratings
        if movie.ratings.count != 0 {
            let firstRating = movie.ratings[0]
            rating.text = firstRating.value
            textField.text = firstRating.source
        }
        moviePlot.text = movie.plot
        movieGenre.text = movie.actors
        if let url = URL(string: movie.poster) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.poster.image = image
                    }
                }
            }.resume()
        }
    }
    
    
    private func setupToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
    
    @objc func donePressed() {
        view.endEditing(true)
    }
}

extension MovieDetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ratings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ratings[row].source
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = ratings[row].source
        textField.text = selectedItem
        rating.text = ratings[row].value
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
