//
//  SwipingPhotosController.swift
//  Tinder-Copy
//
//  Created by Кирилл Иванов on 16/07/2019.
//  Copyright © 2019 Kirill Ivanoff. All rights reserved.
//

import UIKit

class SwipingPhotosController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    init(isCardViewMode: Bool = false) {
        self.isCardViewMode = isCardViewMode
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    public var cardViewModel: CardViewModel! {
        didSet {
            if cardViewModel.imageUrls.count != 0 {
            controllers = cardViewModel.imageUrls.map({ (imageUrl) -> PhotoController in
                let photoController = PhotoController(imageUrl: imageUrl)
                return photoController
            })
            } else {
                controllers = [PhotoController()]
            }
            setViewControllers([controllers.first!], direction: .forward, animated: true)
            setupBarViews()
        }
    }
    fileprivate let barsStackView = UIStackView(arrangedSubviews: [UIView]())
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    fileprivate var controllers = [PhotoController]()
    fileprivate let isCardViewMode: Bool
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        if isCardViewMode {
            disableSwipingAbility()
        }
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate func disableSwipingAbility() {
        view.subviews.forEach { (v) in
            if let v = v as? UIScrollView {
                v.isScrollEnabled = false
            }
        }
    }
    
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        guard let currentViewController = viewControllers!.first! as? PhotoController else { return }
        if let index = controllers.firstIndex(of: currentViewController) {
            var newIndex: Int
            if gesture.location(in: view).x > view.frame.width / 2 {
                newIndex = min(controllers.count - 1, index + 1)
            } else {
                newIndex = max(0, index - 1)
            }
            let newController = controllers[newIndex]
            setViewControllers([newController], direction: .forward, animated: false)
            setCurrentBar(index: newIndex)
        }
    }
    
    fileprivate func setCurrentBar(index: Int) {
        barsStackView.arrangedSubviews.forEach(({$0.backgroundColor = barDeselectedColor}))
        barsStackView.arrangedSubviews[index].backgroundColor = .white
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
        let paddingTop: CGFloat = isCardViewMode ? 8 : UIApplication.shared.statusBarFrame.height + 8
        barsStackView.addConsctraints(view.leadingAnchor, view.trailingAnchor, view.topAnchor, nil, .init(top: paddingTop, left: 8, bottom: 0, right: 8), .init(width: 0, height: 4))
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let currentViewController = viewControllers?.first
        if let index = controllers.firstIndex(where: {$0 == currentViewController}) {
            setCurrentBar(index: index)
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
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class PhotoController: UIViewController {
    init(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        imageView.image = #imageLiteral(resourceName: "photo_placeholder")
        super.init(nibName: nil, bundle: nil)
    }
    
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
