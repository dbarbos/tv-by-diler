//
//  ShowDetailViewController.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 27/06/21.
//

import UIKit

// MARK: - Class
class ShowDetailViewController: UIViewController , Storyboarded{
    
    // MARK: - Properties
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingValueLabel: UILabel!
    
    @IBOutlet weak var aboutDialogShowTitleLabel: UILabel!
    @IBOutlet weak var aboutDialogShowGenreLabel: UILabel!
    @IBOutlet weak var aboutDialogShowSummaryLabel: UILabel!
    
    @IBOutlet weak var airedTimeLabel: UILabel!
    @IBOutlet weak var weekDaysLabel: UILabel!
    @IBOutlet weak var premieredLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var selectSeasonButton: UIButton!
    @IBOutlet weak var addOrRemoveToFavoriteButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ShowDetailViewModel?
    
    var didCallEvent: ((ShowDetailViewController.Event) -> Void)?
    
    var coordinator: ShowDetailCoordinator?
    
    var isFavorite: Bool = false {
        didSet {
            isFavorite
                ? addOrRemoveToFavoriteButton.setTitle("Remove from favorite", for: .normal)
                : addOrRemoveToFavoriteButton.setTitle("Add to favorite", for: .normal)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        viewModel?.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        collectionView.collectionViewLayout = layout
        
        setupNavigationBar()
        setupScrollView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadShowData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel?.fetchEpisodes()
        
        if let show = viewModel?.tvShow {
            isFavorite = LocalStorageManager.shared.isFavorite(show.id)
        }
        
        posterImageView.addBlackGradientLayerInForeground(frame: posterImageView.bounds, colors: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1978717324),.black])
    }
    
    // MARK: - Methods
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .never

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.subviews.first?.alpha = 0
    }
    
    func loadShowData() {
        guard let viewModel = viewModel else { return }
        
        if let imageUrl = viewModel.tvShow.image?.original {
            posterImageView.sd_setImage(
                with: URL(string: imageUrl),
                placeholderImage: #imageLiteral(resourceName: "film-poster-placeholder"),
                options: [],
                context: nil
            )
        }
        
        nameLabel.text = viewModel.tvShow.name
        
        detailsLabel.text = viewModel.details
        
        summaryLabel.attributedText = viewModel.tvShow.summary?.asHtmlAttributed(color: .white)
        
        ratingValueLabel.text = String(viewModel.tvShow.rating?.average ?? 0.0)
        ratingView.backgroundColor = viewModel.ratingColor()
        
        aboutDialogShowTitleLabel.text = viewModel.tvShow.name
        aboutDialogShowGenreLabel.text = viewModel.genres
        aboutDialogShowSummaryLabel.attributedText = viewModel.tvShow.summary?.asHtmlAttributed(color: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
        
        weekDaysLabel.text = viewModel.weekDays
        airedTimeLabel.text = viewModel.tvShow.schedule?.time
        premieredLabel.text = viewModel.tvShow.premiered
        languageLabel.text = viewModel.tvShow.language
        statusLabel.text = viewModel.tvShow.status

    }
    
    // MARK: - Actions
    @IBAction func selectSeasonButtonTapped(_ sender: Any) {
        
        guard let seasons = viewModel?.seasons else { return }
        
        let selectSeasonActionSheet = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let sortedSeasons = seasons.sorted(by: { $0.key < $1.key })
        
        sortedSeasons.forEach({ (season) in
            selectSeasonActionSheet.addAction(UIAlertAction(title: "Season \(season.key)", style: .default, handler: { (action) in
                if let index = selectSeasonActionSheet.actions.firstIndex(where: { $0 === action }) {
                    self.collectionView.selectItem(at: IndexPath(item: 0, section: index), animated: true, scrollPosition: .left)
                }
            }))
        })
        
        present(selectSeasonActionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func addOrRemoteToFavoriteButtonTapped(_ sender: Any) {
        
        if let show = viewModel?.tvShow {
            isFavorite = LocalStorageManager.shared.toggleFavorite(show)
        }
        
    }
    
}

// MARK: - Extensions
extension ShowDetailViewController {
    enum Event {
        case showDetail(episode: Episode)
    }
}

// MARK: - Extensions ShowDetailsViewModelDelegate
extension ShowDetailViewController: ShowDetailViewModelDelegate {
    func didUpdateSeasonsList() {
        collectionView.reloadData()
    }
}

// MARK: - Extensions UICollectionViewDataSource
extension ShowDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionViewCell", for: indexPath) as! EpisodeCollectionViewCell
        
        if let episodes = viewModel?.seasons[indexPath.section + 1] {
            cell.setup(episode: episodes[indexPath.row])
        }
        
        return cell
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.seasons.keys.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.seasons[section+1]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let episodes = viewModel?.seasons[indexPath.section + 1] else { return }
        
        let episode = episodes[indexPath.row]
        
        didCallEvent?(.showDetail(episode: episode))
    }
    
}

// MARK: - Extensions UICollectionViewDelegateFlowLayout
extension ShowDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 190)
    }

}

// MARK: - Extensions UICollectionViewDelegate
extension ShowDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let episodes = viewModel?.seasons[indexPath.section + 1] else { return nil }
        
        let episode = episodes[indexPath.row]
        
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { (actions) -> UIMenu? in
            let share = UIAction(
                title: "Share...",
                image: UIImage(systemName: "square.and.arrow.up"),
                identifier: .none,
                discoverabilityTitle: nil,
                attributes: [],
                state: .off
            ) { (action) in
                let items = [
                    "You have to watch this episode! \(episode.name ?? "")"]
                self.present(
                    UIActivityViewController(activityItems: items, applicationActivities: nil),
                    animated: true
                )
            }
            return UIMenu(
                title: "",
                image: nil,
                identifier: nil,
                options: [],
                children: [share]
            )
        }
    }
    
}

// MARK: - Extensions UIScrollViewDelegate
extension ShowDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationController = self.navigationController else { return }
        
        let navBarHeight = navigationController.navigationBar.frame.height
        let threshold: CGFloat = 1
        let alpha = (scrollView.contentOffset.y + navBarHeight + threshold) / threshold
        navigationController.navigationBar.subviews.first?.alpha = alpha
        print(alpha)
        if alpha < 100 {
            navigationController.navigationBar.tintColor = .white
            navigationController.navigationBar.subviews.first?.alpha = 0
        } else {
            navigationController.navigationBar.tintColor = .black
        }
            
    }

}

