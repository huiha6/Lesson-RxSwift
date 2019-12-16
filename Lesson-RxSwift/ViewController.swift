//
//  ViewController.swift
//  Lesson-RxSwift
//
//  Created by jinjin on 2018/6/28.
//  Copyright © 2018年 jinjin. All rights reserved.
//

import UIKit

//https://www.jianshu.com/p/f61a5a988590
//http://www.hangge.com/blog/cache/detail_1918.html

//在这一节中要学习到：tableview的rx用法，订阅 just bind
struct Music {
    let name: String?
    let singer: String?
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
    
}
extension Music: CustomStringConvertible {
    var description: String {
        return "name:\(String(describing: name)), singer:\(String(describing: singer))"
    }
    
}

class ViewController: UIViewController {

    let musicListViewModel = MusicListViewModel()
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        musicListViewModel.obs
        musicListViewModel.obs1
        
        view.addSubview(tableView)
        
        musicListViewModel.data.bind(to: tableView.rx.items(cellIdentifier: "musicCell")){
            _, music, cell in
            cell.textLabel?.text = music.name
            cell.detailTextLabel?.text = music.singer
        }.disposed(by: disposeBag)
        tableView.rx.modelSelected(Music.self).subscribe(onNext: { (music) in
            print("你选中的歌曲信息\(music)")
        }).disposed(by: disposeBag)
        
        var isOdd = true
        let factory: Observable<Int> = Observable.deferred {
            isOdd = !isOdd
            if isOdd {
                return Observable.of(1, 3, 5, 7)
            }else {
                return Observable.of(2, 4, 6, 8)
            }
        }
        
        factory.subscribe{
            event in
            print("\(isOdd)", event.element)
        }
        factory.subscribe{
            event in
            print("\(isOdd)", event)
        }
        
//        let ob1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        ob1.subscribe{
//            event in
//            print(event)
//        }
        let ob2 = Observable<Int>.timer(3, scheduler: MainScheduler.instance)
        ob2.subscribe{
            event in
            print(event)
        }
        
        let ob3 = Observable.of("a", "b", "c")
        ob3.subscribe(onNext: { (element) in
            print(element)
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            print("completed")
        }) {
            print("disposed")
        }.disposed(by: disposeBag)
        
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let ob4 = Observable<Int>.interval(2, scheduler: MainScheduler.instance)
        ob4.map{$0*11}.bind{
                [weak self](text) in
                cell?.textLabel?.text = String(text)
        }.disposed(by: disposeBag)
        
        //AnyObserver可以用来描述任意一种观察者
        //可以配合bindTo使用
        let ob5: AnyObserver<String> = AnyObserver {
            event in
            switch event {
            case .next(let text):
                cell?.textLabel?.text = text
            case .error(_):
                break
            case .completed:
                break
            }
        }
        let OB5 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        OB5.map{
            "==\($0)+="
        }.bind(to: ob5).disposed(by: disposeBag)
        
    }

    //
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "musicCell")
        return tableView
    }()
    


}

