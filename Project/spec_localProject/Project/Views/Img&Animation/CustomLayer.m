//
//  CustomLayer.m
//  spec_localProject
//
//  Created by Little.Daddly on 2018/8/13.
//  Copyright © 2018年 Little.Daddly. All rights reserved.
//

#import "CustomLayer.h"
static inline CGFloat kDegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

@interface CustomLayer(){
        CGPoint _position;
}
@property (nonatomic,strong) UIImage *icon;
@property (nonatomic,copy) NSString *name;
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation CustomLayer
- (instancetype)initLayerType:(BGCustomLayerType)type
                     withInfo:(BGCustomLayerModel *)info {
    
    if (self = [super init]) {
        _type = type;
        _info = info;
        self.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpressAction:)];
        [self addGestureRecognizer:longpress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedAction:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.nameLabel];
        [self configure];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    if (self.info.direction == YES) {
        [self drawRightDirectionView];
    } else {
        [self drawLeftDirectionView];
    }
}

#pragma mark - Private Methods

- (void)drawRightDirectionView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    //从右开始，依次是小圆，两段圆弧，带圆角的矩形
    //图标和文字之间，有两段圆弧，这两段圆弧上下对称
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor un_colorWithHex:0x000000 alpha:0.8f].CGColor);
    
    //小圆的半径
    CGFloat xR = 9.5f;
    //小圆空缺的角度大小
    CGFloat xAngle = 44/2;
    //绘制小圆
    CGContextMoveToPoint(context, (width-xR), height/2);
    CGContextAddArc(context, (width-xR), height/2, xR, 0, M_PI * 2, NO);
    
    //两段圆弧的半径
    CGFloat yR = 8.0f;
    //圆弧横向顶点之间的距离
    CGFloat distance = 12.5f;
    //圆弧顶点的x坐标
    CGFloat xRight = (width-xR) - cos(kDegreesToRadians(xAngle)) * xR;
    CGFloat xLeft = xRight - distance;
    //圆弧顶点的y坐标
    CGFloat yTop = height/2 - sin(kDegreesToRadians(xAngle)) * xR;
    CGFloat yBottom = height/2 + sin(kDegreesToRadians(xAngle)) * xR;
    //圆弧中心的x坐标
    CGFloat xCenter = xLeft + distance/2;
    //上圆弧圆心的y坐标
    CGFloat yCenterTop = yTop - sqrt((yR*yR - (distance/2)*(distance/2)));
    //下圆弧圆心的y坐标
    CGFloat yCenterBottom = yBottom + sqrt((yR*yR - (distance/2)*(distance/2)));
    //绘制下圆弧所需的参照点的y坐标
    CGFloat yArcTop = yCenterBottom - yR / cos(asin((distance/2) / yR));
    //绘制上圆弧所需的参照点的y坐标
    CGFloat yArcBottom = yCenterTop + yR / cos(asin((distance/2) / yR));
    //从小圆的圆心开始，绘制下半圆弧
    CGContextMoveToPoint(context, (width-xR), height/2);
    CGContextAddLineToPoint(context, xRight, yBottom);
    CGContextAddArcToPoint(context, xCenter, yArcTop, xLeft, yBottom, yR);
    
    //矩形的圆角半径
    CGFloat zR = height / 2;
    //计算绘制矩形左边圆弧所需的参照点的x坐标
    CGFloat arcHeightSpace = yBottom - yTop;
    CGFloat radiansA = asin((arcHeightSpace/2)/zR);
    CGFloat extraSpaceToCenterZ = zR * cos(radiansA);
    CGFloat ratio = zR / (arcHeightSpace/2);
    CGFloat offset = extraSpaceToCenterZ / (1+ratio);
    CGFloat xArcLeft = xLeft - offset;
    //矩形左边圆角的圆心
    CGFloat centerZ = xLeft - extraSpaceToCenterZ;
    //绘制带圆角的矩形
    CGContextAddArcToPoint(context, xArcLeft, height, centerZ, height, zR);
    CGContextAddLineToPoint(context, zR, height);
    CGContextAddArcToPoint(context, 0, height, 0, zR, zR);
    CGContextAddArcToPoint(context, 0, 0, zR, 0, zR);
    CGContextAddLineToPoint(context, centerZ, 0);
    CGContextAddArcToPoint(context, xArcLeft, 0, xLeft, yTop, zR);
    
    //绘制上半圆弧
    CGContextAddArcToPoint(context, xCenter, yArcBottom, xRight, yTop, yR);
    //回到起始点
    CGContextAddLineToPoint(context, width-xR, height/2);
    //填充路径
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    if (self.icon) {
        CGSize iconSize = self.icon.size;
        [self.icon drawInRect:CGRectMake(width - (19.0f-iconSize.width)/2 - iconSize.width,
                                         (height - iconSize.height) / 2,
                                         iconSize.width,
                                         iconSize.height)];
    }
}

- (void)drawLeftDirectionView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    //从左开始，依次是小圆，两段圆弧，带圆角的矩形
    //图标和文字之间，有两段圆弧，这两段圆弧上下对称
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor un_colorWithHex:0x000000 alpha:0.8f].CGColor);
    
    //小圆的半径
    CGFloat xR = 9.5f;
    //小圆空缺的角度大小
    CGFloat xAngle = 44/2;
    //绘制小圆
    CGContextMoveToPoint(context, xR, height/2);
    CGContextAddArc(context, xR, height/2, xR, kDegreesToRadians(xAngle), -kDegreesToRadians(xAngle), NO);
    
    //两段圆弧的半径
    CGFloat yR = 8.0f;
    //圆弧横向顶点之间的距离
    CGFloat distance = 12.5f;
    //圆弧顶点的x坐标
    CGFloat xLeft = xR + cos(kDegreesToRadians(xAngle)) * xR;
    CGFloat xRight = xLeft + distance;
    //圆弧顶点的y坐标
    CGFloat yTop = height/2 - sin(kDegreesToRadians(xAngle)) * xR;
    CGFloat yBottom = height/2 + sin(kDegreesToRadians(xAngle)) * xR;
    //圆弧中心的x坐标
    CGFloat xCenter = xLeft + distance/2;
    //上圆弧圆心的y坐标
    CGFloat yCenterTop = yTop - sqrt((yR*yR - (distance/2)*(distance/2)));
    //下圆弧圆心的y坐标
    CGFloat yCenterBottom = yBottom + sqrt((yR*yR - (distance/2)*(distance/2)));
    //绘制下圆弧所需的参照点的y坐标
    CGFloat yArcTop = yCenterBottom - yR / cos(asin((distance/2) / yR));
    //绘制上圆弧所需的参照点的y坐标
    CGFloat yArcBottom = yCenterTop + yR / cos(asin((distance/2) / yR));
    //从小圆的圆心开始，绘制下半圆弧
    CGContextMoveToPoint(context, xR, height/2);
    CGContextAddLineToPoint(context, xLeft, yBottom);
    CGContextAddArcToPoint(context, xCenter, yArcTop, xRight, yBottom, yR);
    
    //矩形的圆角半径
    CGFloat zR = height/2;
    //计算绘制矩形左边圆弧所需的参照点的x坐标
    CGFloat arcHeightSpace = yBottom - yTop;
    CGFloat radiansA = asin((arcHeightSpace/2) / zR);
    CGFloat extraSpaceToCenterZ = zR * cos(radiansA);
    CGFloat ratio = zR / (arcHeightSpace/2);
    CGFloat offset = extraSpaceToCenterZ / (1+ratio);
    CGFloat xArcRight = xRight + offset;
    //矩形左边圆角的圆心
    CGFloat centerZ = xRight + extraSpaceToCenterZ;
    //绘制带圆角的矩形
    CGContextAddArcToPoint(context, xArcRight, height, centerZ, height, zR);
    CGContextAddLineToPoint(context, width-zR, height);
    CGContextAddArcToPoint(context, width, height, width, zR, zR);
    CGContextAddArcToPoint(context, width, 0, width-zR, 0, zR);
    CGContextAddLineToPoint(context, centerZ, 0);
    CGContextAddArcToPoint(context, xArcRight, 0, xRight, yTop, zR);
    
    //绘制上半圆弧
    CGContextAddArcToPoint(context, xCenter, yArcBottom, xLeft, yTop, yR);
    //回到起始点
    CGContextAddLineToPoint(context, xR, height/2);
    //填充路径
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    if (self.icon) {
        CGSize iconSize = self.icon.size;
        [self.icon drawInRect:CGRectMake((19.0f - iconSize.width) / 2,
                                         (height - iconSize.height) / 2,
                                         iconSize.width,
                                         iconSize.height)];
    }
}


#pragma mark - Action Event
- (void)longpressAction:(UILongPressGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.option) {
                self.option();
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)tapedAction:(UITapGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded:
        {
            self.info.direction = !self.info.direction;
            [self setNeedsDisplay];
            [self layoutSubviews];
        }
            break;
            
        default:
            break;
    }
}

- (CGSize)approximatelySize {
    CGSize size = [self.name union_stringSizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    
    if (size.width > (UNION_SCREEN_WIDTH/3*2 - 70)) {
        size.width = UNION_SCREEN_WIDTH/3*2 - 70;
    }
    
    CGFloat width = size.width + 46 + 14;
    CGFloat height = 31;
    
    return CGSizeMake(width, height);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.name union_stringSizeWithFont:[UIFont systemFontOfSize:14.0f] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    if (size.width > (UNION_SCREEN_WIDTH/3*2 - 70)) {
        size.width = UNION_SCREEN_WIDTH/3*2 - 70;
    }
    
    if (self.info.direction == YES) {
        self.nameLabel.frame = CGRectMake(14.0f,
                                          (self.bounds.size.height-size.height)/2,
                                          size.width,
                                          size.height);
    } else {
        self.nameLabel.frame = CGRectMake(self.bounds.size.width - 14.0f - size.width,
                                          (self.bounds.size.height - size.height) / 2,
                                          size.width,
                                          size.height);
    }
}

#pragma mark - TouchEvent
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject] ;
    _position = [touch locationInView:self.superview];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    CGPoint newCenter = CGPointMake(self.center.x + touch.x - _position.x,
                                    self.center.y + touch.y - _position.y) ;
    self.center = newCenter;
    
    CGSize contentSize = self.superview.bounds.size;
    
    if (self.union_x <= 0) {
        self.union_x = 0;
    }
    if (self.union_y <=0) {
        self.union_y = 0;
    }
    if (self.union_x + self.union_w >= contentSize.width) {
        self.union_x =  contentSize.width - self.union_w;
    }
    if (self.union_y + self.union_h >= contentSize.height) {
        self.union_y = contentSize.height - self.union_h;
    }
    _position = touch;
}

#pragma mark - Getter&Setter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    
    return _nameLabel;
}

- (void)configure {
    switch (_type) {
        case BGCustomLayerTypeSlider:
        {
            
        }
            break;
        case BGCustomLayerTypeProgressBar:
        {
            
        }
            break;
        case BGCustomLayerTypeTag:
        {
            self.name = self.info.name;
            self.icon = [UIImage imageNamed:@"bro_ic_location"];
        }
            break;
        default:
            break;
    }
    
    self.nameLabel.text = self.name;
}

@end



@implementation BGCustomLayerModel
@end
