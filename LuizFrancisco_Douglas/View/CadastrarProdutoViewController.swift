//
//  CadastrarProdutoViewController.swift
//  LuizFrancisco_Douglas
//
//  Created by Luiz Zabuscka on 10/16/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class CadastrarProdutoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var tfState: UITextField!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var swCard: UISwitch!
    
    var selectedImage = ""
    
    var product: ProductMO!
    
    var pickerView: UIPickerView!
    var states: [StateMO]!
    var selectedState: StateMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ivPhoto.isUserInteractionEnabled = true
        ivPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPickerView))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePickerView))
        toolBar.items = [btCancel, btSpace, btDone]
        
        tfState.inputView = pickerView
        tfState.inputAccessoryView = toolBar
        
        if product != nil {
            tfName.text = product.name!
            tfState.text = product.state!.name!
            selectedState = product.state!
            selectedImage = product.picture!
            tfValue.text = String(product.value)
            
            let dataDecoded : Data = Data(base64Encoded: product.picture!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            ivPhoto.image = decodedimage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        states = StateDAO.list(context: context)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name!
    }
    
    @objc func cancelPickerView() {
        tfState.resignFirstResponder()
    }
    
    @objc func donePickerView() {
        tfState.text = states[pickerView.selectedRow(inComponent: 0)].name!
        selectedState = states[pickerView.selectedRow(inComponent: 0)]
        tfState.resignFirstResponder()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Selecionar foto", message: "De onde você quer escolher a foto?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                    self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca", style: .default, handler: { (action) in
            self.selectPicture(sourceType: .photoLibrary)
        })
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let tempImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivPhoto.image = tempImage
        
        let imageData:NSData = UIImagePNGRepresentation(tempImage)! as NSData
        selectedImage = imageData.base64EncodedString(options: .lineLength64Characters)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProduct(_ sender: UIButton) {
        if selectedState == nil || tfName.text == "" || selectedImage == "" || tfValue.text == "" {
            let alert = UIAlertController(title: "Atenção!", message: "Preencha corretamente todos os campos", preferredStyle: .alert)
            let btOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(btOK)
            present(alert, animated: true, completion: nil)
        } else {
            if product == nil {
                let prod = ProductMO(context: context)
                prod.name = tfName.text!
                prod.picture = selectedImage
                prod.state = selectedState
                prod.card = swCard.isSelected
                prod.value = Double(tfValue.text!)!
            } else {
                product.name = tfName.text!
                product.picture = selectedImage
                product.state = selectedState
                product.card = swCard.isSelected
                product.value = Double(tfValue.text!)!
            }
            ProductDAO.save(context: context)
            navigationController?.popViewController(animated: true)
        }
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
