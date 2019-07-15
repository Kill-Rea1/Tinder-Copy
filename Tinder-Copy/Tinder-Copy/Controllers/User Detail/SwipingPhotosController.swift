//
//  SwipingPhotosController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 16/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public var cardViewModel: CardViewModel! {
        didSet {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> PhotoController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            setViewControllers([controllers.first!], direction: .forward, animated: true)
            setupBarViews()
        }
    }
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [UIView]())
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    fileprivate var controllers = [PhotoController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentViewController}) {
            barsStackView.arrangedSubviews.forEach({$0.backgroundColor = barDeselectedColor})
            barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == controllers.count - 1 { return nil }
        return controllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = controllers.firstIndex(where: {$0 == viewController}) ?? 0
        if index == 0 { return nil }
        return controllers[index - 1]
    }
    
    fileprivate func setupBarViews() {
        cardViewModel.imageUrls.forEach { (_) in
            let barView = UIView()
            barView.backgroundColor = barDeselectedColor
            barView.layer.cornerRadius = 2
            barsStackView.addArrangedSubview(barView)
        }
        barsStackView.arrangedSubviews.first?.backgroundColor = .white
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        view.addSubview(barsStackView)
        let paddingTop = UIApplication.shared.statusBarFrame.height + 8
        barsStackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, nil, .init(top: paddingTop, left: 8, bottom: 0, right: 8), .init(width: 0, height: 4))
    }
}

class PhotoController: UIViewController {
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
