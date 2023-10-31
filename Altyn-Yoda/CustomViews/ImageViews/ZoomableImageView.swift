//
//  ZoomableImageView.swift
//  Salam-beta
//
//  Created by Shirin on 29.06.2022.
//

import UIKit

class ZoomableImageView: UIImageView {
    var pinchZoomHandler: PinchZoomHandler!

    var zoomDelegate: ZoomingDelegate? {
        get {
            return pinchZoomHandler.delegate
        } set {
            pinchZoomHandler.delegate = newValue
        }
    }
    
    var minZoomScale: CGFloat {
        get {
            return pinchZoomHandler.minZoomScale
        } set {
            pinchZoomHandler.minZoomScale = abs(min(1.0, newValue))
        }
    }
    
    // Maximum Scale of ImageView
    var maxZoomScale: CGFloat {
        get {
            return pinchZoomHandler.maxZoomScale
        } set {
            pinchZoomHandler.maxZoomScale = abs(max(1.0, newValue))
        }
    }
    
    // Duration of finish animation
    var resetAnimationDuration: Double {
        get {
            return pinchZoomHandler.resetAnimationDuration
        } set {
            pinchZoomHandler.resetAnimationDuration = abs(newValue)
        }
    }
    
    // True when pinching active
    var isZoomingActive: Bool {
        get {
            return pinchZoomHandler.isZoomingActive
        } set { }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        commonInit()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        pinchZoomHandler = PinchZoomHandler(usingSourceImageView: self)
    }
    

    
}

protocol ZoomingDelegate: AnyObject {
    func pinchZoomHandlerStartPinching()
    func pinchZoomHandlerEndPinching()
}

struct PinchZoomHandlerConstants {
    static let kMinZoomScaleDefaultValue: CGFloat = 1.0
    static let kMaxZoomScaleDefaultValue: CGFloat = 3.0
    static let kResetAnimationDurationDefaultValue = 0.3
    static let kIsZoomingActiveDefaultValue: Bool = false
}

class PinchZoomHandler {
    var minZoomScale: CGFloat = PinchZoomHandlerConstants.kMinZoomScaleDefaultValue
    var maxZoomScale: CGFloat = PinchZoomHandlerConstants.kMaxZoomScaleDefaultValue
    var resetAnimationDuration = PinchZoomHandlerConstants.kResetAnimationDurationDefaultValue
    var isZoomingActive: Bool = PinchZoomHandlerConstants.kIsZoomingActiveDefaultValue
    weak var delegate: ZoomingDelegate?
    weak var sourceImageView: UIImageView?
    
    private var zoomImageView: UIImageView = UIImageView()
    private var initialRect: CGRect = CGRect.zero
    private var zoomImageLastPosition: CGPoint = CGPoint.zero
    private var lastTouchPoint: CGPoint = CGPoint.zero
    private var lastNumberOfTouch: Int?
    
    init(usingSourceImageView sourceImageView: UIImageView) {
        self.sourceImageView = sourceImageView
        
        setupPinchGesture(on: sourceImageView)
    }
    
    func setupPinchGesture(on pinchContainer: UIView) {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(pinch:)))
        pinchGesture.cancelsTouchesInView = false
        pinchContainer.isUserInteractionEnabled = true
        pinchContainer.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handlePinchGesture(pinch: UIPinchGestureRecognizer) {
        guard let pinchableImageView = sourceImageView else { return }
        handlePinchMovement(pinchGesture: pinch, sourceImageView: pinchableImageView)
    }
    
    func handlePinchMovement(pinchGesture: UIPinchGestureRecognizer, sourceImageView: UIImageView) {
        switch pinchGesture.state {
        case .began:
        
            guard !isZoomingActive, pinchGesture.scale >= minZoomScale else { return }
            
            guard let point = sourceImageView.superview?.convert(sourceImageView.frame.origin, to: nil) else { return }
            initialRect = CGRect(x: point.x, y: point.y, width: sourceImageView.frame.size.width, height: sourceImageView.frame.size.height)
            
            lastTouchPoint = pinchGesture.location(in: sourceImageView)
            
            zoomImageView = UIImageView(image: sourceImageView.image)
            zoomImageView.contentMode = sourceImageView.contentMode
            zoomImageView.frame = initialRect

            let anchorPoint = CGPoint(x: lastTouchPoint.x/initialRect.size.width, y: lastTouchPoint.y/initialRect.size.height)
            zoomImageView.layer.anchorPoint = anchorPoint
            zoomImageView.center = lastTouchPoint
            zoomImageView.frame = initialRect
            
            sourceImageView.alpha = 0.0
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.addSubview(zoomImageView)
            
            zoomImageLastPosition = zoomImageView.center
            
            self.delegate?.pinchZoomHandlerStartPinching()
            
            isZoomingActive = true
            lastNumberOfTouch = pinchGesture.numberOfTouches
            
        case .changed:
            let isNumberOfTouchChanged = pinchGesture.numberOfTouches != lastNumberOfTouch
            
            if isNumberOfTouchChanged {
                let newTouchPoint = pinchGesture.location(in: sourceImageView)
                lastTouchPoint = newTouchPoint
            }
            
            let scale = zoomImageView.frame.size.width / initialRect.size.width
            let newScale = scale * pinchGesture.scale
            
            if scale.isNaN || scale == CGFloat.infinity || CGFloat.nan == initialRect.size.width {
                return
            }

            zoomImageView.frame = CGRect(x: zoomImageView.frame.origin.x,
                                         y: zoomImageView.frame.origin.y,
                                         width: min(max(initialRect.size.width * newScale, initialRect.size.width * minZoomScale), initialRect.size.width * maxZoomScale),
                                         height: min(max(initialRect.size.height * newScale, initialRect.size.height * minZoomScale), initialRect.size.height * maxZoomScale))
            
            let centerXDif = lastTouchPoint.x - pinchGesture.location(in: sourceImageView).x
            let centerYDif = lastTouchPoint.y - pinchGesture.location(in: sourceImageView).y
            
            zoomImageView.center = CGPoint(x: zoomImageLastPosition.x - centerXDif, y: zoomImageLastPosition.y - centerYDif)
            pinchGesture.scale = 1.0
            
            // Store last values
            lastNumberOfTouch = pinchGesture.numberOfTouches
            zoomImageLastPosition = zoomImageView.center
            lastTouchPoint = pinchGesture.location(in: sourceImageView)
            
        case .ended, .cancelled, .failed:
            resetZoom()
        default:
            break
        }
    }
    
    func resetZoom() {
        UIView.animate(withDuration: resetAnimationDuration, animations: {
            self.zoomImageView.frame = self.initialRect
        }) { _ in
            self.zoomImageView.removeFromSuperview()
            self.sourceImageView?.alpha = 1.0
            self.initialRect = .zero
            self.lastTouchPoint = .zero
            self.isZoomingActive = false
            self.delegate?.pinchZoomHandlerEndPinching()
        }
    }
}
