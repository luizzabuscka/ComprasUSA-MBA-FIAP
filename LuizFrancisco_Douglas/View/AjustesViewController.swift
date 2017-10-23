//
//  AjustesViewController.swift
//  LuizFrancisco_Douglas
//
//  Created by Luiz Zabuscka on 10/16/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class AjustesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tfDolarValue: UITextField!
    @IBOutlet weak var tfIOF: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var states: [StateMO] = []
    var messageLabel: UILabel? = nil
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tfDolarValue.text = String(defaults.double(forKey: "dolarValue"))
        tfIOF.text = String(defaults.double(forKey: "iof"))
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel?.text = "Lista de estados vazia."
        messageLabel?.textAlignment = .center
        messageLabel?.sizeToFit()
        
        states = StateDAO.list(context: context)
    }
    
    
    @IBAction func addState(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Adicionar Estado",
                                      message: "",
                                      preferredStyle: .alert)
        
        let submitAction = UIAlertAction(title: "Adicionar", style: .default, handler: { (action) -> Void in
            let tfState = alert.textFields![0]
            let tfTax = alert.textFields![1]
            
            let state = StateMO(context: self.context)
            state.name = tfState.text!
            state.tax = Double(tfTax.text!)!
            StateDAO.save(context: self.context)
            
            self.states = StateDAO.list(context: self.context)
            self.tableView.reloadData()
        })
        
        let cancel = UIAlertAction(title: "Cancelar", style: .destructive, handler: { (action) -> Void in })
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
        }
        
        alert.addAction(cancel)
        alert.addAction(submitAction)
        
        present(alert, animated: true, completion: nil)

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if states.count > 0 {
            return 1
        } else {
            tableView.backgroundView = messageLabel!
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        cell.textLabel?.text = states[indexPath.row].name!
        cell.detailTextLabel?.textColor = .red
        cell.detailTextLabel?.text = String(states[indexPath.row].tax)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if StateDAO.delete(context: context, state: states[indexPath.row]) {
                states = StateDAO.list(context: context)
                tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(Double(tfDolarValue.text!)!, forKey: "dolarValue")
        defaults.set(Double(tfIOF.text!)!, forKey: "iof")
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
