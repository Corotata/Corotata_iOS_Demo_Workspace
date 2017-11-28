//
//  ViewController.swift
//  00003-ScrollView_Zoom
//
//  Created by Corotata on 2017/11/27.
//  Copyright © 2017年 Corotata. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        imageView.frame.size = (imageView.image?.size)!
        setZoomParametersForSize(scrollView.bounds.size)
        moveToCenter()
        
    }
    
    
    func setZoomParametersForSize(_ scrollViewSize: CGSize) {
        //这里需要注意的是，此次imageSize的取值是imageView.bounds.size，而非imageView.frame.size，
        //原因为scrollView的缩放会影响frame的值而bounds则不受影响
        let imageSize = imageView.bounds.size
        
        let heightScale = scrollViewSize.height / imageSize.height
        let widthScale = scrollViewSize.width / imageSize.width
        let minScale = min(heightScale, widthScale)
        
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    func moveToCenter() {
        let scrollViewSize = scrollView.bounds.size
        
        //此处因为需要关注当前view的实际高度，所以需要取frame
        let imageViewSize = imageView.frame.size
        
        let horizontalSpace = scrollViewSize.width > imageViewSize.width ? (scrollViewSize.width - imageViewSize.width)/2 : 0
        let verticalSpace = scrollViewSize.height > imageViewSize.height ? (scrollViewSize.height - imageViewSize.height)/2 : 0
        
        
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setZoomParametersForSize(scrollView.bounds.size)
        moveToCenter()
    }
}




extension ViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
}



