//
//  TutorialViewController.swift
//  Aaveg
//
//  Created by Gautham Kumar on 08/12/16.
//  Copyright © 2016 Gautham Kumar. All rights reserved.
//

class TutorialViewController: UIViewController, SWRevealViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scoreboardNavItem: UINavigationItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreboardNavItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.rightButtonClicked))
        scoreboardNavItem.rightBarButtonItem?.tintColor = UIColor.white
        
        pageControl.addTarget(self, action: #selector(TutorialViewController.didChangePageControlValue), for: .valueChanged)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        //Closing reveal view on tap
        self.revealViewController().delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Setting status bar color
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
        
    }
    
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
        tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
    
    func leftButtonClicked() {
        print("Clicked the left button")
    }
    
    func rightButtonClicked() {
        if wasInternetPresent {
            obtainScoreboardData(index: currentScoreboardPage)
        }
        
        else {
            obtainScoreboardData(index: 1)
            obtainScoreboardData(index: 2)
            obtainScoreboardData(index: 3)
            wasInternetPresent = true
        }

    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
