//
//  AppsTableViewController.swift
//  TableView
//
//  Created by Guilherme Paciulli on 10/04/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class AppsTableViewController: UITableViewController {
    
    var apps:[(foto: String, nome: String, categoria: String)] = [("facebook.png", "Facebook", "Social"), ("instagram.png", "Instagram", "Social"), ("messenger.png", "Messenger", "Comunicação"), ("snapchat.png", "Snapchat", "Social"), ("spotify.png", "Spotify", "Entretenimento"), ("uber.png", "Uber", "Transporte"), ("whatsapp.png", "WhatsApp", "Comunicação") ]
    
    var sections: [String] = [String]()
    
    @IBAction func saveToMainViewController(segue: UIStoryboardSegue) {
        let appEditViewcontroller = segue.source as! AppEditTableViewController
        let index = appEditViewcontroller.index
        let appString = appEditViewcontroller.editedApp
        let appStringCategory = appEditViewcontroller.editedAppCategory
        apps[index!].nome = appString!
        apps[index!].categoria = appStringCategory!
        
        tableView.reloadData()
    }
    
    //("youtube.png", "Youtube", "Entretenimento")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        for app in apps {
            if !sections.contains(app.categoria) {
                sections.append(app.categoria)
            }
        }
        
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.filter({ $0.categoria == sections[section] }).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "app", for: indexPath)
        let s = apps.filter({ $0.categoria == sections[indexPath.section] })
        cell.textLabel?.text = s[indexPath.row].nome
        cell.imageView?.image = UIImage(named: s[indexPath.row].foto)
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            apps.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let app = apps[fromIndexPath.row]
        apps.remove(at: fromIndexPath.row)
        apps.insert(app, at: to.row)

    }
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            var path = tableView.indexPathForSelectedRow
            
            let appEditViewcontroller = segue.destination as! AppEditTableViewController
            
            appEditViewcontroller.index = path?.row
            
            appEditViewcontroller.modelArray = apps
        }
        
    }

}
