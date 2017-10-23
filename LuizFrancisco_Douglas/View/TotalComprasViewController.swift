//
//  TotalComprasViewController.swift
//  LuizFrancisco_Douglas
//
//  Created by Luiz Zabuscka on 10/16/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class TotalComprasViewController: UIViewController {
    
    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var lbUS: UILabel!
    @IBOutlet weak var lbRS: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let products = ProductDAO.list(context: context)
        
        let iof = UserDefaults.standard.double(forKey: "iof")
        let dolarValue = UserDefaults.standard.double(forKey: "dolarValue")
        
        var totalRS = 0.0
        var totalUS = 0.0
        
        for prod in products {
            //State tax
            var value = prod.value + (prod.value*((prod.state?.tax)!/100))
            
            //IOF if Card = true
            if prod.card {
                value = value + value*(iof/100)
            }
            
            totalUS += value
        }
        
        totalRS = totalUS*dolarValue
        
        lbUS.text = String(format: "U$ %.2f", totalUS)
        lbRS.text = String(format: "R$ %.2f", totalRS)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
