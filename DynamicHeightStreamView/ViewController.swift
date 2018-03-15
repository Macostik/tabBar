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
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet var streamView: StreamView!
    @IBOutlet var tabBarView: TabBarView!
    fileprivate lazy var dataSource: StreamDataSource<[String]> = {
        let ds = StreamDataSource<[String]>(streamView: self.streamView)
        return ds
    }()
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        streamView.showsVerticalScrollIndicator = false
        streamView.layout = HorizontalStreamLayout()
        streamView.isPagingEnabled = true
        let metrics = StreamMetrics<CharacterCell>()
        metrics.selectable = false
        metrics.modifyItem = { [unowned self] item in
            guard let streamView = self.streamView else { return }
            item.size = streamView.size.width
        }
        dataSource.addMetrics(metrics: metrics)
        dataSource.items = ["one", "two", "three"]
        
        tabBarView.selectItem.asObserver()
            .subscribe(onNext: { [unowned self] item in
                guard let item = item else { return }
                self.streamView.scrollToItemPassingTest(test: { $0.position.index == item.position.index }, animated: true)
            }).disposed(by: disposeBag)
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
            $0.edges.equalTo(self)
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


