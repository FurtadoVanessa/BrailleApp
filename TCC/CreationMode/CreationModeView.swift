import Cartography
import Foundation
import UIKit

protocol CreationModeViewProtocol {
    func updateImageView(with image: UIImage)
    func setupFurtherRight()
}

final class CreationModeView: UIView {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 6.0
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.flashScrollIndicators()
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.isUserInteractionEnabled = true
        image.clipsToBounds = false
        return image
    }()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)

        setupView()
        constrainView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        nil
    }
    
    private func setupView() {
        scrollView.addSubview(imageView)
        
        addSubview(scrollView)
        
        scrollView.delegate = self
    }
    
    private func constrainView() {
        constrain(self, scrollView, imageView) { superview, scroll, image in
            scroll.top == superview.top + 12
            scroll.leading == superview.leading + 12
            scroll.trailing == superview.trailing - 12
            scroll.bottom == superview.bottom - 12
            
            image.edges == scroll.edges
        }
    }
}

extension CreationModeView: CreationModeViewProtocol {
    func updateImageView(with image: UIImage) {
        imageView.image = image
        
        scrollView.setContentOffset(CGPoint(x: image.size.width * image.scale, y: 0), animated: true)
    }
    
    func setupFurtherRight() {
//        scrollView.contentOffset.x = imageView.frame.width/2
//        scrollView.contentOffset.y = imageView.frame.height
    }
}

extension CreationModeView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
