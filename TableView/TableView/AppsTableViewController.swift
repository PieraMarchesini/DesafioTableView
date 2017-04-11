//
//  AppsTableViewController.swift
//  TableView
//
//  Created by Guilherme Paciulli on 10/04/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class AppsTableViewController: UITableViewController {
    var apps: [App] = ArrayApp.instance.apps
//    
//    var apps: [(foto: String, nome: String, categoria: String)]! = [("facebook.png", "Facebook", "Social"), ("instagram.png", "Instagram", "Social"), ("messenger.png", "Messenger", "Comunicação"), ("snapchat.png", "Snapchat", "Social"), ("spotify.png", "Spotify", "Entretenimento"), ("uber.png", "Uber", "Transporte"), ("whatsapp.png", "WhatsApp", "Comunicação") ]
    
    var sections: [String] = [String]()
    
    @IBAction func saveToMainViewController(segue: UIStoryboardSegue) {
        let appEditViewcontroller = segue.source as! AppEditTableViewController
        let index = appEditViewcontroller.index
        let editedApp = appEditViewcontroller.editedApp
        
        ArrayApp.instance.changeIndex(index: index!, app: editedApp!)
        
        for app in apps {
            if !sections.contains(app.categoria) {
                sections.append(app.categoria)
            }
        }
        
//        let appStringCategory = appEditViewcontroller.editedAppCategory
//        apps[index!].nome = appString!
//        apps[index!].categoria = appStringCategory!
        
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoria = apps.filter({$0.categoria == sections[indexPath.section]})
            
            for (i, app) in apps.enumerated() {
                if categoria[indexPath.row].nome.localizedStandardContains(app.nome) {
                    apps.remove(at: i)
                }
            }
            
            if tableView.numberOfRows(inSection: indexPath.section) == 1 {
                sections.remove(at: indexPath.section)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath){
        var fromArray = apps.filter({$0.categoria == sections[fromIndexPath.section]})
        
        let toArray = apps.filter({$0.categoria == sections[to.section]})
        
        let fromCell = fromArray[fromIndexPath.row]
        
        if toArray.count > 0 {
            fromCell.categoria = toArray[0].categoria
            fromArray = apps.filter({$0.categoria == sections[fromIndexPath.section]})
            if fromArray.count == 0 {
                sections.remove(at: fromIndexPath.section)
                tableView.deleteSections(IndexSet(integer: fromIndexPath.section), with: .automatic)
            }
        } else {
            fromCell.categoria = sections[to.section]
        }
        
        var appRemoved:App?
        for (i, app) in apps.enumerated() {
            if fromCell.nome.localizedStandardContains(app.nome) {
                appRemoved = apps.remove(at: i)
            }
        }
        
        apps.insert(appRemoved!, at: to.row)
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
            
//            let categoria = apps.filter({$0.categoria == sections[(path?.section)!]})
            
            let appEditViewcontroller = segue.destination as! AppEditTableViewController
            let cell = tableView.cellForRow(at: path!)?.textLabel?.text
            
            appEditViewcontroller.index = path?.row
            
            for app in apps{
                if(app.nome == cell){
                    appEditViewcontroller.index = apps.index(where: {(item) -> Bool in
                        item.nome == app.nome
                    })
                    appEditViewcontroller.app = app
                }
            }
            
//            appEditViewcontroller.modelArray = categoria
        }
        
    }

}
