//
//  ViewController.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 22/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import UIKit
import Kingfisher

class FlickVC: UIViewController {

    var flickDatas: FlickData?
    var selectCellIndex: Int = 0
    
    let flickManager = FlickManager()
    let url = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchFlick()

        self.tableView.reloadData()
        
    }
    
    
    func fetchFlick() {
        flickManager.fetchFlick(urlString: url) { [weak self](result) in
            guard let this = self else {return}
            switch result {
            case .success(let flickData):
                this.flickDatas = flickData
                this.updateView(data: flickData)
                this.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func updateView(data: FlickData) {
        
    }
    
}





extension FlickVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flickDatas?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! FlickCell
        
        let url = URL(string: flickDatas?.items[indexPath.row].media.m ?? "")
        cell.mainImageView.kf.setImage(with: url)
        
        cell.linkLabel.text = flickDatas?.items[indexPath.row].link
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

