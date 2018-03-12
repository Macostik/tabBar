//
//  ViewController.swift
//  DynamicHeightStreamView
//
//  Created by Yura Granchenko on 3/7/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit
import StreamView
import SnapKit

class ViewController: UIViewController {

    @IBOutlet var streamView: StreamView!
    @IBOutlet var tabBarView: TabBarView!
    fileprivate lazy var dataSource: StreamDataSource<[String]> = {
        let ds = StreamDataSource<[String]>(streamView: self.streamView)
        return ds
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streamView.showsVerticalScrollIndicator = false
        streamView.isScrollEnabled = false
        let metrics = StreamMetrics<CharacterCell>()
        metrics.selectable = false
        metrics.modifyItem = { [unowned self] item in
            guard let streamView = self.streamView else { return }
            let view = item.metrics.loadView()
            let labelHeight = (item.entry as? String)?.heightWithFont(font: UIFont.systemFont(ofSize: 17.0), width: streamView.width) ?? 0.0
            let a = view.systemLayoutSizeFitting(UILayoutFittingExpandedSize).height + labelHeight 
            item.size = a
        }
        dataSource.addMetrics(metrics: metrics)
        dataSource.items = ["onekjdksfkjdkfjkadsjfjkkasjdfl;asdjflkajsdfkjaskdjfkjasdkfjas;lkdfjlkasdjfkjsfkdjs", "two", "three"]
    }
}

class CharacterCell: EntryStreamReusableView<String> {
    
    let characterLabel = UILabel()

    override func setup(entry: String)  {
       
        characterLabel.text = entry.uppercased()
        characterLabel.textAlignment = .center
        characterLabel.numberOfLines = 2
    }
    
    override func layoutWithMetrics(metrics: StreamMetricsProtocol) {
        super.layoutWithMetrics(metrics: metrics)
        
        addSubview(characterLabel)
        characterLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(self).inset(20)
            $0.leading.trailing.equalTo(self)
        }
    }
}

extension String {
    func heightWithFont(font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        let height = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        return ceil(height)
    }
}


