//
//  VideoClipView.m
//  CutVideo
//
//  Created by 项羽 on 17/5/17.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "VideoClipView.h"

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
@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;

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
    
    
    self.leftBtn = [[UIButton alloc] init];
    [self.leftBtn setImage:[UIImage imageNamed:@"btn_trimright"] forState:UIControlStateNormal];
    self.leftBtn.frame = CGRectMake(leftViewWidth, 0, leftBtnWidth, 45);
    [self.thumbnailView addSubview:self.leftBtn];
    
    
    self.sliderView = [[UIView alloc] init];
    self.sliderView.backgroundColor = VC_RGBA(48, 48, 48, 0.0);
    self.sliderView.frame = CGRectMake(leftViewWidth+leftBtnWidth, 0, sliderViewWidth, 45);
    [self.thumbnailView addSubview:self.sliderView];
    
    
    self.rightBtn = [[UIButton alloc] init];
    [self.rightBtn setImage:[UIImage imageNamed:@"btn_trimleft"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(leftViewWidth+leftBtnWidth+sliderViewWidth, 0, leftBtnWidth, 45);
    [self.thumbnailView addSubview:self.rightBtn];
    
    
    self.rightView = [[UIView alloc] init];
    self.rightView.backgroundColor = VC_RGBA(48, 48, 48, 0.8);
    self.rightView.frame = CGRectMake(leftViewWidth+leftBtnWidth*2+sliderViewWidth, 0, leftViewWidth, 45);
    [self.thumbnailView addSubview:self.rightView];
    
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


@end















