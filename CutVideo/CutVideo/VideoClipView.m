//
//  VideoClipView.m
//  CutVideo
//
//  Created by 项羽 on 17/5/17.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import "VideoClipView.h"

@interface VideoClipView()

@property (weak, nonatomic) IBOutlet UIView *thumbnailView;
@property (nonatomic,strong)NSMutableArray *imgViews;

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
}

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



@end
