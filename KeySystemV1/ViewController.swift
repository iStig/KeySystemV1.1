//
//  ViewController.swift
//  KeySystemV1
//
//  Created by Yichuan Wang on 1/24/16.
//  Copyright © 2016 Yichuan Wang. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITextFieldDelegate {
  
  //MARK: Properties
  @IBOutlet weak var DoorText: UITextField!
  @IBOutlet weak var DoorLabel: UILabel!
  var doornumber: String = " "
  //var i: Int = 0
  
  //MARK: UITextFieldDelegate
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    //Hide the Keyboard
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    doornumber = textField.text!
  }
  
  //MARK: Actions
  @IBAction func Search(sender: UIButton) {
     self.loadNetValue()
//    let list =  self.loadBundleValue()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    DoorText.delegate = self
  }
  
  func loadNetValue() -> NSArray {
    var list = [Model]()
    Alamofire.request(.GET, "http://localhost:8888/items/56a5a10a1cd92c194b9bcc94")
      .responseJSON { (response) -> Void in
        
        let JSON = response.result.value
        
        if (JSON != nil) {
          print("hello")
          print(JSON!["keyinfo"]as! NSArray)
          list = self.toModel(JSON as! NSDictionary) as! [Model];
          
          print(list.count);
          for i in list{
            if self.doornumber == i.Door {
              self.DoorLabel.text = "Floor:\(i.Floor!)  keyCode:\(i.keyCode!)  "
            }
            else {
              self.DoorLabel.text = "Door Number not found"
            }
            print("search has been run")
          }

          
          
        }
    }
    return list
  }
  
  func loadBundleValue() -> NSArray {
    var list = [Model]()
    let path = NSBundle.mainBundle().pathForResource("data", ofType: "txt")
    let data = NSData(contentsOfFile: path!)
    if data != nil {
      let JSON: NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)) as! NSDictionary
      list = toModel(JSON) as! [Model];
    }
    return list
  }
  
  func toModel(dic:NSDictionary) -> NSArray {
    var list = [Model]()
    let keyinfo = dic["keyinfo"] as! NSArray
    
    for i in keyinfo {
      let model:Model = Model()
      model.Door = i["Door#"] as? String;
      model.Floor = i["Floor"] as? String;
      model.keyCode = i["KeyCode"] as? String
      list.append(model);
    }
    
    return list
  }
}


class Model:NSObject {
  var Door:String?
  var Floor:String?
  var keyCode:String?
}
