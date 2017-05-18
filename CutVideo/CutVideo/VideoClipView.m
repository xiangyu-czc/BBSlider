//
//  VideoClipView.m
//  CutVideo
//
//  Created by 项羽 on 17/5/17.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "VideoClipView.h"
#import "UIView+Frame.h"
#import <Foundation/Foundation.h>

//设置rgb颜色
#define VC_RGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define VC_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width


@interface VideoClipView()

@property (weak, nonatomic) IBOutlet UIView *thumbnailView;
@property (nonatomic,strong)NSMutableArray *imgViews;

//about slider
@property (nonatomic,strong)UIView *sliderView;
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIView *rightView;
@property (nonatomic,strong)UIImageView *leftBtn;
@property (nonatomic,strong)UIImageView *rightBtn;

@end

@implementation VideoClipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    for (int i=0; i<20; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(i*45, 0, 45, 45);
        [self.thumbnailView addSubview:imgView];
        [self.imgViews addObject:imgView];
    }
    
    CGFloat sliderViewWidth = 150;
    CGFloat leftBtnWidth = 12;
    CGFloat leftViewWidth = (VC_SCREEN_WIDTH - 150)/2;
    
    self.leftView = [[UIView alloc] init];
    self.leftView.backgroundColor = VC_RGBA(48, 48, 48, 0.8);
    self.leftView.frame = CGRectMake(0, 0, leftViewWidth, 45);
    [self.thumbnailView addSubview:self.leftView];
    self.leftView.backgroundColor = [UIColor redColor];
    
    
    self.leftBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_trimright"]];
    self.leftBtn.userInteractionEnabled = YES;
    self.leftBtn.frame = CGRectMake(leftViewWidth, 0, leftBtnWidth, 45);
    [self.thumbnailView addSubview:self.leftBtn];
    UIPanGestureRecognizer *leftPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnAct:)];
    [self.leftBtn addGestureRecognizer:leftPanGes];
    
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = VC_RGBA(48, 48, 48, 0.0);
    self.sliderView.frame = CGRectMake(leftViewWidth+leftBtnWidth, 0, sliderViewWidth, 45);
    [self.thumbnailView addSubview:self.sliderView];
    self.sliderView.backgroundColor = [UIColor greenColor];
    
    
    self.rightBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_trimleft"]];
    self.rightBtn.userInteractionEnabled = YES;
    self.rightBtn.frame = CGRectMake(leftViewWidth+leftBtnWidth+sliderViewWidth, 0, leftBtnWidth, 45);
    [self.thumbnailView addSubview:self.rightBtn];
    UIPanGestureRecognizer *rightPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnAct:)];
    [self.rightBtn addGestureRecognizer:rightPanGes];
    
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = VC_RGBA(48, 48, 48, 0.8);
    self.rightView.frame = CGRectMake(leftViewWidth+leftBtnWidth*2+sliderViewWidth, 0, leftViewWidth, 45);
    [self.thumbnailView addSubview:self.rightView];
    self.rightView.backgroundColor = [UIColor orangeColor];
    
}

#pragma mark - setter && getter

-(void)setImges:(NSMutableArray *)imges{
    for (int i=0;i<imges.count;i++) {
        UIImageView *imgView = self.imgViews[i];
        UIImage *img = imges[i];
        imgView.image = img;
    }
}


-(NSMutableArray *)imgViews{
    if (!_imgViews) {
        _imgViews = [NSMutableArray arrayWithCapacity:5];
    }
    return _imgViews;
}

#pragma mark - my method
- (IBAction)closeAct {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.closeHander) {
            self.closeHander();
        }
        CGPoint center = self.center;
        center.y += 200;
        self.center = center;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
    
}

- (IBAction)confirm {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (self.confirmHander) {
            self.confirmHander();
        }
        CGPoint center = self.center;
        center.y += 200;
        self.center = center;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


- (IBAction)oneClip {
    
    
}


- (IBAction)twoClip {
    
    
}

-(void)leftBtnAct:(UIPanGestureRecognizer *)pan{
    

    [pan.view.superview bringSubviewToFront:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
    
        CGPoint translation = [pan translationInView:pan.view.superview];
        CGPoint newCenter = (CGPoint){pan.view.center.x + translation.x, pan.view.center.y};
        newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
        newCenter.x = MIN(self.rightBtn.maxX - pan.view.frame.size.width/2,newCenter.x);
        [pan.view setCenter:newCenter];
        [pan setTranslation:CGPointZero inView:self.thumbnailView];
        
        
        self.leftView.width = self.leftBtn.frame.origin.x;
        self.leftView.originX = 0;
        self.sliderView.originX = pan.view.maxX;
        self.sliderView.width = self.rightBtn.originX - pan.view.maxX;
        
        
    }
}

-(void)rightBtnAct:(UIPanGestureRecognizer *)pan{
    
    [pan.view.superview bringSubviewToFront:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:pan.view.superview];
        CGPoint newCenter = (CGPoint){pan.view.center.x + translation.x, pan.view.center.y};
        newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
        newCenter.x = MIN((VC_SCREEN_WIDTH - self.leftBtn.width) - pan.view.frame.size.width/2,newCenter.x);
        [pan.view setCenter:newCenter];
        [pan setTranslation:CGPointZero inView:pan.view.superview];
        
        
        self.rightView.width = VC_SCREEN_WIDTH - pan.view.maxX;
        self.rightView.originX = self.rightBtn.maxX;
        self.sliderView.width = self.rightBtn.originX - self.leftBtn.maxX;
        self.sliderView.originX = self.leftBtn.maxX;
        
    }
}






@end















