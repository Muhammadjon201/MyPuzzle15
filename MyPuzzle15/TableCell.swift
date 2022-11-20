//
//  TableCell.swift
//  MyPuzzle15
//
//  Created by ericzero on 11/16/22.
//

import UIKit
import SnapKit

class TableCell: UITableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.left.equalTo(10)
            make.bottom.right.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
