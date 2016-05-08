//
//  ViewController.swift
//  Photo Search Example
//
//  Created by Dan Dorner on 5/6/16.
//  Copyright © 2016 Daniel Dorner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInstagramByHashtag("dogs")
        
    }
    //MARK: Utility methods
    func searchInstagramByHashtag(searchString:String) {
        let manager = AFHTTPSessionManager()
        manager.GET("https://api.instagram.com/v1/tags/\(searchString)/media/recent?access_token=38158697.1677ed0.665dbfd17a424568bfd6a6bb5ec0d5cc",
            parameters: nil,
            progress: nil,
            success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
                if let responseObject = responseObject {
                    if let dataArray = responseObject["data"] as? [AnyObject] {
                        var urlArray:[String] = []
                        for dataObject in dataArray {
                            if let imageURLString = dataObject.valueForKeyPath("images.standard_resolution.url") as? String {
                                urlArray.append(imageURLString)
                            }
                        }
                        //display urlArray in ScrollView
                        let imageWidth = self.view.frame.width
                        self.scrollView.contentSize = CGSizeMake(imageWidth, imageWidth * CGFloat(dataArray.count))
                        
                        for var i = 0; i < urlArray.count; i++ {
                            let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))
                            if let url = NSURL(string: urlArray[i]) {
                                imageView.setImageWithURL( url)
                                self.scrollView.addSubview(imageView)
                            }
                        }
                        
                    }
                }
            },
            failure: { (operation: NSURLSessionDataTask?,error: NSError) in
                print("Error: " + error.localizedDescription)
        })
        
    }
    
    //MARK: UISearchBarDelegate protocol methods
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let whitespace = NSCharacterSet.whitespaceCharacterSet()
        let range = searchBar.text!.rangeOfCharacterFromSet(whitespace)
        
        
        //MARK: Remove whitespace
        if let test = range {
            print("whitespace found")
            searchBar.text!.removeRange(range!)
        }
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
            }
            searchBar.resignFirstResponder()
            if let searchText = searchBar.text {
                searchInstagramByHashtag(searchText)
            }
  
    }
}