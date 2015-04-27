//
//  RoomsViewController.swift
//  SlidingPanels
//
//  Created by Ipalibo Whyte on 12/11/14.
//  Copyright (c) 2014 Ipalibo Whyte. All rights reserved.
//

import UIKit

let kRoomCellScaling: CGFloat = 0.6

class RoomsViewController: UICollectionViewController, PanelTransitionViewController {
    var selectedIndexPath: NSIndexPath?
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ipalibo Whyte\n - \"Simple, Elegant Apps Are My Trade\""
        label.textAlignment = .Center
        label.font = UIFont(name: "Avenir-Light", size: 18.0)
        label.textColor = UIColor.blackColor()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        return label
    }()
    
    lazy var label1: UILabel = {
        let label = UILabel()
        label.text = "\"Simple, Elegant Apps Are My Trade\""
        label.textAlignment = .Center
        label.font = UIFont(name: "Avenir-Book", size: 12.0)
        label.textColor = UIColor.blackColor()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        return label
    }()

    
    let rooms = [
        Room(title: "About Me", subtitle: "21 year old student developer.", image: UIImage(named: "ProfilePic3.JPG"), color: UIColor(red:0.671, green:0.718, blue:0.718, alpha: 0.7)),
        
        Room(title: "Keey", subtitle: "Simple Beat Making for Everyone!", image: UIImage(named: "KeeyScenery.png"), color: UIColor(red: 0.2594, green: 0.3019, blue: 0.3367, alpha: 0.7)),
        
        Room(title: "Audio Hunt", subtitle: "Easily share music with friends", image: UIImage(named: "AudioHuntScenery.png"), color: UIColor(red:0.824, green:0.302, blue:0.341, alpha: 0.7)),
        
        Room(title: "Bricks", subtitle: "Destroy All Bricks", image: UIImage(named: "BricksScenery.png"), color: UIColor(red:0.004, green:0.596, blue:0.459, alpha: 0.7)),
        
        Room(title: "UoN SU Welcome App", subtitle: "App for Freshers Week", image: UIImage(named: "SUScenery.png"), color: UIColor(red:0.404, green:0.255, blue:0.447, alpha: 0.7)),
        
        Room(title: "NEFS App", subtitle: "App for the finance society", image: UIImage(named: "NEFSScenery.png"), color: UIColor(red:0.424, green:0.478, blue:0.537, alpha: 0.7)),
        
        Room(title: "Mumble", subtitle: "Local Twitter", image: UIImage(named: "MumbleScenery.png"), color: UIColor(red:0.451, green:0.686, blue:0.765, alpha: 0.7))
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        view.addSubview(nameLabel)
        view.addSubview(label1)
        
        let views = [
            "nameLabel": nameLabel,
            "label1": label1
        ]
        
        view.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        view.addConstraint(NSLayoutConstraint(item: label1, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[nameLabel]", options: nil, metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[nameLabel]|", options: nil, metrics: nil, views: views))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label1]-50-|", options: nil, metrics: nil, views: views))
        
        
    }
    
    func setupCollectionView() {
        let screenSize = UIScreen.mainScreen().bounds.size
        let cellWidth = floor(screenSize.width * kRoomCellScaling)
        let cellHeight = floor(screenSize.height * kRoomCellScaling)
        
        let insetX = (CGRectGetWidth(view.bounds)-cellWidth) / 2.0
        let insetY = (CGRectGetHeight(view.bounds)-cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rooms.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! RoomCell
        cell.detailView.room = rooms[indexPath.item]
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        controller.room = rooms[indexPath.item]
        presentViewController(controller, animated: true, completion: nil)
    }

    // MARK: UIScrollViewDelegate
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.memory
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex*cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.memory = offset
    }

    // MARK: PanelTransitionViewController
    
    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailView! {
        if let indexPath = selectedIndexPath {
            if let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? RoomCell {
                return cell.detailView
            }
        }
        return nil
    }
}
