
//
//  ShowCollectionSegue.swift
//  Flipcard
//
//  Created by Natalia Zarawska 2 on 07/02/17.
//  Copyright © 2017 Natalia Zarawska 2. All rights reserved.
//

import UIKit
import os.log

class CollectionViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    var cardDeck: CardDeck?
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        if let name = cardDeck?.name {
            nameTextField.text = name
            //            nameTextField.isEnabled = false
        }
        
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let button = sender as? UIBarButtonItem, button == saveButton else {
            os_log("the save button was not pressed - canceling", log: OSLog.default, type: .debug)
            return
        }
        if let name = nameTextField.text {
            cardDeck = CardDeck(name: name, id:"id placeholder")
        }
    }
    
    // MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editting
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameTextField.resignFirstResponder()
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: Private
    private func updateSaveButtonState() {
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}
