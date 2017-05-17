//
//  VideoClipView.h
//  CutVideo
//
//  Created by 项羽 on 17/5/17.
//  Copyright © 2017年 项羽. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CloseBtnBlock)();
typedef void(^ConfirmBtnBlock)();

@interface VideoClipView : UIView


/**
 关闭回调
 */
@property (nonatomic,copy)CloseBtnBlock closeHander;

/**
 确认回调
 */
@property (nonatomic,copy)ConfirmBtnBlock confirmHander;

/**
 缩略图数组
 */
@property (nonatomic,strong)NSMutableArray *imges;


@end
