//
//  SecondViewController.m
//  CircleTransition
//
//  Created by 224 on 15/12/31.
//  Copyright © 2015年 zoomlgd. All rights reserved.
//

#import "SecondViewController.h"
#import "PingInverseTransition.h"
#import "ViewController.h"

@interface SecondViewController ()<UINavigationControllerDelegate>

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *percentTransition;

@end

@implementation SecondViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"第二个";
    
    UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    edgePanGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePanGestureRecognizer];
}

- (void)panGesture:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].x / self.view.bounds.size.width;
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.percentTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case UIGestureRecognizerStateChanged:{
            [self.percentTransition updateInteractiveTransition:progress];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            if (progress >= 0.5) {
                [self.percentTransition finishInteractiveTransition];
            }else {
                [self.percentTransition cancelInteractiveTransition];
            }
            self.percentTransition = nil;
            break;
        default:
            break;
    }
}

#pragma mark - <UINavigationControllerDelegate>

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        PingInverseTransition *transition = [[PingInverseTransition alloc] init];
        return transition;
    }else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.percentTransition;
}

- (IBAction)popClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
