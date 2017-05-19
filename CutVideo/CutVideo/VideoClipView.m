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


@interface VideoClipView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>



@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailView;
@property (nonatomic,strong)NSMutableArray *imgViews;

@property (nonatomic,strong)UIView *theView;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,strong)CAGradientLayer *gradientLayer2;


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

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.theView.frame = self.thumbnailView.bounds;
    self.gradientLayer.frame = self.theView.bounds;
    self.gradientLayer2.frame = self.theView.bounds;
    
    //设置颜色分割点（范围：0-1）
    float p1 = 120/self.theView.width;
    self.gradientLayer.locations = @[@(p1), @(p1)];
    self.gradientLayer2.locations = @[@(1-p1), @(1-p1)];
    
    self.leftBtn.frame = CGRectMake(120, 0, 12, 45);
    self.rightBtn.frame = CGRectMake(self.thumbnailView.width-120-12, 0, 12, 45);
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    self.thumbnailView.delegate = self;
    self.thumbnailView.dataSource = self;
    [self.thumbnailView registerClass:[ThumCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    //初始化我们需要改变背景色的UIView，并添加在视图上
    self.theView = [[UIView alloc] init];
    [self.thumbnailView addSubview:self.theView];
    
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.actions = @{@"locations":[NSNull null]};
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    self.gradientLayer.colors = @[(__bridge id)VC_RGBA(48, 48, 48, 0.8).CGColor,
                                  (__bridge id)VC_RGBA(48, 48, 48, 0.0).CGColor,
                                  ];
    [self.theView.layer addSublayer:self.gradientLayer];
    
    self.gradientLayer2 = [CAGradientLayer layer];
    self.gradientLayer2.actions = @{@"locations":[NSNull null]};
    self.gradientLayer2.startPoint = CGPointMake(0, 0);
    self.gradientLayer2.endPoint = CGPointMake(1, 0);
    self.gradientLayer2.colors = @[(__bridge id)VC_RGBA(48, 48, 48, 0.0).CGColor,
                                   (__bridge id)VC_RGBA(48, 48, 48, 0.8).CGColor,
                                   ];
    [self.theView.layer addSublayer:self.gradientLayer2];
    
    
    
   
    
    
    
    
    

    self.leftBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_trimright"]];
    self.leftBtn.userInteractionEnabled = YES;
    [self.theView addSubview:self.leftBtn];
    UIPanGestureRecognizer *leftPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnAct:)];
    [self.leftBtn addGestureRecognizer:leftPanGes];

    
    self.rightBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_trimleft"]];
    self.rightBtn.userInteractionEnabled = YES;
    [self.thumbnailView addSubview:self.rightBtn];
    UIPanGestureRecognizer *rightPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnAct:)];
    [self.rightBtn addGestureRecognizer:rightPanGes];

    
}

#pragma mark - setter && getter

-(void)setImges:(NSMutableArray *)imges{
    
    _imges = imges;
    [self.thumbnailView reloadData];
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
        newCenter.x = MIN(self.rightBtn.originX - pan.view.frame.size.width/2,newCenter.x);
//        [CATransaction begin];
//        [CATransaction setDisableActions:YES];
        float f = (newCenter.x/self.thumbnailView.width)/1.0;
        self.gradientLayer.locations = @[@(f), @(f)];
        [pan.view setCenter:newCenter];
        [pan setTranslation:CGPointZero inView:self.thumbnailView];
//        [CATransaction commit];
        
     
        
        
    }
}

-(void)rightBtnAct:(UIPanGestureRecognizer *)pan{
    
    [pan.view.superview bringSubviewToFront:pan.view];
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:pan.view.superview];
        CGPoint newCenter = (CGPoint){pan.view.center.x + translation.x, pan.view.center.y};
        newCenter.x = MAX(MIN(newCenter.x, self.thumbnailView.frame.size.width - pan.view.frame.size.width/2) , self.leftBtn.maxX +pan.view.frame.size.width/2);
        pan.view.center = newCenter;
        float f = (newCenter.x/self.thumbnailView.width)/1.0;
        self.gradientLayer2.locations = @[@(f), @(f)];
        [pan.view setCenter:newCenter];
        [pan setTranslation:CGPointZero inView:pan.view.superview];
        
    }
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.imges.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ThumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImage *img = self.imges[indexPath.item];
    cell.img = img;
    return cell;
}


@end





@interface ThumCell()

@property (nonatomic,strong)UIImageView *imgView;

@end
@implementation ThumCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}

-(void)setImg:(UIImage *)img{
    _img = img;
    self.imgView.image = img;
}

@end








