//
//  StationListTableCell.swift
//  Public Transport
//
//  Created by Diana Princess on 25.02.2022.
//

import UIKit

class StationListTableCell: UITableViewCell {
    var content: StationCellContent?{
        didSet{
            stationNameLabel.text = content?.name
        }
    }
    private let stationNameLabel : UILabel = {
     let lbl = UILabel()
     lbl.textColor = .black
     lbl.font = UIFont.boldSystemFont(ofSize: 16)
     lbl.textAlignment = .left
     return lbl
     }()
    private let stationImage : UIImageView = {
     let imgView = UIImageView()
     imgView.contentMode = .scaleAspectFit
     imgView.clipsToBounds = true
     return imgView
     }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     addSubview(stationImage)
     addSubview(stationNameLabel)
    stationImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 50, height: 0, enableInsets: false)
        stationNameLabel.anchor(top: topAnchor, left: stationImage.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2 , height: 0, enableInsets: false)
    }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
         }
}
    
