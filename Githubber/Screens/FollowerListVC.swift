//
//  FollowerListVC.swift
//  Githubber
//
//  Created by Terry Kuo on 2021/4/26.
//

import UIKit

protocol followerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

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
    
    
    @objc private func addbuttonTapped() {
        
        showLoadingView()
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dimissLoadingView()
            switch result {
            
            case .success(let user): //if success, get the user
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl) //based on that user, create a favorite object
                
                PersistanceManager.updateWith(favorites: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!🎉", messgae: "You have successfully favorited this user", buttonTitle: "Ok")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Duplicated user!", messgae: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", messgae: error.rawValue , buttonTitle: "Ok")
            }
        }
        
    }
    
    //MARK: - UI Configuration
    
    
    //This Screen View
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addbuttonTapped))
        navigationItem.rightBarButtonItem = addButton
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
        destinationVC.delegate = self
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


//MARK: - followerListVCDelegate


extension FollowerListVC: followerListVCDelegate {
    func didRequestFollowers(for username: String) {
        //get followers for that user
        self.username = username
        title = username //reset navigationBar title
        pageCount = 1 //clear pageCount
        followers.removeAll() //clear followers array
        filteredFollowers.removeAll() //clear filteredFollowers array
        collectionView.setContentOffset(.zero, animated: true) //scroll to the top
        getFollowers(username: username, page: pageCount)
    }
}
