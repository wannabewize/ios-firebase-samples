# Firebase Sample

## 앱의 데이터 다루기

### 하드코딩

- 생략

### 데이터 번들

#### JSON으로 데이터 정의

```
{
    "data": [
        {
            "title": "미나리",
            "actors": "스티븐 연, 한예리, 앨런 킴, 윤여정"
        },
        {
            "title": "기생충",
            "actors": "송강호, 이선균, 조여정, 박소담"
        }
    ]
}
```

#### 번들에서 JSON 읽기 

```
struct MovieData: Codable {
    var data: [MovieInfo]
}

struct MovieInfo: Codable {
    var title: String
    var director: String
    var actors: String
    var poster: String
}

let url = Bundle.main.url(forResource: "movies", withExtension: "json")!
let data = try! Data(contentsOf: url)
let root = try? JSONDecoder().decode(MovieData.self, from: data) as! MovieResponse
let movies: [MovieInfo] = root.data
```

### 파일 저장 서비스에서 읽기

파일 저장소 서비스 선택 - Github에서 파일의 RAW 선택 - 경로 얻기

```
let url = URL(string: "https://raw.githubusercontent.com/.../movies.json")
```

데이터 로딩

```
let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let data = data,
       let root = try? JSONDecoder().decode(MovieData.self, from: data) {
        self.movies = root.data
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
task.resume()
```
