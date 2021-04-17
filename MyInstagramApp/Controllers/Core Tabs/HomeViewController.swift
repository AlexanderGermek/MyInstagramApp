//
//  ViewController.swift
//  MyInstagramApp
//
//  Created by iMac on 10.04.2021.
//

import UIKit
import FirebaseAuth

struct HomeFeedRenderViewModel { //each field consist of 4 field
    let header: PostRenderViewModel
    let post: PostRenderViewModel
    let actions: PostRenderViewModel
    let comments: PostRenderViewModel
}

class HomeViewController: UIViewController {
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        //register cells
        tableView.register(IGFeedPostHeaderTableViewCell.self, forCellReuseIdentifier: IGFeedPostHeaderTableViewCell.identifier)
        
        tableView.register(IGFeedPostTableViewCell.self, forCellReuseIdentifier: IGFeedPostTableViewCell.identifier)
        
        tableView.register(IGFeedPostActionsTableViewCell.self, forCellReuseIdentifier: IGFeedPostActionsTableViewCell.identifier)
        
        tableView.register(IGFeedPostGeneralTableViewCell.self, forCellReuseIdentifier: IGFeedPostGeneralTableViewCell.identifier)
        
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createMockModels()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func createMockModels() {
        
        let user = User(username: "joe", bio: "", name: (first: "", last: ""), profilePhoto: URL(string: "https://www.google.com")!, birthDate: Date(), gender: .male, counts: UserCount(followers: 1, following: 1, posts: 1), joinDate: Date())
        
        let post = UserPost(identifier: "", postType: .photo, thumbnailImage: URL(string: "https://www.google.com")!, postURL: URL(string: "https://www.google.com")!, caption: nil, likeCount: [], comments: [], createdDate: Date(), taggedUsers: [], owner: user)
        
        var comments = [PostComment]()
        
        for i in 0...2 {
            comments.append(
                PostComment(
                    identifier: "\(i)",
                    username: "@jenny",
                    text: "This isthe best post I've seen",
                    createdDate: Date(),
                    likes: [])
            )
        }
        
        for _ in 0...4 {
            
            let viewModel = HomeFeedRenderViewModel(
                header:   PostRenderViewModel(renderType: .header(provider: user)) ,
                post:     PostRenderViewModel(renderType: .primaryContent(provider: post)),
                actions:  PostRenderViewModel(renderType: .actions(provider: "")),
                comments: PostRenderViewModel(renderType: .comments(comments: comments))
                )
                
            feedRenderModels.append(viewModel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAthenticated()
    }
    
    private func handleNotAthenticated() {
        //dump(Auth.auth().currentUser)
        //Check auth status
        if Auth.auth().currentUser == nil {
            //Show log in
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let x = section
        let model: HomeFeedRenderViewModel
        
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? x/4 : (x - (x % 4)) / 4
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            //header
            return 1
        }
        else if  subSection == 1 {
            // post
            return 1
        }
        else if subSection == 2 {
            //actions
            return 1
        }
        else if subSection == 3 {
            //comments
            let commentsModel = model.comments
            
            switch commentsModel.renderType {
            
            case .comments(let comments):
                return comments.count > 2 ? 2 : comments.count

            default:
                fatalError("Invalid case!")
            }
            
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        
        if x == 0 {
            model = feedRenderModels[0]
        } else {
            let position = x % 4 == 0 ? x/4 : (x - (x % 4)) / 4
            model = feedRenderModels[position]
        }
        
        let subSection = x % 4
        
        
        if subSection == 0 {
            //header
            let headerModel = model.header
            
            switch headerModel.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostHeaderTableViewCell.identifier, for: indexPath) as! IGFeedPostHeaderTableViewCell
                
                cell.configure(with: user)
                cell.delegate = self
                return cell
            default: fatalError()
            }
            
        }
        else if  subSection == 1 {
            // post
            let postModel = model.post
            
            switch postModel.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostTableViewCell.identifier, for: indexPath) as! IGFeedPostTableViewCell
                
                cell.configure(with: post)

                return cell
            default: fatalError()
            }
        }
        else if subSection == 2 {
            //actions
            let actionsModel = model.actions
            
            switch actionsModel.renderType {
            case .actions(_):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostActionsTableViewCell.identifier, for: indexPath) as! IGFeedPostActionsTableViewCell
                
                cell.delegate = self
                return cell
            default: fatalError()
            }
        }
        else if subSection == 3 {
            //comments
            let commentsModel = model.comments
            
            switch commentsModel.renderType {
            case .comments(_):
                let cell = tableView.dequeueReusableCell(withIdentifier: IGFeedPostGeneralTableViewCell.identifier, for: indexPath) as! IGFeedPostGeneralTableViewCell
                return cell
            default: fatalError()
            }
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let subSection = indexPath.section % 4

        if subSection == 0 {
            return 70
        }
        else if subSection == 1 {
            return tableView.width
        }
        else if subSection == 2 {
            return 60
        }
        else if subSection == 3 {
            return 50
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
        
        
        if section % 4 == 3 {
            return 70
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }
}


extension HomeViewController: IGFeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        
        let actionSheet = UIAlertController(title: "Post Option",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { [weak self] (_) in
            self?.reportPost()
        }))
                              
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                              
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        
    }
}


extension HomeViewController: IGFeedPostActionsTableViewCellDelegate {
    
    func didTapLikeButton() {
        print("like")
    }
    
    func didTapCommentsButton() {
        print("commentrs")
    }
    
    func didTapSendButton() {
        print("send")
    }
}
