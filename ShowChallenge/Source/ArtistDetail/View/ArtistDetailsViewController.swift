//
//  ArtistDetailsViewController.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 28/06/21.
//

import UIKit

// MARK: Class

class ArtistDetailsViewController: UIViewController, Storyboarded {
    
    // MARK: Properties
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var pictureShadowView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ArtistDetailsViewModel?
    var coordinator: ArtistDetailsCoordinator?
    
    var didCallEvent: ((ArtistDetailsViewController.Event) -> Void)?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.delegate = self
        
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadArtistData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.subviews.first?.alpha = 100
        navigationItem.largeTitleDisplayMode = .never
        
        viewModel?.fetchShows()
    }
    
    // MARK: Methods
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        collectionView.collectionViewLayout = layout
    }
    
    func loadArtistData() {
        guard let viewModel = viewModel else { return }
        
        if let imageUrl = viewModel.artist.image?.medium {
            pictureImageView.sd_setImage(
                with: URL(string: imageUrl),
                placeholderImage: #imageLiteral(resourceName: "profile-placeholder"),
                options: [],
                context: nil
            )
        }
        
        pictureShadowView.applyShadow(cornerRadius: pictureImageView.layer.cornerRadius)
        
        nameLabel.text = viewModel.artist.name
        countryLabel.text = viewModel.artist.country?.name
    }
    
}

// MARK: Extensions - ArtistDetailsViewController

extension ArtistDetailsViewController: ArtistDetailsViewModelDelegate {
    func didUpdateShowsList() {
        collectionView.reloadData()
    }
}

// MARK: Extensions - ArtistDetailsViewController

extension ArtistDetailsViewController {
    enum Event {
        case showDetail(show: TVShow)
    }
}

// MARK: Extensions - ArtistDetailsViewController

extension ArtistDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.shows.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistShowCollectionViewCell", for: indexPath) as! ArtistShowCollectionViewCell
        
        if let show = viewModel?.shows[indexPath.row] {
            cell.setup(tvShow: show)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let shows = viewModel?.shows else { return }
        
        didCallEvent?(.showDetail(show: shows[indexPath.row]))
        
    }
    
}

// MARK: Extensions - ArtistDetailsViewController

extension ArtistDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 128)
    }
}
