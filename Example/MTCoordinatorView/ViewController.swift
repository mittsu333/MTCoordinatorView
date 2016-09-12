//
//  ViewController.swift
//  MTCoordinatorView
//
//  Created by mittsuu on 09/12/2016.
//  Copyright (c) 2016 mittsuu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = sampleDataArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

