//
//  RecordListVC.swift
//  MyPuzzle15
//
//  Created by ericzero on 11/16/22.
//

import UIKit
import SnapKit

class RecordListVC: UIViewController {

    var tableV = UITableView()
    let cellID = "TableCell"
    
    var recordsArr = [Int]()
    
    func setUpNavItem() {
        let myTitleLabel = UILabel()
        var attributedStr = NSAttributedString(string: "Records page", attributes: [.font: UIFont.systemFont(ofSize: 25, weight: .semibold), .foregroundColor: UIColor.orange])
        myTitleLabel.attributedText = attributedStr
        navigationItem.titleView = myTitleLabel
        
        let leftBarItem = UIBarButtonItem(image: UIImage(named: "undo"), style: .plain, target: self, action: #selector(leftClicked))
            //target: self, action: #selector(leftClicked))
        leftBarItem.tintColor = .orange
        navigationItem.leftBarButtonItem = leftBarItem
    }
    
    @objc func leftClicked(_ sender: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
        setUpNavItem()
        
        
        view.addSubview(tableV)
        
        tableV.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.bottom.equalTo(0)
        }
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(TableCell.self, forCellReuseIdentifier: "TableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setConstaints() {
       
    }

}

extension RecordListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        
        cell.label.text = "\(indexPath.row + 1). place - \(recordsArr[indexPath.row]) steps."
        return cell
    }
    
    
}

