//
//  AppsTableViewController.swift
//  TableView
//
//  Created by Guilherme Paciulli on 10/04/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import UIKit

class AppsTableViewController: UITableViewController {
    
    //Pega a instância dos Apps
    var apps: [App] = ArrayApp.instance.apps
    //Array onde ficarão as sections
    var sections: [String] = [String]()
    
    
    //Action de salvar a alteração feita no AppEditTableViewController
    //Dispara quando clica o botão salvar
    @IBAction func saveToMainViewController(segue: UIStoryboardSegue) {
        //De onde veio a Segue da action
        let appEditViewController = segue.source as! AppEditTableViewController
        //Retorna o index do App editado da tela de edição
        let index = appEditViewController.index
        //Retorna o App que foi editado da tela de edição
        let editedApp = appEditViewController.editedApp
        
        //Altera o App anterior para o editado
        ArrayApp.instance.changeIndex(index: index!, app: editedApp!)
        
        //Descobre as categorias após salvar
        for app in apps {
            if !sections.contains(app.categoria) {
                sections.append(app.categoria)
            }
        }
        
        //Atualiza a tabela após a alteração
        tableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        //Aparece o botão de editar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //Número de seções
    override func numberOfSections(in tableView: UITableView) -> Int {
        //Descobre quais são as categorias dos apps
        for app in apps {
            if !sections.contains(app.categoria) {
                sections.append(app.categoria)
            }
        }
        return sections.count
    }
    
    //Define o título das sections
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    //Número de linhas da tabela
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.filter({ $0.categoria == sections[section] }).count
    }

    //Cria as células da tabela
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Identificador da célula
        let cell = tableView.dequeueReusableCell(withIdentifier: "app", for: indexPath)

        let appInSection = apps.filter({ $0.categoria == sections[indexPath.section] })
        //Texto e imagem que serão mostradas
        cell.textLabel?.text = appInSection[indexPath.row].nome
        cell.imageView?.image = UIImage(named: appInSection[indexPath.row].foto)
        return cell
    }

    //Permite a edição da TableView
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
        }
        
    }

}
