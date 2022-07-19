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
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

        Task {
            do {
                let followers = try await NetworkManager.shared.getFollowersWithAsync(for: username, page: page)
                updateUI(with: followers)
            } catch {
                
                if let gfError = error as? GFError {
                    presentGFAlertOnMainThread(title: "Bad Stuff Happened😵", messgae: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
        dimissLoadingView()
    }
    
    
    func updateUI(with followers: [Follower]) {
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
        
        Task {
            do {
                let user = try await NetworkManager.shared.getUserInfoWithAsync(for: username)
                addToFavorites(user: user)
            } catch {
                if let gfError = error as? GFError {
                    presentGFAlertOnMainThread(title: "Bad Stuff Happened😵", messgae: gfError.rawValue, buttonTitle: "Ok")
                } else {
                    presentDefaultError()
                }
            }
        }
        dimissLoadingView()
        
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
        //searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self //set the delegate to self
        searchController.searchBar.placeholder = "Search for a user name"
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false //CollectionView black overlay
    }
    
    private func addToFavorites(user: User) {
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl) //based on that user, create a favorite object
        PersistanceManager.updateWith(favorites: favorite, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGFAlertOnMainThread(title: "Success!🎉", messgae: "You have successfully favorited this user", buttonTitle: "Ok")
                return
            }
            
            self.presentGFAlertOnMainThread(title: "Duplicated user!", messgae: error.rawValue, buttonTitle: "Ok")
        }
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


extension FollowerListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
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


extension FollowerListVC: UserInfoVCDelegate {
    func didRequestFollowers(for username: String) {
        //get followers for that user
        self.username = username
        title = username //reset navigationBar title
        pageCount = 1 //clear pageCount
        followers.removeAll() //clear followers array
        filteredFollowers.removeAll() //clear filteredFollowers array
        //collectionView.setContentOffset(.zero, animated: true) //scroll to the top
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: username, page: pageCount)
    }
}
