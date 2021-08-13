//
//  BundleTableViewController.swift
//  BundleTableViewController
//
//  Created by MRF on 2021/08/14.
//

import UIKit

class BundleTableViewController: UITableViewController {
    var movies: [MovieInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadMovieData()
    }

    func loadMovieData() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json"),
            let data = try? Data(contentsOf: url),
           let root = try? JSONDecoder().decode(MovieData.self, from: data) {

            self.movies = root.data
            self.tableView.reloadData()
        }        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        let item = movies[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = "\(item.director) - \(item.actors)"
        return cell
    }
}
