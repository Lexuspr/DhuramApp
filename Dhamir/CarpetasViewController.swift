//
//  CarpetasViewController.swift
//  Dhamir
//
//  Created by MAC10 on 27/06/18.
//  Copyright © 2018 tecsup. All rights reserved.
//

import UIKit

class CarpetasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var carpetas = ["Mina PPP", "Constructora", "Depositorio SAC"]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carpetas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  UITableViewCell()
        cell.textLabel?.text = carpetas[indexPath.row]
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
