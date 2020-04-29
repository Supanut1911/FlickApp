//
//  ViewController.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 22/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FlickVC: UIViewController {

    var flickDatas: FlickData?
    var flickStoreDatas: Results<FlickRealmData>!
    var selectCellIndex: Int = 0
    var refreshControl = UIRefreshControl()
    
    let realm = try! Realm()
    let flickManager = FlickManager()
    let url = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        if CheckInternet.Connection() {
            print("connect")
            fetchFlick()
        } else {
            print("not connect")
            loadData()
        }
        
        
    }
    
    @objc func refresh(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.fetchFlick()
            self.refreshControl.endRefreshing()
        }
       
    }
    
    func storeLocalStorage(image: String, link: String) {
        let newRecord = FlickRealmData()
        newRecord.storeImage = image
        newRecord.storeLink = link
        do {
            try self.realm.write {
                realm.add(newRecord)
            }
        } catch {
            print("Can not save image & link to local Storage")
        }
    }
    
    func loadData() {
        flickStoreDatas = realm.objects(FlickRealmData.self)
    }
    
    func fetchFlick() {
        flickManager.fetchFlick(urlString: url) { [weak self](result) in
            guard let this = self else {return}
            switch result {
            case .success(let flickData):
                this.flickDatas = flickData
//                this.flickStoreData?.storeImage = flickData.items
//                this.updateView(data: flickData)
                
//                self?.storeLocalStorage(image: this.flickDatas?.items,
//                                  link: this.flickDatas?.items.first?.link ?? "")
                this.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
}


extension FlickVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CheckInternet.Connection() {
            return flickDatas?.items.count ?? 0
        } else {
            return flickStoreDatas.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! FlickCell
        if CheckInternet.Connection() {
            let url = URL(string: flickDatas?.items[indexPath.row].media.m ?? "")
            cell.mainImageView.kf.setImage(with: url)
            cell.linkLabel.text = flickDatas?.items[indexPath.row].link
            self.storeLocalStorage(image: flickDatas?.items[indexPath.row].media.m ?? "",
                                   link: flickDatas?.items[indexPath.row].link ?? "")

        } else {
            let url = URL(string: flickStoreDatas[indexPath.row].storeImage)
            cell.mainImageView.kf.setImage(with: url)
            cell.linkLabel.text = flickStoreDatas[indexPath.row].storeLink
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FlickVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToLink", sender: self)
        selectCellIndex = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebViewVC {
            destination.linkUrl = flickDatas?.items[selectCellIndex].link ?? ""
        }
    }
}

