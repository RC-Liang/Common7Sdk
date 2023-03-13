//
//  AlertAnimateView.swift
//  
//  alert 显示动画 具体content 可以继承

import UIKit
import SnapKit
import QuartzCore
import Foundation

public protocol AlertAnimateViewDelegate: NSObjectProtocol {
    
    func alertContentView(_ alertView: AlertAnimateView) -> UIView
}

public class AlertAnimateView: UIView {
    
    open var isClickBack: Bool = false {
        didSet {
            tap.isEnabled = isClickBack
        }
    }
    
    open func show(in viewController: UIViewController? = nil) {
        
        if viewController != nil {
            
            self.configContentView()
            
            let lock = NSLock()
            lock.lock()
            
            guard viewController?.view.viewWithTag(2048) == nil else {
                lock.unlock()
                return
            }
            viewController?.view.addSubview(self)
           
            self.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            self.showBackground()
            self.showAlertAnimation()
            
            lock.unlock()
            
        } else {
            
            self.configContentView()
            
            let lock = NSLock()
            lock.lock()
            
            guard UIKitCommon.rootViewController()?.view.viewWithTag(2048) == nil else {
                lock.unlock()
                return
            }
            
            for view in self.subviews {
                view.layer.removeAllAnimations()
            }
            
            if let navi = UIKitCommon.currentViewController()?.navigationController {
                navi.view.addSubview(self)
            } else {
                UIKitCommon.rootViewController()?.navigationController?.view.addSubview(self)
            }
            
            if self.superview == nil {
                UIKitCommon.currentViewController()?.view.addSubview(self)
            }
            
            if self.superview == nil {
                UIKitCommon.rootViewController()?.view.addSubview(self)
            }
            
            UIKitCommon.rootViewController()?.view.endEditing(true)
            
            self.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            self.showBackground()
            self.showAlertAnimation()
            
            lock.unlock()
        }
    }
    
    open func hide() {
        self.contentView?.isHidden = true
        self.hideAlertAnimation()
        self.removeFromSuperview()
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = .clear
        self.tag = 2048
    }
    
    open weak var delegate: AlertAnimateViewDelegate?
    
    fileprivate var contentView: UIView?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showBackground() {
        self.backgroundView.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.6
        }, completion: nil)
    }
    
    private func showAlertAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.25
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.values = [NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),
                            NSValue(caTransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),
                            NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0))]
        self.contentView?.layer.add(animation, forKey: nil)
    }
    
    private func hideAlertAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.0
        }, completion: nil)
    }
    
    
    @objc func tapBackgroud(_ sender: UITapGestureRecognizer) {
        self.hide()
    }
    
    fileprivate func configContentView () {
        
        guard let view = delegate?.alertContentView(self) else {
            return
        }
        
        guard self.viewWithTag(1024) == nil else {
            return
        }
        
        contentView = view
        
        guard let contentView = self.contentView else {
            return
        }
        contentView.tag = 1024
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.center = self.center
        self.insertSubview(contentView, aboveSubview: backgroundView)
        
        let size = contentView.frame.size
        contentView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
    }
    
    // MARK: setter
    
    fileprivate lazy var backgroundView: UIView = {
        let tmpView = UIView()
        tmpView.frame = UIScreen.main.bounds
        tmpView.backgroundColor = .black
        tmpView.addGestureRecognizer(tap)
        self.addSubview(tmpView)
        return tmpView
    }()
    
    fileprivate lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapBackgroud(_:)))
        return tap
    }()
}

