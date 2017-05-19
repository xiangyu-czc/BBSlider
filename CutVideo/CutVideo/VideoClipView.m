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

//@property (weak, nonatomic) IBOutlet UIView *thumbnailView;

@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailView;
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
    
    
    self.thumbnailView.delegate = self;
    self.thumbnailView.dataSource = self;
    [self.thumbnailView registerClass:[ThumCell class] forCellWithReuseIdentifier:@"cell"];
    
    
    
    
//    for (int i=0; i<20; i++) {
//        UIImageView *imgView = [[UIImageView alloc] init];
//        imgView.frame = CGRectMake(i*45, 0, 45, 45);
//        [self.thumbnailView addSubview:imgView];
//        [self.imgViews addObject:imgView];
//    }
    
//    UIView *thumContentView = [[UIView alloc] initWithFrame:self.thumbnailView.bounds];
//    thumContentView.backgroundColor = [UIColor blueColor];
//    [self.thumbnailView addSubview:thumContentView];
    
//    CGFloat sliderViewWidth = 150;
//    CGFloat leftBtnWidth = 12;
//    CGFloat leftViewWidth = (VC_SCREEN_WIDTH - 150)/2;
//    
//    self.leftView = [[UIView alloc] init];
//    self.leftView.backgroundColor = VC_RGBA(48, 48, 48, 0.8);
//    self.leftView.frame = CGRectMake(0, 0, leftViewWidth, 45);
//    [thumContentView addSubview:self.leftView];
//    self.leftView.backgroundColor = [UIColor redColor];
//    
//    
//    self.leftBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_trimright"]];
//    self.leftBtn.userInteractionEnabled = YES;
//    self.leftBtn.frame = CGRectMake(leftViewWidth, 0, leftBtnWidth, 45);
//    [thumContentView addSubview:self.leftBtn];
//    UIPanGestureRecognizer *leftPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftBtnAct:)];
//    [self.leftBtn addGestureRecognizer:leftPanGes];
//    
//    
//    self.sliderView = [[UIView alloc] init];
//    self.sliderView.backgroundColor = VC_RGBA(48, 48, 48, 0.0);
//    self.sliderView.frame = CGRectMake(leftViewWidth+leftBtnWidth, 0, sliderViewWidth, 45);
//    [thumContentView addSubview:self.sliderView];
//    self.sliderView.backgroundColor = [UIColor greenColor];
//    
//    
//    self.rightBtn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_trimleft"]];
//    self.rightBtn.userInteractionEnabled = YES;
//    self.rightBtn.frame = CGRectMake(leftViewWidth+leftBtnWidth+sliderViewWidth, 0, leftBtnWidth, 45);
//    [thumContentView addSubview:self.rightBtn];
//    UIPanGestureRecognizer *rightPanGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnAct:)];
//    [self.rightBtn addGestureRecognizer:rightPanGes];
//    
//    
//    self.rightView = [[UIView alloc] init];
//    self.rightView.backgroundColor = VC_RGBA(48, 48, 48, 0.8);
//    self.rightView.frame = CGRectMake(leftViewWidth+leftBtnWidth*2+sliderViewWidth, 0, leftViewWidth, 45);
//    [thumContentView addSubview:self.rightView];
//    self.rightView.backgroundColor = [UIColor orangeColor];
    
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
//        newCenter.x = MAX(pan.view.frame.size.width/2, newCenter.x);
//        newCenter.x = MIN((VC_SCREEN_WIDTH - self.leftBtn.maxX) - pan.view.frame.size.width/2,newCenter.x);
        [pan.view setCenter:newCenter];
        [pan setTranslation:CGPointZero inView:pan.view.superview];
        
        
        self.rightView.width = VC_SCREEN_WIDTH - pan.view.maxX;
        self.rightView.originX = self.rightBtn.maxX;
        self.sliderView.width = self.rightBtn.originX - self.leftBtn.maxX;
        self.sliderView.originX = self.leftBtn.maxX;
        
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








