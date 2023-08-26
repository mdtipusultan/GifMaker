import UIKit
import FLAnimatedImage


class gifVC: UIViewController {
    @IBOutlet weak var gifSearchBar: UISearchBar!
    
    private var gifs: [Gif] = []
    private var gifCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifSearchBar.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupCollectionView()
        
        // Load multiple random GIFs initially
        fetchRandomGIFs()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        let collectionViewFrame = CGRect(x: 0, y: 200, width: view.bounds.width, height: view.bounds.height)
        gifCollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        gifCollectionView.delegate = self
        gifCollectionView.dataSource = self
        gifCollectionView.backgroundColor = .clear// Set the collection view background color
        
        // Register the UICollectionViewCell class for the collection view
        gifCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // Add the collection view as a subview to the view controller's view
        view.addSubview(gifCollectionView)
    }
    
    @IBAction func purchaseBUttonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Purchase", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "purchaseVC")
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    private func fetchRandomGIFs() {
        let apiKey = "HDwy5Yc1FMnzX83F2zJdyYRQm8oI7y3k"
        let url = URL(string: "https://api.giphy.com/v1/gifs/random?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let gif = self?.parseGifData(data) {
                DispatchQueue.main.async {
                    self?.gifs = [gif]
                    self?.gifCollectionView.reloadData()
                }
            } else {
                print("Error fetching random GIFs: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }


    
    private func searchGIFs(query: String) {
        let apiKey = "HDwy5Yc1FMnzX83F2zJdyYRQm8oI7y3k"
        let queryEncoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: "https://api.giphy.com/v1/gifs/search?api_key=\(apiKey)&q=\(queryEncoded)")!
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let gifs = self?.parseGifsData(data) {
                DispatchQueue.main.async {
                    self?.gifs = gifs
                    self?.gifCollectionView.reloadData()
                }
            } else {
                print("Error searching GIFs: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
    
    private func parseGifData(_ data: Data) -> Gif? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(GiphyRandomGifResponse.self, from: data)
            return response.data
        } catch {
            print("Error parsing GIF data: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func parseGifsData(_ data: Data) -> [Gif]? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(GiphySearchGifResponse.self, from: data)
            return response.data
        } catch {
            print("Error parsing GIFs data: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - UICollectionViewDataSource

extension gifVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let gif = gifs[indexPath.item]
        
        // Create or reuse an existing FLAnimatedImageView
        var imageView: FLAnimatedImageView? = cell.contentView.viewWithTag(101) as? FLAnimatedImageView
        
        if imageView == nil {
            imageView = FLAnimatedImageView(frame: cell.contentView.bounds)
            imageView?.contentMode = .scaleAspectFit
            imageView?.tag = 101
            cell.contentView.addSubview(imageView!)
        }
        
        if let url = URL(string: gif.images.original.url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        imageView?.animatedImage = FLAnimatedImage(animatedGIFData: data)
                    }
                }
            }.resume()
        }
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension gifVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 20) / 2 // Two gifs per row
        return CGSize(width: width, height: width)
    }
}

// MARK: - UISearchBarDelegate

extension gifVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchGIFs(query: searchText)
        }
        searchBar.resignFirstResponder()
    }
}

// MARK: - Data Models

struct Gif: Codable {
    let id: String
    let title: String
    let images: GifImages
}

struct GifImages: Codable {
    let fixedHeight: GifImageData
    let original: GifImageData
    
    enum CodingKeys: String, CodingKey {
        case fixedHeight = "fixed_height"
        case original
    }
}

struct GifImageData: Codable {
    let url: String
}

struct GiphyRandomGifResponse: Codable {
    let data: Gif
}

struct GiphySearchGifResponse: Codable {
    let data: [Gif]
}
