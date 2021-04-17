//
//  IGFeedPostTableViewCell.swift
//  MyInstagramApp
//
//  Created by iMac on 11.04.2021.
//

import UIKit
import SDWebImage
import AVFoundation

// Cell for primary post content
final class IGFeedPostTableViewCell: UITableViewCell {
    
    private let postImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = nil
        image.clipsToBounds = true
        return image
    }()
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    static let identifier = "IGFeedPostTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost) {
        postImageView.image = UIImage(named: "test")
        return
        
        switch post.postType {
        case .photo:
            //show image
            postImageView.sd_setImage(with: post.postURL, completed: nil)
        case .video:
            //play video
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
            
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = contentView.bounds
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
}
