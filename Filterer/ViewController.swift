//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let animationDuration = 0.4
    let alphaColor: CGFloat = 0.3

    var image: UIImage?
    var isShowOriginal = true
    var currentIndex = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewFiltered: UIImageView!
    
    @IBOutlet weak var secondaryMenu: UIView!
    @IBOutlet weak var sliderMenu: UIView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var bottomMenu: UIView!
    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var brightnessButton: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var visualOriginal: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        initButtons()
    }
    
    func initButtons() {
        image = imageView.image
        compareButton.enabled = false
        brightnessButton.enabled = false
        visualOriginal.alpha = 0
        filterButton.selected = false
    }

    // MARK: Compare
    @IBAction func onCompare(sender: AnyObject) {
        isShowOriginal = !isShowOriginal
        changeView(isShowOriginal)
    }
    
    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.changeView(true)
            self.initButtons()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            brightnessButton.selected = false
            hideSliderMenu()
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    // MARK: Slider Menu
    @IBAction func onSlider(sender: UIButton) {
        if (sender.selected) {
            hideSliderMenu()
            sender.selected = false
        } else {
            filterButton.selected = false
            hideSecondaryMenu()
            showSliderMenu()
            sender.selected = true
        }
    }
    
    func showSliderMenu() {
        view.addSubview(sliderMenu)
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(44)

        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animateWithDuration(animationDuration) {
            self.sliderMenu.alpha = 1.0
        }
        
    }

    func hideSliderMenu(useAnimation: Bool = true) {
        UIView.animateWithDuration(0.4, animations: {
            self.sliderMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.sliderMenu.removeFromSuperview()
            }
        }
    }
    
    // MARK: Change Imasge
    func getImage(index: Int) -> String {
        return "scenery"
        /*
        switch index{
        case 0...2: return "paint-brush"
        case 3:     return "charlie-chaplin" // black-white
        case 4:     return "camera-photo"    // sepia
        case 5:     return "paint-bucket"    // brightness
        case 6:     return "paint-roller"    // contrast
        case 7:     return "pencil-ruler"    // trunc
        default:    return "scenery"
        }
        */
    }
    
    func getColor(index: Int) -> UIColor {
        switch index{
        case 0:     return UIColor.redColor().colorWithAlphaComponent(alphaColor)
        case 1:     return UIColor.greenColor().colorWithAlphaComponent(alphaColor)
        case 2:     return UIColor.blueColor().colorWithAlphaComponent(alphaColor)
        case 3:     return UIColor.blackColor().colorWithAlphaComponent(alphaColor)
        case 4:     return UIColor.orangeColor().colorWithAlphaComponent(alphaColor)
        default:    return UIColor.whiteColor().colorWithAlphaComponent(alphaColor)
        }
    }
    
    func hasSlider(index: Int) -> Bool {
        switch index{
        case 3...4: return false
        default:    return true
        }
    }
    
    func applyFilterWithNumber(index: Int){
        let raw = ImageFilter(image: image!)
        switch index {
        case 0:
            let value = slider.value
            raw.applyFilter(.Red(value))
            imageViewFiltered.image = raw.image
        case 1:
            let value = slider.value
            raw.applyFilter(.Green(value))
            imageViewFiltered.image = raw.image
        case 2:
            let value = slider.value
            raw.applyFilter(.Blue(value))
            imageViewFiltered.image = raw.image
        case 3:
            raw.applyFilter(.GreyScale)
            imageViewFiltered.image = raw.image
        case 4:
            raw.applyFilter(.Sepia)
            imageViewFiltered.image = raw.image
        case 5:
            let value = slider.value * (5 - 0.2) + 0.2
            raw.applyFilter(.Brightness(value)) // use 0.2 to 5
            imageViewFiltered.image = raw.image
        case 6:
            let value = slider.value * (256) - 128
            raw.applyFilter(.Contrast(value)) // use -128 to +128
            imageViewFiltered.image = raw.image
        case 7:
            let value = slider.value * (200) - 50
            raw.applyFilter(.TruncToWhite(value)) // use -50 to 150
            imageViewFiltered.image = raw.image
        default: break
        }
        compareButton.enabled = true
        changeView(false)
    }
    
    
    func changeView(isShowOriginal: Bool){
        if isShowOriginal{
            self.visualOriginal.alpha = 1.0
            
            UIView.animateWithDuration(animationDuration) {
                self.imageView.alpha = 1.0
                self.imageViewFiltered.alpha = 0.0
            }
            
        } else {
            self.visualOriginal.alpha = 0.0
            
            UIView.animateWithDuration(animationDuration) {
                self.imageView.alpha = 0.0
                self.imageViewFiltered.alpha = 1.0
            }
        }
    }
    
    @IBAction func sliderDragged(sender: AnyObject) {
        applyFilterWithNumber(currentIndex)
    }
    
    @IBAction func touchDown(sender: AnyObject) {
        changeView(true)
    }
    
    @IBAction func upInside(sender: AnyObject) {
        changeView(false)
    }
}


// MARK: - UITableViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 8;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! MyCell
        let image = UIImage(named: getImage(indexPath.row))
        cell.imageView.image = image
        cell.backgroundColor = getColor(indexPath.row)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        brightnessButton.enabled = hasSlider(currentIndex)
        applyFilterWithNumber(currentIndex)
    }
}

