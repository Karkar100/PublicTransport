//
//  ViewController.swift
//  Public Transport
//
//  Created by Kirill Mordashov on 25.02.2022.
//

import UIKit
import Network
import SnapKit

class StationListViewController: UIViewController, StationListViewProtocol{

    let simpleTableIdentifier = "SimpleTableIdentifier"
    let cellID = "cellID"
    var tableView = UITableView.init(frame: .zero, style: .plain)
    var presenter: StationListPresenterProtocol?
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")

    override func viewDidLoad() {
        super.viewDidLoad()
        monitor.pathUpdateHandler = { pathUpdateHandler in
                    if pathUpdateHandler.status == .satisfied {
                        print("Internet connection is on.")
                    } else {
                        DispatchQueue.main.async {
                            self.offline()
                        }
                    }
                }
        monitor.start(queue: queue)
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
        //tableView.register(StationListTableCell.self, forCellReuseIdentifier: self.cellID ?? "cellID" )
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewHorizontalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        let tableViewVerticalConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let tableViewWidthConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let tableViewHeightConstraint = NSLayoutConstraint(item: tableView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: 0)
        self.view.addConstraints([tableViewHorizontalConstraint, tableViewVerticalConstraint, tableViewWidthConstraint, tableViewHeightConstraint])
        tableView.dataSource = self.presenter
        tableView.delegate = self.presenter
        // Do any additional setup after loading the view.
    }

    func openStation(id: String) {
        
    }

    func offline(){
        let noNetLabel = UILabel()
        noNetLabel.textAlignment = .center
        let shadow = NSShadow()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.red,
        ]
        noNetLabel.attributedText = NSAttributedString(string: "Нет соединения с интернетом.", attributes: attributes)
        view.addSubview(noNetLabel)
        noNetLabel.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
        let checkLabel = UILabel()
        checkLabel.textAlignment = .center
        checkLabel.text = "Пожалуйста, проверьте подключение"
        view.addSubview(checkLabel)
        checkLabel.snp.makeConstraints{ make in
            make.top.equalTo(noNetLabel.snp_bottom).offset(5)
            make.centerX.equalTo(noNetLabel)
        }
    }
    func requestSuccess() {
        tableView.reloadData()
    }
    
    func requestFailure(error: Error) {
        print(error.localizedDescription)
    }
    
}

