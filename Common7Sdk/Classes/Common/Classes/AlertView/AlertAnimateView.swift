//
//  AlertAnimateView.swift
//
//  alert 显示动画 具体content 可以继承

import Foundation
import QuartzCore
import RxSwift
import SnapKit
import UIKit

public protocol AlertAnimateViewDelegate: NSObjectProtocol {
    func alertContentView(_ alertView: AlertAnimateView) -> UIView
}

public class AlertAnimateView: UIView {
    open var isClickBack: Bool = false {
        didSet {
            tap.isEnabled = isClickBack
        }
    }

    open var isCenter: Bool = true

    open func show(in viewController: UIViewController? = nil) {
        if viewController != nil {
            configContentView()

            let lock = NSLock()
            lock.lock()

            guard viewController?.view.viewWithTag(2048) == nil else {
                lock.unlock()
                return
            }
            viewController?.view.addSubview(self)

            snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }

            showBackground()
            showAlertAnimation()

            lock.unlock()

        } else {
            configContentView()

            let lock = NSLock()
            lock.lock()

            guard UIKitCommon.rootViewController()?.view.viewWithTag(2048) == nil else {
                lock.unlock()
                return
            }

            for view in subviews {
                view.layer.removeAllAnimations()
            }

            if let navi = UIKitCommon.currentViewController()?.navigationController {
                navi.view.addSubview(self)
            } else {
                UIKitCommon.rootViewController()?.navigationController?.view.addSubview(self)
            }

            if superview == nil {
                UIKitCommon.currentViewController()?.view.addSubview(self)
            }

            if superview == nil {
                UIKitCommon.rootViewController()?.view.addSubview(self)
            }

            UIKitCommon.rootViewController()?.view.endEditing(true)

            snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }

            showBackground()
            showAlertAnimation()

            lock.unlock()
        }
    }

    open func hide() {
        contentView?.isHidden = true
        hideAlertAnimation()
        removeFromSuperview()
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .clear
        tag = 2048
    }

    open weak var delegate: AlertAnimateViewDelegate?

    fileprivate var contentView: UIView?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func showBackground() {
        backgroundView.alpha = 0
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
        contentView?.layer.add(animation, forKey: nil)
    }

    private func hideAlertAnimation() {
        UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseIn, animations: {
            self.backgroundView.alpha = 0.0
        }, completion: nil)
    }

    fileprivate func configContentView() {
        guard let view = delegate?.alertContentView(self),
              viewWithTag(1024) == nil else {
            return
        }

        contentView = view

        guard let contentView = contentView else {
            return
        }
        contentView.tag = 1024
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        if isCenter {
            contentView.center = center
        }

        insertSubview(contentView, aboveSubview: backgroundView)

        if isCenter {
            let size = contentView.frame.size
            contentView.snp.remakeConstraints { make in
                make.center.equalToSuperview()
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
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
        _ = tap.rx.event.subscribe(onNext: { [weak self] _ in
            self?.hide()
        })
        return tap
    }()
}
