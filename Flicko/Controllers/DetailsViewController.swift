//
//  DetailsViewController.swift
//  Flicko
//
//  Created by Gohar on 10/11/2018.
//  Copyright © 2018 AG. All rights reserved.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var flickoImageView: UIImageView?
    @IBOutlet weak var commentsTableView: UITableView?
    @IBOutlet weak var commentTextField: UITextField? {
        didSet {
            commentTextField?.backgroundColor = .clear
            commentTextField?.textColor = .white
            commentTextField?.layer.borderWidth = 2.0
            commentTextField?.layer.borderColor = UIColor.white.cgColor
            commentTextField?.delegate = self
        }
    }
    @IBOutlet weak var commentButton: UIButton? {
        didSet {
            commentButton?.backgroundColor = .clear
            commentButton?.tintColor = .white
            commentButton?.layer.borderWidth = 2.0
            commentButton?.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var commentView: UIView? {
        didSet {
            commentView?.backgroundColor = .flGreen
        }
    }
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint?
    
    //MARK: Variables
    var photo: Photo!
    var comments = [Comments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imgUrl = photo.mediaURL {
            flickoImageView?.sd_setImage(with: URL(string: imgUrl), completed: nil)

        }
        //loadImageUsingCacheWithURLString(photo.mediaURL!, placeHolder: UIImage(named: "placeholder"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTableView))
        commentsTableView?.addGestureRecognizer(tapGesture)
        
        commentsTableView?.delegate = self
        commentsTableView?.dataSource = self
        
        comments = photo.comments!.allObjects as! [Comments]
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(shareImageAction))
    }
    
    //MARK: NotificationCenter handlers
    @objc func handleKeyboard(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            commentBottomConstraint?.constant = isKeyboardShowing ? (keyboardFrame?.height)! : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if (isKeyboardShowing){
                    if self.comments.count > 0 {
                        self.commentsTableView?.scrollToRow(at: IndexPath.init(row: self.comments.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }
            })
        }
    }
    
    @objc func didTapTableView()  {
        self.view.endEditing(true)
    }
    
    func scrollToBottom(animated: Bool) {
        if self.comments.count > 0 {
            let lastRowIndexPath = IndexPath(row: self.comments.count - 1, section: 0)
            self.commentsTableView?.scrollToRow(at: lastRowIndexPath, at: .bottom, animated: animated)
        }
    }
    
    @IBAction func sendComment(_ sender: UIButton) {
        if let commentText = commentTextField?.text {
            let comment = DBManager.shared.createCommentEntityFrom(text: commentText) as! Comments
            photo.addToComments(comment)
            CoreDataStack.sharedInstance.saveContext()
            comments.append(comment)
            self.commentsTableView?.beginUpdates()
            self.commentsTableView?.insertRows(at: [IndexPath.init(row: self.comments.count-1, section: 0)], with: .automatic)
            self.commentsTableView?.endUpdates()
           // commentsTableView?.reloadData()
        }
        commentTextField?.text = ""
        self.view.endEditing(true)
        
    }
    
    @objc func shareImageAction () {
        let imageToShare = [ flickoImageView?.image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        self.present(activityViewController, animated: false, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        debugPrint("deinit")
    }

}


// MARK: TextField
extension DetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: TableView
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell")
        cell?.textLabel?.text = comments[indexPath.row].commentText
        return cell!
    }

}
