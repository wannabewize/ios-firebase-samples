//
//  FileServiceTableViewController.swift
//  FileServiceTableViewController
//
//  Created by MRF on 2021/08/14.
//

import UIKit
import Alamofire

class FileServiceTableViewController: UITableViewController {
    var movies: [MovieInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
//        resolveMovies()
        // Alamofire로 얻기
        resolveMovies2()
    }

    func resolveMovies() {
        if let url = URL(string: "https://raw.githubusercontent.com/wannabewize/iOS-Sample-Firebase/master/FirebaseExample/movies.json") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print("error :", error)
                    return
                }
                if let data = data,
                   let root = try? JSONDecoder().decode(MovieData.self, from: data) {
                    self.movies = root.data
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }
    
    func resolveMovies2() {
        if let url = URL(string: "https://raw.githubusercontent.com/wannabewize/iOS-Sample-Firebase/master/FirebaseExample/movies.json") {
            AF.request(url).responseDecodable(of: MovieData.self) { response in
                switch response.result {
                case .failure(let error):
                    print("Error", error.localizedDescription)
                case .success(let result):
                    self.movies = result.data
                    self.tableView.reloadData()
                }
            }
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
