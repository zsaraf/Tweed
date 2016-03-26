//
//  FollowViewController.swift
//  Tweed
//
//  Created by Zachary Saraf on 3/26/16.
//  Copyright © 2016 Zachary Saraf. All rights reserved.
//

import UIKit

class FollowViewController: UIViewController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    let blurredImage: UIImage

    init(blurredImage: UIImage) {
        self.blurredImage = blurredImage

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupBackgroundView()

        let textField = TweedTextField(frame: CGRectZero, icon: UIImage(named: "email_gray")!)
        self.view.addSubview(textField)

        textField.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(self.view).multipliedBy(0.7)
            make.center.equalTo(self.view)
        }
    }

    func setupBackgroundView() {
        let blurredImageView = UIImageView(image: self.blurredImage)
        self.view.addSubview(blurredImageView)

        let tweedPatternView = UIView()
        tweedPatternView.alpha = 0.4
        tweedPatternView.backgroundColor = UIColor(patternImage: UIImage(named: "tweed_texture")!)
        self.view.addSubview(tweedPatternView)

        blurredImageView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }

        tweedPatternView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }

    // MARK: UIViewControllerAnimatedTransitioning

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)

        if toVC is FollowViewController {
            let fvc = toVC as! FollowViewController

            fvc.view.alpha = 0.0
            transitionContext.containerView()?.addSubview(fvc.view)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fvc.view.alpha = 1.0
            }, completion: { (success: Bool) -> Void in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                fromVC?.view.alpha = 0.0
            }, completion: { (success: Bool) -> Void in
                transitionContext.completeTransition(true)
            })
        }
    }

//    #pragma mark - UIViewControllerAnimatedTransitioning
//
//    - (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
//    {
//    return self;
//    }
//
//    - (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
//    {
//    return self;
//    }
//
//    - (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
//    return .5f;
//}
//
//- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
//    // Grab the from and to view controllers from the context
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
//    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
//
//    if ([toViewController isKindOfClass:[self class]]) {
//        toViewController.view.alpha = 0.0;
//        [transitionContext.containerView addSubview:toViewController.view];
//
//        SeshFlowViewController *vc = (SeshFlowViewController *)toViewController;
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//            vc.view.alpha = 1.0;
//            } completion:^(BOOL finished) {
//            [transitionContext completeTransition:YES];
//            }];
//
//        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
//        animation.toValue = @(_topBarView.frame.size.height/2 + 10.0);
//        animation.springBounciness = 2.0;
//        animation.springSpeed = 2.0;
//        animation.beginTime = .2;
//        [_topBarView.layer pop_addAnimation:animation forKey:@"topBarViewAnimation"];
//
//        POPSpringAnimation *textFieldAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPScrollViewContentOffset];
//        textFieldAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
//        textFieldAnimation.springBounciness = 5.0;
//        textFieldAnimation.springSpeed = 5.0;
//        textFieldAnimation.beginTime = .2;
//        textFieldAnimation.completionBlock = ^(POPAnimation *anim, BOOL completed) {
//            [[self _viewForProgress:self.currentProgress] setEnabled:YES];
//        };
//        [_contentScrollView pop_addAnimation:textFieldAnimation forKey:@"textFieldAnimation"];
//    } else {
//        // This is a hacky fix for an iOS 8 bug with animated transitioning. TODO: convert this back to typical way of implementing this.
//
//        //        [[UIApplication sharedApplication].keyWindow addSubview:toViewController.view];
//        //        [[UIApplication sharedApplication].keyWindow addSubview:fromViewController.view];
//
//        //        [transitionContext.containerView addSubview:toViewController.view];
//        //        [transitionContext.containerView bringSubviewToFront:fromViewController.view];
//
//        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//            fromViewController.view.alpha = 0.0;
//            } completion:^(BOOL finished) {
//            [transitionContext completeTransition:YES];
//            }];
//    }
//}

}
