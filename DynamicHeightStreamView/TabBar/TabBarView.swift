//  
//  TabBarView.swift
//  DynamicHeightStreamView
//
//  Created by Yura Granchenko on 3/12/18.
//  Copyright © 2018 Yura Granchenko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StreamView

class TabBarView: UIView {
    
    @IBOutlet var streamView: StreamView!
    var viewModel = TabBarViewModel()
    var selectItem = PublishSubject<StreamItem?>()
    private let disposeBag = DisposeBag()
    fileprivate lazy var dataSource: StreamDataSource<[String]> = {
        let ds = StreamDataSource<[String]>(streamView: self.streamView)
        return ds
    }()

    deinit {

    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        streamView.showsHorizontalScrollIndicator = false
        streamView.isScrollEnabled = false
        streamView.layout = HorizontalStreamLayout()
        let metrics = StreamMetrics<TabBarItemCell>()
        metrics.modifyItem = { [unowned self] item in
            item.size = self.streamView.width/3
        }
        metrics.selection = { [unowned self] view in
            guard let item = view.item else { return }
            self.streamView.itemsPassingTest(test: { $0 !== item }).forEach({ $0.selected = false })
            item.selected = true
            self.viewModel.selectItem.onNext(view.item)
        }
        dataSource.addMetrics(metrics: metrics)
        viewModel.items.accept(["a", "b", "c"])
        
    }
    private func setupBindings() {
        viewModel.items.asObservable()
            .bind(to: dataSource.rx.items)
            .disposed(by: disposeBag)
        viewModel.selectItem.asObservable()
            .bind(to: selectItem )
            .disposed(by: disposeBag)
    }
}

class TabBarItemCell: EntryStreamReusableView<String> {
    
    let characterLabel = UILabel()
    
    override func setup(entry: String)  {
        
        characterLabel.text = entry
        characterLabel.textAlignment = .center
        characterLabel.font = UIFont.icons(size: 17.0)
        characterLabel.textColor = UIColor.black
    }
    
    override func layoutWithMetrics(metrics: StreamMetricsProtocol) {
        super.layoutWithMetrics(metrics: metrics)
        
        addSubview(characterLabel)
        characterLabel.snp.makeConstraints {
            $0.edges.equalTo(self)
        }
    }
    
    override var selected: Bool {
        didSet {
            characterLabel.textColor = selected ? .white : .black
        }
    }
}

extension Reactive where Base: StreamDataSource<[String]> {
    public var items: Binder<[String]> {
        return Binder(self.base) { dataSource, value in
            dataSource.items = value
        }
    }
}

extension Reactive where Base: StreamView {
    public var scrollToItem: Binder<StreamItem?>  {
        return Binder(self.base) { streamView, value in
            _ = streamView.scrollToItemPassingTest(test: { (item) -> Bool in
                return item === value
            }, animated: false)
        }
    }
}

extension Reactive where Base: UILabel {
    public var select: Binder<Bool>  {
        return Binder(self.base) { label, selected in
            label.textColor = selected ? .white : .black
        }
    }
}

extension UIFont {
    static func icons(size: CGFloat) -> UIFont! {
        return UIFont(name: "idic", size: size)
    }
}


