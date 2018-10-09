//
//  LWPageControl.h
//  spec_localProject
//
//  Created by Little.Daddly on 2018/10/9.
//  Copyright © 2018 Little.Daddly. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LWPageControlType) {
    LWPageControlTypeCircle,
    LWPageControlTypeSquare
};

@interface LWPageControl : UIView
@property (nonatomic,assign) LWPageControlType type;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,assign) NSInteger itemsPage;

@property (nonatomic,copy) UIColor *currentPageIndicatorColor;
@property (nonatomic,copy) UIColor *othersPageIndicatorColor;
@property (nonatomic,assign) CGSize sizeForPageIndicator;
@property (nonatomic,assign) CGFloat itemsPadding;
@end

