//
//  ViewController.m
//  CutVideo
//
//  Created by 项羽 on 17/5/17.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "ViewController.h"
#import "VideoClipView.h"

@interface ViewController ()

@property (nonatomic,strong)VideoClipView *vcView;
@property (nonatomic,strong)NSMutableArray *imgs;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self vcView];
}
-(VideoClipView *)vcView{
    
    if (!_vcView) {
        _vcView = [[VideoClipView alloc] init];
        _vcView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width,200);
        [self.view addSubview:_vcView];
    }
    return _vcView;
}



- (IBAction)cutAction {
    
    _vcView.imges = self.imgs;
    
    self.vcView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint center = self.vcView.center;
        center.y -= 200;
        self.vcView.center = center;
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - getter
-(NSMutableArray *)imgs{
    if (!_imgs) {
        _imgs = [NSMutableArray arrayWithCapacity:10];
        for (int i=0; i<20; i++) {
            UIImage *img = [UIImage imageNamed:@"111"];
            [_imgs addObject:img];
        }
    }
    return _imgs;
}

@end
