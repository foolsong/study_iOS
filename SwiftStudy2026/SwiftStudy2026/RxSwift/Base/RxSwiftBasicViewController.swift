//
//  RxSwiftBasicViewController.swift
//  rxStudy
//
//  Created by 宋永建 on 2026/1/15.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

/// RxSwift 基础操作学习页面
class RxSwiftBasicViewController: BaseStudyViewController {
    
    private lazy var rxBaseView: RxBaseView = {
        let view = RxBaseView.loadFromNib()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = RxBaseTableView.loadFromNib()
        return view.tableview
    }()
    
    let viewModel = RXBaseViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        bindData()
        
        test2()
    }
    
    
    func test() {
        let observable = Observable.of(1, 2, 3, 4)
        
        observable.subscribe(
            onNext: { t in
                print(t)
            },
            onCompleted: {
                print("completed")
            }
        ).disposed(by: disposeBag)
        
        let observabel1 = Observable.from([5, 6, 7, 8])
        
        observabel1.subscribe(
            onNext: { t in
                print(t)
            },
            onCompleted: {
                print("completed")
            }
        ).disposed(by: disposeBag)
        
        let observabel2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            
        
        observabel2.map{ num in
            "当前的数字\(num)"
        }.bind(to: self.rxBaseView.password.rx.text).disposed(by: disposeBag)
            
        let label = UILabel()
//        label.rx.text
        
    }
    
    func test2() {
        let times = [
                    [ "value": 1, "time": 0.1 ],
                    [ "value": 2, "time": 1.1 ],
                    [ "value": 3, "time": 1.2 ],
                    [ "value": 4, "time": 1.2 ],
                    [ "value": 5, "time": 1.4 ],
                    [ "value": 6, "time": 2.1 ]
                ]
                 
                //生成对应的 Observable 序列并订阅
        Observable.from(times)
            .flatMap { item in
                return Observable.of(Int(item["value"]!))
                    .delaySubscription(.seconds(Int(item["time"] ?? 0)),
                                       scheduler: MainScheduler.instance)
            }
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    
    private func setupUI() {
        view.addSubview(rxBaseView)
        rxBaseView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(280)
            
        }
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(rxBaseView.snp_bottomMargin).offset(20)
        }
    }
    
    func bindData() {
        
        // MARK: 账户密码
        
        let nameOb = rxBaseView.nameTextField.rx.text.orEmpty.map { $0.count > 5 }
        
        let passwordOb = rxBaseView.password.rx.text.orEmpty.map { $0.count > 5 }
        
        Observable.combineLatest(nameOb, passwordOb) { $0 && $1 }
            .debug("Buttonstatus")
            .bind(to: rxBaseView.submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        nameOb.map{ $0 ? UIColor.white : UIColor.red }
            .bind(to: rxBaseView.nameTextField.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        passwordOb.map{ $0 ? UIColor.white : UIColor.red }
            .bind(to: rxBaseView.password.rx.backgroundColor)
            .disposed(by: disposeBag)
        
           
        // MARK: tableview
        
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: MusicCell.identifier, cellType: MusicCell.self)) { row, item, cell in
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.singer
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Music.self).subscribe(
            onNext: { item in
                print("选中 \(item.singer) 唱的 \(item.name)")
            }
        ).disposed(by: disposeBag)
        
    }
    
}
