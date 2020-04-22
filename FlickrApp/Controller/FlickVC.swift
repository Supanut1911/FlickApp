//
//  ViewController.swift
//  FlickrApp
//
//  Created by Supanut Laddayam on 22/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import UIKit

class FlickVC: UIViewController {

    var flickDatas: FlickData?
    
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
        print(data.items)
        print("after \(flickDatas)")
    }
    
}





extension FlickVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flickDatas?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flickCell", for: indexPath)
        cell.textLabel?.text = flickDatas?.items[indexPath.row].link
        
        return cell
    }
    
    
}

extension FlickVC: UITableViewDelegate {
    
}

