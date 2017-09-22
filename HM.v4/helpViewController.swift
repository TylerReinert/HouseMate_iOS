//
//  helpViewController.swift
//  HM.v4
//
//  Created by Ben Myatt on 4/2/17.
//  Copyright © 2017 Ben Myatt. All rights reserved.
//

import UIKit

class helpViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    
    
    // storyboard is not instantiated at very beginning so need to do lazy var to initialize and use the diff views
    lazy var VCarray: [UIViewController] = {
        //returns array of view controllers
        return [self.VCInstance(name: "help1"),
                self.VCInstance(name: "help2"),
                self.VCInstance(name: "help3"),
                self.VCInstance(name: "help4")]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        // sets our first view controller
        if let firstVC = VCarray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageViewController {
                view.backgroundColor = UIColor.clear
            }
        }
    
    }
    
    
    // tells the current view controller which view comes before it in the array
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore ViewController:
        UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCarray.index(of: ViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard VCarray.count > previousIndex else {
            return nil
        }
        
        return VCarray[previousIndex]
    }
    
    // tells the current view controller which view comes after it in the array
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter ViewController:
        UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCarray.index(of: ViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1

        guard nextIndex <= VCarray.count else {
            return VCarray.first
        }
        
        guard VCarray.count > nextIndex else {
            return nil
        }
        
        return VCarray[nextIndex]
    }




    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCarray.count
        
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewContorollerIndex = VCarray.index(of: firstViewController) else{
            return 0
        }
        
        return firstViewContorollerIndex
    }
}

