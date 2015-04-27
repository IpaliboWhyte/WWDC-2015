//
//  DetailViewController.swift
//  SlidingPanels
//
//  Created by Ipalibo Whyte on 12/11/14.
//  Copyright (c) 2014 Ipalibo Whyte. All rights reserved.
//

import UIKit

private let kContentViewTopOffset: CGFloat = 64
private let kContentViewBottomOffset: CGFloat = 64
private let kContentViewAnimationDuration: NSTimeInterval = 1.4

class DetailViewController: UIViewController, PanelTransitionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var detailView: DetailView!
    @IBOutlet var closeButton: UIButton!
    var room: Room?
    
    let aboutMe = "Hi! My name is Ipalibo whyte, I Love building iOS Apps and websites and currently work part time for a startup in London. I am really passionate about design and love to bring small ideas to life and beautify them!. \n My love for music has contributed to my passion for building and shipping Music related apps such as Keey and crossplay."
    
    let keeyDetails = "Keey which is an iPad app and is essentially reinventing the way to make modern music. It also aims at making digital music composing, simpler and intuitive by abstracting and summarising complex fuctionalities existing in Digital Audio Workstations today. This was solely built by me."
    
    let audioHuntDetails = "Audio Hunt is my ungoing iOS music sharing application. It is essentially a seamless way of sharing music with friends and family. This was also solely built by me."
    
    let bricksDetails = "Bricks is an innovative and fun brick breaker game. Its focus is on minimalistic designs and color systems, which enhanced the gameplay experience through out and was one of the aims whilst making bricks. I Built bricks with my pairs while at university and due to its success, we got published by the bbc and local news papers!"
    
    let weekOneDetails = "Collaboratively Developed the University of Nottingham week one app in partnership with the University of Nottingham student union intended to improve the week one experience for freshers starting university. I also integrated both twitter feeds and bus times using an unofficial API I built for the University of Nottingham hopper bus."
    
    let nefsDetails = "Developed the Nottingham Economics & Finance Society app with my pairs at university and was also responsible for building the REST API and a custom Content Management System."
    
    let mumbleDetails = "Also Co developed mumble with my pairs, which is an anonymous feed app that enables anonymous localised communication."
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 355)
        layout.scrollDirection = .Horizontal
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = " sea ultimate justice. God ubermensch passion evil law joy strong salvation ocean god aversion joy prejudice zarathustra. Inexpedient mountains battle battle ocean abstract society society contradict convictions joy inexpedient truth."
        textView.font = UIFont(name: "Avenir-Black", size: 15.0)
        textView.scrollEnabled = false
        textView.editable = false
        textView.selectable = false
        textView.textAlignment = .Justified
        textView.backgroundColor = UIColor.clearColor()
        textView.textColor = UIColor(red:0.424, green:0.478, blue:0.537, alpha: 1)
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        return textView
        }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "I'm on the left."
        label.font = UIFont(name: "Avenir-Black", size: 15.0)
        label.textColor = UIColor(red:0.424, green:0.478, blue:0.537, alpha: 1)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        return label
    }()
    
    
    let contentView = UIView()
    let panelTransition = PanelTransition()

    @IBAction func handleCloseButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handlePan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .Began:
            fallthrough
        case .Changed:
            contentView.frame.origin.y += pan.translationInView(view).y
            pan.setTranslation(CGPointZero, inView: view)
            
            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
            detailView.transitionProgress = progress
            
        case .Ended:
            fallthrough
        case .Cancelled:
            let progress = (contentView.frame.origin.y - kContentViewTopOffset) / (view.bounds.height - kContentViewTopOffset - kContentViewBottomOffset)
            if progress > 0.5 {
                let duration = NSTimeInterval(1-progress) * kContentViewAnimationDuration
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in
                    [self]
                    
                    self.detailView.transitionProgress = 1
                    self.contentView.frame.origin.y = self.view.bounds.height - kContentViewBottomOffset
                    
                }, completion: nil)
            }
            else {
                let duration = NSTimeInterval(progress) * kContentViewAnimationDuration
                UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in
                    [self]
                    
                    self.detailView.transitionProgress = 0
                    self.contentView.frame.origin.y = kContentViewTopOffset
                    
                    }, completion: nil)
            }
        
        default:
            ()
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.backgroundColor = UIColor.whiteColor()
        contentView.frame = CGRect(x: 0, y: kContentViewTopOffset, width: view.bounds.width, height: view.bounds.height-kContentViewTopOffset)
        view.addSubview(contentView)
        
        
        let pan = UIPanGestureRecognizer(target: self, action: "handlePan:")
        view.addGestureRecognizer(pan)
        
        detailView.room = room
        transitioningDelegate = panelTransition
        
        contentView.backgroundColor = UIColor(red:0.925, green:0.925, blue:0.925, alpha: 1)
        collectionView.backgroundColor = UIColor.clearColor()
        label.text = "Screenshots"
        
        if room!.title == "About Me" {
            
            label.text = "I'm on the left."
            
            //textView.text = "blah blah"
            
            let image = UIImage(named: "ProfilePic2.jpg")!
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = 2.0
            imageView.clipsToBounds = true
            imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            contentView.addSubview(imageView)
            contentView.addSubview(label)
            contentView.addSubview(textView)
            textView.text = aboutMe as String;
            let views = [
                "label": label,
                "imageView": imageView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[imageView(330)]-10-[textView(200)]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[imageView(330)]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .CenterX, relatedBy: .Equal, toItem: contentView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
            
            contentView.addConstraint(NSLayoutConstraint(item: label, attribute: .Left, relatedBy: .Equal, toItem: imageView, attribute: .Left, multiplier: 1.0, constant: 0.0))
            
        } else if room!.title == "Keey" {
            
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 450, height: 315)
            layout.scrollDirection = .Horizontal
            let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.registerClass(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView.backgroundColor = UIColor.clearColor()
            collectionView.setTranslatesAutoresizingMaskIntoConstraints(false)
            collectionView.showsHorizontalScrollIndicator = false
            
            contentView.addSubview(label)
            contentView.addSubview(collectionView)
            contentView.addSubview(textView)
            textView.text = keeyDetails as String
            let views = [
                "label": label,
                "collectionView": collectionView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[label]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[collectionView(380)]-10-[textView]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: nil, metrics: nil, views: views))
            
        } else if room!.title == "Audio Hunt" {
            
            contentView.addSubview(label)
            contentView.addSubview(collectionView)
            contentView.addSubview(textView)
            textView.text = audioHuntDetails as String;
            let views = [
                "label": label,
                "collectionView": collectionView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[label]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[collectionView(380)]-10-[textView]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: nil, metrics: nil, views: views))
            
        } else if room!.title == "Bricks" {
            
            contentView.addSubview(label)
            contentView.addSubview(collectionView)
            contentView.addSubview(textView)
            textView.text = bricksDetails as String
            let views = [
                "label": label,
                "collectionView": collectionView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[label]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[collectionView(380)]-10-[textView]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: nil, metrics: nil, views: views))
            
        } else if room!.title == "UoN SU Welcome App" {
            
            contentView.addSubview(label)
            contentView.addSubview(collectionView)
            contentView.addSubview(textView)
            textView.text = weekOneDetails
            let views = [
                "label": label,
                "collectionView": collectionView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[label]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[collectionView(380)]-10-[textView]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: nil, metrics: nil, views: views))
            
        } else if room!.title == "NEFS App" {
            
            contentView.addSubview(label)
            contentView.addSubview(collectionView)
            contentView.addSubview(textView)
            textView.text = nefsDetails;
            let views = [
                "label": label,
                "collectionView": collectionView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[label]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[collectionView(380)]-10-[textView]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: nil, metrics: nil, views: views))
            
            
        } else if room!.title == "Mumble" {
            
            contentView.addSubview(label)
            contentView.addSubview(collectionView)
            contentView.addSubview(textView)
            textView.text = mumbleDetails;
            let views = [
                "label": label,
                "collectionView": collectionView,
                "textView": textView
            ]
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[label]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-20-[textView]-20-|", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label]-10-[collectionView(380)]-10-[textView]", options: nil, metrics: nil, views: views))
            
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[collectionView]|", options: nil, metrics: nil, views: views))

        } else {
            let imageView = UIImageView(image: UIImage(named: "IMG_0061"))
            contentView.addSubview(imageView)
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        if room!.title == "Keey" {
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "K1.png")
            }
            
            if indexPath.row == 1 {
                cell.imageView.image = UIImage(named: "K2.png")
            }
            
            if indexPath.row == 2 {
                cell.imageView.image = UIImage(named: "K3.png")
            }
            
            if indexPath.row == 3 {
                cell.imageView.image = UIImage(named: "K4.png")
            }
        
        } else if room!.title == "Audio Hunt" {
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "A1.png")
            }
            
            if indexPath.row == 1 {
                cell.imageView.image = UIImage(named: "A2.png")
            }
            
            if indexPath.row == 2 {
                cell.imageView.image = UIImage(named: "A3.png")
            }
            
            if indexPath.row == 3 {
                cell.imageView.image = UIImage(named: "A4.png")
            }
            
            
        } else if room!.title == "Bricks" {
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "Bricks1.png")
            }
            
            if indexPath.row == 1 {
                cell.imageView.image = UIImage(named: "Bricks2.png")
            }
            
            if indexPath.row == 2 {
                cell.imageView.image = UIImage(named: "Bricks3.png")
            }
            
            if indexPath.row == 3 {
                cell.imageView.image = UIImage(named: "Bricks4.png")
            }
            
        } else if room!.title == "UoN SU Welcome App" {
            
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "U1.jpeg")
            }
            
            if indexPath.row == 1 {
                cell.imageView.image = UIImage(named: "U2.jpeg")
            }
            
            if indexPath.row == 2 {
                cell.imageView.image = UIImage(named: "U3.jpeg")
            }
            
            if indexPath.row == 3 {
                cell.imageView.image = UIImage(named: "U4.jpeg")
            }
            
            
        } else if room!.title == "NEFS App" {
            
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "N1.jpeg")
            }
            
            if indexPath.row == 1 {
                cell.imageView.image = UIImage(named: "N2.jpeg")
            }
            
            if indexPath.row == 2 {
                cell.imageView.image = UIImage(named: "N3.jpeg")
            }
            
            if indexPath.row == 3 {
                cell.imageView.image = UIImage(named: "N4.jpeg")
            }
            
        } else if room!.title == "Mumble" {
            
            if indexPath.row == 0 {
                cell.imageView.image = UIImage(named: "M1.jpeg")
            }
            
            if indexPath.row == 1 {
                cell.imageView.image = UIImage(named: "M2.jpeg")
            }
            
            if indexPath.row == 2 {
                cell.imageView.image = UIImage(named: "M3.jpeg")
            }
            
            if indexPath.row == 3 {
                cell.imageView.image = UIImage(named: "M4.jpeg")
            }

        }
        
        return cell
    }


    // MARK: PanelTransitionViewController
    
    func panelTransitionDetailViewForTransition(transition: PanelTransition) -> DetailView! {
        return detailView
    }
    
    func panelTransitionWillAnimateTransition(transition: PanelTransition, presenting: Bool, isForeground: Bool) {
        if presenting {
            contentView.frame.origin.y = view.bounds.height
            closeButton.alpha = 0
            
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in
                [self]
                self.contentView.frame.origin.y = kContentViewTopOffset
                self.closeButton.alpha = 1
            }, completion: nil)
        }
        else {
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in
                [self]
                self.contentView.frame.origin.y = self.view.bounds.height
                self.closeButton.alpha = 0
            }, completion: nil)
        }
    }
    
}
