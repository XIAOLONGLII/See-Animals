//
//  ViewController.swift
//  SeeFood
//
//  Created by Xiaolong Li on 10/16/17.
//  Copyright © 2017 Xiaolong Li. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera //use camera
        // imagePicker.sourceType = .photoLibrary use photo library
        imagePicker.allowsEditing = false
    }

   

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //check image is not nil
        if let userPickedimage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //add image view
            imageView.image = userPickedimage
            
            guard let ciimage = CIImage(image: userPickedimage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            detect(image: ciimage)
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    func detect(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
        }
            //print(results)
            if let firstResult = results.first {
               // let animalArr = ["dog","cat","bird","pig","cow","horse","sheep"]
                //for item in animalArr{
                  //  if firstResult.identifier.contains(item) {
                       // self.navigationItem.title = "It is \(item)"
                  //  } else {
                        self.navigationItem.title = "Not an animal!"
                //}
           // }
           // }
        //}
                
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else if firstResult.identifier.contains("dog") {
                    self.navigationItem.title = "Dog!"
                } else if firstResult.identifier.contains("cat") {
                    self.navigationItem.title = "Cat!"
                } else if firstResult.identifier.contains("sheep") {
                    self.navigationItem.title = "Sheep!"
                } else if firstResult.identifier.contains("pig") {
                    self.navigationItem.title = "Pig!"
                } else if firstResult.identifier.contains("keyboard") {
                    self.navigationItem.title = "Keyboard!"
                } else if firstResult.identifier.contains("glasses") {
                    self.navigationItem.title = "Glasses!"
                } else {
                    self.navigationItem.title = "Not Hotdog!"
                }
            }
        }
    
            
    
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try! handler.perform([request])
        } catch {
            print(error)
        }
        
        
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

