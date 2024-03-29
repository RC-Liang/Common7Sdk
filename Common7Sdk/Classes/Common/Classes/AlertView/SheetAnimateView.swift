//
//  SheetAnimateView.swift
//
//  action sheet 显示动画 具体content 可以继承

import Foundation
import RxSwift
import SnapKit
import UIKit

public protocol SheetAnimateViewDelegate: NSObjectProtocol {
    func sheetContentView(_ sheetView: SheetAnimateView) -> UIView
}

public extension SheetAnimateView {
    enum Status {
        case `default`
        case top
        case bottom
    }
}

public class SheetAnimateView: UIView {
    open var isClickBack: Bool = false {
        didSet {
            tap.isEnabled = isClickBack
        }
    }

    open var status: SheetAnimateView.Status = .default

    open func show(in viewController: UIViewController? = nil) {
        if viewController != nil {
            configContentView()

            let lock = NSLock()
            lock.lock()

            guard viewController?.view.viewWithTag(2048) == nil else {
                return
            }
            viewController?.view.addSubview(self)
            snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }

            showBackground()

            lock.unlock()

        } else {
            configContentView()

            let lock = NSLock()
            lock.lock()

            guard UIKitCommon.rootViewController()?.view.viewWithTag(2048) == nil else {
                lock.unlock()
                return
            }

            UIKitCommon.rootViewController()?.view.addSubview(self)
            snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
            showBackground()

            lock.unlock()
        }
    }

    open func hide() {
        contentView?.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(UIKitCommon.screenHeight)
        }

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }) { _ in
            self.hideSheetAnimation()
        }
    }

    init() {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = .clear
        tag = 2048
    }

    open weak var delegate: SheetAnimateViewDelegate?

    fileprivate var contentView: UIView?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func showBackground() {
        backgroundView.alpha = 0
        layoutIfNeeded()

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn) {
            self.backgroundView.alpha = 0.6
        } completion: { _ in
            self.showSheetAnimation()
        }
    }

    private func showSheetAnimation() {
        contentView?.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

    private func hideSheetAnimation() {
        contentView?.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(UIKitCommon.screenHeight)
        }

        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)

        UIView.animate(withDuration: 0.2, delay: 0.25, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0.0
        }) { _ in
            self.contentView?.isHidden = true
            self.removeFromSuperview()
        }
    }

    fileprivate func configContentView() {
        guard let view = delegate?.sheetContentView(self),
              viewWithTag(1024) == nil else {
            return
        }

        contentView = view

        guard let contentView = contentView else {
            return
        }

        contentView.tag = 1024
        contentView.backgroundColor = .white

        insertSubview(contentView, aboveSubview: backgroundView)

        let size = contentView.frame.size
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(size.height)
            make.bottom.equalToSuperview().offset(UIKitCommon.screenHeight)
        }

        UIKitCommon.cornerRadius(view: contentView, radius: 10, corner: [.topLeft, .topRight])
    }

    // MARK: setter

    fileprivate lazy var backgroundView: UIView = {
        let tmpView = UIView()
        tmpView.backgroundColor = .black
        tmpView.addGestureRecognizer(tap)
        self.addSubview(tmpView)
        tmpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
