//
//  FollowerListVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit

class FollowerListVC: UIViewController {
    
    
    //MARK: - Properties
    
    enum Section { //Hashable by default
        case main
    }
    
    var username: String!
    private var pageCount = 1
    private var followers: [Follower] = []
    private var filteredFollowers: [Follower] = []
    private var hasMoreFollowers = true
    private var isSearching = false
    
    private var collectionView: UICollectionView!
    private var dataSource:  UICollectionViewDiffableDataSource<Section, Follower>!
    
    //MARK: - App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getFollowers(username: username, page: pageCount)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    //MARK: - Functional
    
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] results in
            
            guard let self = self else { return }
            self.dimissLoadingView()
            switch results {
            case .success(let followers):
                print("followers.count is :\(followers.count)")
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers) //strong reference to self which is FollwerListVC
                if self.followers.isEmpty {
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: "No Followers", in: self.view)
                    }
                    
                }
                self.updateData(on: self.followers)
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened😵", messgae: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            //default cell right now, not follower cell, so we have to cast it as FollowerCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    //MARK: - UI Configuration
    
    
    //This Screen View
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
    }
    
    
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self //set the delegate to self
        searchController.searchBar.placeholder = "Search for a user name"
        navigationItem.searchController = searchController
        //searchController.obscuresBackgroundDuringPresentation = false //CollectionView black overlay
    }
}
//MARK: - UICollectionViewDelegate


extension FollowerListVC: UICollectionViewDelegate {
    
    //UICollectionViewDelegate also contains ScrollViewDelegate
    //this method actually in scrollview delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {
                return
            }
            pageCount += 1
            getFollowers(username: username, page: pageCount)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let follower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        let destinationVC = UserInfoVC()
        destinationVC.userName = follower.login
        let navController = UINavigationController(rootViewController: destinationVC)
        present(navController, animated: true)
    }
}

//MARK: - UISearchResultsUpdating


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            return //If the serachbar is nil or the text is empty, return
        }
        isSearching = true
        filteredFollowers = followers.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followers)
    }
}
