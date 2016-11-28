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

    fileprivate var coordinateManager: MTCoordinateManager?
    fileprivate var tableView: UITableView!
    fileprivate let sampleDataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    fileprivate func setupView() {
        for i in 1...20 {
            sampleDataArray.add(String(format: "sample %02d", i))
        }
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style:.plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        // create header sample
        let headerImg = UIImage.init(named: "sample-header")
        let imgHeight = headerImg?.size.height ?? 0
        let imgWidth = headerImg?.size.width ?? 0
        let imageHeight = (imgHeight / imgWidth) * self.view.frame.width
        let headerView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: imageHeight))
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        iconView.frame = CGRect(x: startX, y: 80.f, width: iconSize, height: iconSize)
        let radius:Float = 0.5
        iconView.layer.cornerRadius = iconView.frame.width * radius.f
        iconView.clipsToBounds = true
        iconView.layer.masksToBounds = true
        iconView.layer.borderWidth = 3.f
        iconView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8).cgColor
        
        let firstChildView = MTCoordinateContainer.init(view: iconView, endForm: CGRect(x: centerX, y: 120, width: 0, height: 0), corner: radius, completion: { [weak self] in
            self?.tapEvent("Image Tap Event")
        })
        return firstChildView
    }
    
    func createSecondView() -> MTCoordinateContainer {
        let btnView = UIImageView.init(image: UIImage(named: "sample-button"))
        btnView.frame = CGRect(x: self.view.frame.size.width - 70, y: self.view.frame.size.height + 70, width: 0, height: 0)
        
        let secondChildView = MTCoordinateContainer.init(view: btnView, endForm: CGRect(x: self.view.frame.size.width - 70, y: self.view.frame.size.height, width: 50, height: 50), mode: .fixity, completion: { [weak self] in
            self?.tapEvent("Button Tap Event")
        })
        return secondChildView
    }
    
    
    // MARK: - tap event
    
    func tapEvent(_ msg: String) {
        let alertController = UIAlertController.init(title: msg, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}

// MARK: - <#UITableViewDelegate#>
extension ViewController: UITableViewDelegate {
}

// MARK: - <#UITableViewDataSource#>
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = sampleDataArray[indexPath.row] as? String
        return cell
    }
    
}

