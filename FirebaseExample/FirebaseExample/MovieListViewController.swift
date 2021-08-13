//
//  FireStoreViewController.swift
//  FirebaseExample
//
//  Created by MRF on 2021/05/20.
//

import UIKit
import FirebaseFirestore

struct MovieDoc {
    let id: String
    let title: String
}

protocol MovieDataChangHandle {
    func resolveMovies()
}

class MovieListViewController: UITableViewController, MovieDataChangHandle {
    
    var movies: [MovieDoc] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resolveMovies()
    }
    
    func resolveMovies() {
        let db: Firestore = Firestore.firestore()
        let movies: CollectionReference = db.collection("movies")
        movies.getDocuments { (snapshot: QuerySnapshot?, error: Error?) in
            guard error == nil else {
                print("Error :", error)
                return
            }

            // 콜렉션 내 도큐먼트 배열
            let documents: [QueryDocumentSnapshot] = snapshot!.documents
            
            
            // 도큐먼트 배열에서 도큐먼트 ID, 제목으로 이루어진 배열 변환
            self.movies = documents.map { document in
                let movieId = document.documentID
                let value: [String: Any] = document.data()
                let title = value["title"] as! String
                return MovieDoc(id: movieId, title: title)
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell),
           let detailVC = segue.destination as? MovieDetailViewController {
            
            let movie = movies[indexPath.row]
            detailVC.movieId = movie.id
        }
        else if let vc = segue.destination as? AddMovieViewController {
            vc.delegate = self
        }
    }
}
