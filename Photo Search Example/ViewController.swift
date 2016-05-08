//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Dan Dorner on 5/6/16.
//  Copyright © 2016 Daniel Dorner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let manager = AFHTTPSessionManager()
        
        manager.GET("https://api.instagram.com/v1/tags/cats/media/recent?access_token=38158697.1677ed0.665dbfd17a424568bfd6a6bb5ec0d5cc",
            parameters: nil,
            progress: nil,
            success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
                if let responseObject = responseObject {
                    if let dataArray = responseObject["data"] as? [AnyObject] {
                        var urlArray:[String] = []                  //1
                        for dataObject in dataArray {               //2
                            if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String { //3
                                urlArray.append(imageURLString)     //4
                            }
                        }
                        self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(dataArray.count))
                        for var i = 0; i < urlArray.count; i++ {
                            let imageData = NSData(contentsOfURL: NSURL(string: urlArray[i])!)         //1
                            if let imageDataUnwrapped = imageData {                                     //2
                                let imageView = UIImageView(image: UIImage(data: imageDataUnwrapped))   //3
                                imageView.frame = CGRectMake(0, 320 * CGFloat(i), 320, 320)               //4
                                self.scrollView.addSubview(imageView)                                        //5
                            }
                        }
                          //5
                    }
                    print("Response: " + responseObject.description)
                }
            },
            failure: { (operation: NSURLSessionDataTask?,error: NSError) in
                print("Error: " + error.localizedDescription)
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

