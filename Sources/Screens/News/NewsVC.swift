//
//  NewsVC.swift
//  MaintainMyCity
//
//  Created by swstation on 8/27/18.
//  Copyright © 2018 swstation. All rights reserved.
//

import UIKit
import AlamofireImage

class NewsVC: UIViewController, NewsViewModelDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var isVizible: NSLayoutConstraint!
    @IBOutlet weak var isHidden: NSLayoutConstraint!
    @IBOutlet weak var categoryView: UIView!
    var emptyPlaceholderView =  EmptyPlaceholderView()
    var authView = LaterAuthorizationView()
    
    var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = self.view.bounds.size.width - 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 5.0, bottom: 10, right: 5.0)
        layout.estimatedItemSize = CGSize(width: width - 20, height: 10)
        return layout
    }
    
    var router: FlowRouter!
    var viewModel: NewsViewModelType!
    var count: Int = 0
    var vm: NewsViewModel?
    func toggleCategory(visible: Bool, title: String?) {
        if (visible) && (title != nil) {
            
            isHidden.priority = UILayoutPriority(999)
            isVizible.priority = UILayoutPriority(250)
            categoryLabel.text = title?.uppercased()
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()}
        } else {
            
            isVizible.priority = UILayoutPriority(999)
            isHidden.priority = UILayoutPriority(250)
            self.view.layoutIfNeeded()
        }
        
    }
    
    @IBAction func dropSelectedCategory(_ sender: Any) {
        viewModel.dropCategory()
    }
    
    func configure(router: FlowRouter, viewModel: NewsViewModelType) {
        self.router = router
        self.viewModel = viewModel
    }
    
    func loginFB() {
        viewModel.fbLogin(vc: self)
    }
    
    func reloadRows(_ index: [IndexPath]) {
       // UIView.performWithoutAnimation {
        
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: index)
        }, completion: nil)
        
       // }
    }
    
    func viewModelLoadingStatusDidChange(status: StatusLoading) {
        DispatchQueue.main.async {
            self.emptyPlaceholderView.updateState(status)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadNextDataPage(shouldRefresh: true)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        
    }
    
    func createFooterView() {
        guard  !viewModel.isAuthorize  else { return }
        authView = LaterAuthorizationView.init(frame: view.frame)
        authView.completionToVC = {
            self.loginFB()
        }
        view.addSubview(authView)
        authView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        authView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        authView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        authView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.25).isActive = true
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(emptyPlaceholderView)
        emptyPlaceholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        emptyPlaceholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        emptyPlaceholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        emptyPlaceholderView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        emptyPlaceholderView.recognizerCompletion = {
            
            self.viewModel.loadNextDataPage(shouldRefresh: true)}
        
        emptyPlaceholderView.isUserInteractionEnabled = true
        categoryView.backgroundColor = UIColor(red: 70/255.0, green: 196/255.0, blue: 108/255.0, alpha: 1.0)
        viewModel.delegate = self
        createFooterView()
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.collectionViewLayout = layout
        viewModel.didFinishAuth = {[weak self] loggedIn, error in
            if let `error` = error {
                self?.handleError(error)
            }
        }
        
        viewModel.displayProgress = { [weak self] display in
            if let view = self?.view, display {
                LoaderView.sharedInstance.start(in: view)
            } else {
                LoaderView.sharedInstance.stop()
            }
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.view.backgroundColor = .white
        navigationItem.title = "Новости"
        navigationItem.setTitle(viewModel.setTitleDate())
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let mode: UINavigationItem.LargeTitleDisplayMode = scrollView.contentOffset.y <= 0 ? .always : .never
        if mode != self.navigationItem.largeTitleDisplayMode {
            self.navigationItem.largeTitleDisplayMode = mode
        }
    }
    
    @objc func refresh() {
        collectionView.reloadData()
    }
    
    func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error as? String, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension NewsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  viewModel.sections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NewsCollectionViewCell
        
        let cellModel = viewModel.cellModelForItem(at: indexPath)
        cell?.category = {
            self.viewModel.filterChanged = { visible, title in
                self.toggleCategory(visible: visible, title: title)
            }
            self.viewModel.filteringByCategory(at: indexPath)
            
        }
        cell?.like = { shouldLike in
            self.viewModel.toggleLikeForItem(indexPath, isLiked: shouldLike)
           //self.refresh()
            cell?.heartButton.isEnabled = (cellModel?.stateBottonLike)!
        }
        cell?.setup(with: cellModel)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if !self.authView.isHidden {
            insets.bottom = self.authView.bounds.height + 10
        } else {
            insets.bottom = 10
            
        }
        
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let cell = collectionView.cellForItem(at: indexPath) as? NewsCollectionViewCell
           collectionView.performBatchUpdates({
            cell?.showFullDescription()
           }, completion: nil)
      
        viewModel.addingForExpandingStateCell(selectedCellAtIndexPath: indexPath)
    }
    
}

extension UINavigationItem {
    
    func setTitle(_ title: String) {
        
        let view = HeaderView.init(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        
        let dateLabel = UILabel(frame: view.bounds.insetBy(dx: 10, dy: 0))
        dateLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        dateLabel.text = title
        dateLabel.font = UIFont(name: "SF Pro Text", size: 13.0)
        dateLabel.textColor = .gray
        
        view.addSubview(dateLabel)
        
        self.titleView = view
    }
}
extension NewsVC {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        router.prepare(for: segue, sender: sender)
    }
}
