//
//  ViewController.swift
//  Flicko
//
//  Created by Gohar on 09/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var galleryCollection: UICollectionView?
    
    // MARK: Variables
    var listViewBarButtonOn: UIBarButtonItem!
    var listViewBarButtonOFF: UIBarButtonItem!
    var itemWidth: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation appearance
        navigationSetUp()
        
        // set collection
        setUpCollection(isGridView: false)
        
        // download and save data into coredata
        // get data from coredata
        getImageData()
        
        // Notification for first download
         NotificationCenter.default.addObserver(self, selector: #selector(loadImages), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func getImageData() {
        do {
            try DBManager.shared.fetchedhResultController.performFetch()
           // print("COUNT FETCHED FIRST: \(DBManager.shared.fetchedhResultController.sections?[0].numberOfObjects)")
        } catch let error  {
            self.showAlertWith(title: "Something went wrong", message: error.localizedDescription)
           // print("ERROR: \(error)")
        }
    }

    func navigationSetUp() {
        
        self.navigationItem.title = "Flicko"
        
        listViewBarButtonOn = UIBarButtonItem(image: UIImage(named: "grid"), style: .plain, target: self, action: #selector(didTapListBarButtonOn))
        listViewBarButtonOFF = UIBarButtonItem(image: UIImage(named: "list"), style: .plain, target: self, action: #selector(didTapListBarButtonOFF))
        
        self.navigationItem.rightBarButtonItems = [self.listViewBarButtonOn]
    }
    
    @objc func didTapListBarButtonOn() {
        self.navigationItem.setRightBarButtonItems([self.listViewBarButtonOFF], animated: false)
        setUpCollection(isGridView: true)
    }
    
    @objc func didTapListBarButtonOFF() {
        self.navigationItem.setRightBarButtonItems([self.listViewBarButtonOn], animated: false)
        setUpCollection(isGridView: false)
        
    }
    
    @objc func loadImages (_ notification: NSNotification) {
        if let dowloadState = notification.userInfo?["completed"] as? Bool {
            if dowloadState {
                getImageData()
                self.galleryCollection?.reloadData()
            }
        }
    }
}

// MARK: UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setUpCollection(isGridView: Bool) {
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 30
        if isGridView {
            itemWidth = (self.view.bounds.size.width - 20) / 2 - flowLayout.minimumLineSpacing
            flowLayout.itemSize = CGSize.init(width: itemWidth!, height: itemWidth!)
        } else {
            itemWidth = self.view.bounds.size.width - flowLayout.minimumLineSpacing - 20
            flowLayout.itemSize = CGSize.init(width: itemWidth!, height: itemWidth!)
        }
        
        flowLayout.minimumInteritemSpacing = 10
        
        galleryCollection?.collectionViewLayout = flowLayout
        galleryCollection?.dataSource = self
        galleryCollection?.delegate = self
        
        galleryCollection?.register(UINib.init(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.kGalleryIdentifier)
        galleryCollection?.contentInset = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        UIView.transition(with: self.galleryCollection!, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.galleryCollection?.reloadData()
        }, completion: nil)
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = DBManager.shared.fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kGalleryIdentifier, for: indexPath) as? ImageCollectionViewCell
        
        if let photo = DBManager.shared.fetchedhResultController.object(at: indexPath) as? Photo {
            cell?.setPhotoCellWith(photo: photo)
        }
        return cell!
    }
    
    // UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        if let photo = DBManager.shared.fetchedhResultController.object(at: indexPath) as? Photo {
            detailVC?.photo = photo
        }
        self.navigationController?.pushViewController(detailVC!, animated: true)
    }
}
