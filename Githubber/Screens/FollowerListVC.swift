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
    var pageCount = 1
    var followers: [Follower] = []
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource:  UICollectionViewDiffableDataSource<Section, Follower>!
    
    //MARK: - App Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: username, page: pageCount)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    //MARK: - Functional

    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] results in
            guard let self = self else { return }
            
            switch results {
            case .success(let followers):
                self.dimissLoadingView()
                if followers.count < 100 {
                    print("the rest is \(followers.count)")
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers) //strong reference to self which is FollwerListVC
                self.updateData()
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened😵", messgae: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            //default cell right now, not follower cell, so we have to cast it as FollowerCell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }

    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    //MARK: - UI Configuration

    
    //This Screen View
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
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
                print("there are no more followers")
                return
            }
            pageCount += 1
            getFollowers(username: username, page: pageCount)
        }
    }
    
}
