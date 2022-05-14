//
//  pageVC.swift
//  Study Time
//
//  Created by Caleb Arendse on 10/1/17.
//  Copyright © 2017 Caleb Arendse. All rights reserved.
//

import UIKit

class pageVC: UIPageViewController, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderVC.index(of: viewController)else{
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else{
            return nil
        }
        guard orderVC.count > previousIndex else{
            return nil
        }
        return orderVC[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderVC.index(of: viewController)else{
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderVcCount = orderVC.count
        guard orderVcCount != nextIndex else{
            return nil
        }
        return orderVC[nextIndex]
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let firstViewController = orderVC[1]
       setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private(set) lazy var orderVC: [UIViewController] = {
        return [self.newViewController(color: "studyMat"), self.newViewController(color: "mainView"), self.newViewController(color: "naviVC")]
    }()
    private func newViewController(color: String) -> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"\(color)")
    }
    
}
