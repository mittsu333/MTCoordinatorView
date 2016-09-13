//
//  ViewController.swift
//  MTCoordinatorView
//
//  Created by mittsuu on 09/12/2016.
//  Copyright (c) 2016 mittsuu. All rights reserved.
//

import UIKit
import MTCoordinatorView

class ViewController: UIViewController {

    private var coordinateManager: MTCoordinateManager?
    private var tableView: UITableView!
    private let sampleDataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func setupView() {
        for i in 1...20 {
            sampleDataArray.addObject(String(format: "sample %02d", i))
        }
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height), style:.Plain)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // create header sample
        let headerImg = UIImage.init(named: "sample-header")
        let imgHeight = headerImg?.size.height ?? 0
        let imgWidth = headerImg?.size.width ?? 0
        let imageHeight = (imgHeight / imgWidth) * self.view.frame.width
        let headerView = UIImageView.init(frame: CGRectMake(0, 0, self.view.frame.width, imageHeight))
        headerView.image = headerImg
        
        // set header view
        coordinateManager = MTCoordinateManager.init(vc: self, scrollView: tableView, header: headerView)

        // create view
        let firstView = self.createFirstView()
        let secondView = self.createSecondView()
        
        // set views
        coordinateManager?.setContainer(tableView, views: firstView, secondView)
        
        self.view.addSubview(tableView)
    }

    
    // MARK: - scroll event
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard let manager = coordinateManager else {
            return
        }
        manager.scrolledDetection(scrollView)
    }
    

    // MARK: - crate child view
    
    func createFirstView() -> MTCoordinateContainer {
        let iconView = UIImageView.init(image: UIImage(named: "sample-icon"))
        let centerX = self.view.frame.width / 2
        let iconSize = 110.f
        let startX = centerX - (iconSize / 2)
        iconView.frame = CGRectMake(startX, 80.f, iconSize, iconSize)
        let radius:Float = 0.5
        iconView.layer.cornerRadius = iconView.frame.width * radius.f
        iconView.clipsToBounds = true
        iconView.layer.masksToBounds = true
        iconView.layer.borderWidth = 3.f
        iconView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).CGColor
        
        let firstChildView = MTCoordinateContainer.init(view: iconView, endForm: CGRectMake(centerX, 120, 0, 0), corner: radius, completion: { [weak self] in
            self?.tapEvent("Image Tap Event")
        })
        return firstChildView
    }
    
    func createSecondView() -> MTCoordinateContainer {
        let btnView = UIImageView.init(image: UIImage(named: "sample-button"))
        btnView.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height + 100, 0, 0)
        
        let secondChildView = MTCoordinateContainer.init(view: btnView, endForm: CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height + 10, 50, 50), mode: .FIXITY, completion: { [weak self] in
            self?.tapEvent("Button Tap Event")
        })
        return secondChildView
    }
    
    
    // MARK: - tap event
    
    func tapEvent(msg: String) {
        let alertController = UIAlertController.init(title: msg, message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}

// MARK: - <#UITableViewDelegate#>
extension ViewController: UITableViewDelegate {
}

// MARK: - <#UITableViewDataSource#>
extension ViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleDataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = sampleDataArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

