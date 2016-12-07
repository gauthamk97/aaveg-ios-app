//
//  PageViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 06/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var cupNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = pageControlBGColor
        
        self.dataSource = self
        
        cupNames = ["Culturals Cup", "Sports Cup", "Miscallaneous Cup"]
        
        setViewControllers([getViewController(index: 0)], direction: .forward, animated: true) { (true) in
            //completion code
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentScoreboardVC: ScoreboardViewController = viewController as! ScoreboardViewController
        
        let currentIndex = currentScoreboardVC.pageIndex
        
        if currentIndex==0 {
            return getViewController(index: cupNames.count-1)
        }
        
        else {
            return getViewController(index: currentIndex!-1)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentScoreboardVC: ScoreboardViewController = viewController as! ScoreboardViewController
        
        let currentIndex = currentScoreboardVC.pageIndex
        
        if currentIndex==cupNames.count-1 {
            return getViewController(index: 0)
        }
            
        else {
            return getViewController(index: currentIndex!+1)
        }
    }
    
    func getViewController(index: Int) -> ScoreboardViewController {
        
        let svc = self.storyboard?.instantiateViewController(withIdentifier: "ScoreboardViewController") as! ScoreboardViewController
        
        svc.pageIndex = index
        svc.CupName = cupNames[index]
        
        return svc
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return cupNames.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
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
