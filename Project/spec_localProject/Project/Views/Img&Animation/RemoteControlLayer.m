//
//  RemoteControlLayer.m
//  spec_localProject
//
//  Created by Little.Daddly on 2020/2/8.
//  Copyright © 2020 Little.Daddly. All rights reserved.
//

#import "RemoteControlLayer.h"
#define kRemoteSize 884/2.
@interface RemoteControlLayer()
@property (nonatomic,strong)NSDictionary *layersData;
@property (nonatomic,strong)UIImageView *bgImgv;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)CAShapeLayer *cur_layer;

@end

@implementation RemoteControlLayer

- (instancetype)init{
    if (self != [super init]) {return nil;}
    self.bounds = CGRectMake(0, 0, kRemoteSize, kRemoteSize);
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.bgView];
    _bgImgv = [UIImageView new];
    UIImage *img = [UIImage imageNamed:@"remote"];
    
    _bgImgv.image = img;
    [self insertSubview:_bgImgv belowSubview:self.bgView];
    _bgImgv.frame = self.bounds;
    
    NSMutableDictionary *temp = NSMutableDictionary.dictionary;
    CGPoint center_p = CGPointMake(kRemoteSize / 2., kRemoteSize / 2);
    CGFloat okRadius = kRemoteSize / 4;
    
    void (^ b)(CGFloat startAngle, CGFloat endAngle,RemoteControlType t,BOOL clock) = ^ (CGFloat startAngle, CGFloat endAngle, RemoteControlType t,BOOL clock){
        
        UIBezierPath *p = [UIBezierPath bezierPath];
        [p addArcWithCenter:center_p radius:okRadius startAngle:startAngle/180*M_PI endAngle:endAngle/180*M_PI clockwise:clock];

        if (t == RemoteControlTypeUp) {
            [p addLineToPoint:CGPointZero];
            [p addLineToPoint:CGPointMake(kRemoteSize, 0)];
            
        } else if (t == RemoteControlTypeLeft) {
            [p addLineToPoint:CGPointZero];
            [p addLineToPoint:CGPointMake(0, kRemoteSize)];
        } else if ( t == RemoteControlTypeRight) {
            [p addLineToPoint:CGPointMake(kRemoteSize, kRemoteSize)];
            [p addLineToPoint:CGPointMake(kRemoteSize, 0)];
        } else {
            [p addLineToPoint:CGPointMake(0, kRemoteSize)];
            [p addLineToPoint:CGPointMake(kRemoteSize, kRemoteSize)];
        }
         
        [p closePath];
        CAShapeLayer *layer = CAShapeLayer.layer;
        layer.path = p.CGPath;
//        layer.fillColor = [UIColor union_colorWithR:15 *t G:15 *t B:15 *t].CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.frame = self.bounds;
        [self.bgView.layer addSublayer:layer];;
        [temp setValue:layer forKey:F(@"%lu",(unsigned long)t)];
    };
    
    // up   45 - 90  - 135
    b(-45,-135,RemoteControlTypeUp,NO);
    // legt 135 - 180 - 225
    b(135,-135,RemoteControlTypeLeft,YES);
//    // right 315 -  0 - 45
    b(-45,45,RemoteControlTypeRight,YES);
//    // down 225 - 315
    b(45,135,RemoteControlTypeDown,YES);
    // Ok circle
    UIBezierPath *p = [UIBezierPath bezierPath];
    [p addArcWithCenter:center_p radius:okRadius startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [p closePath];

    CAShapeLayer *layer = CAShapeLayer.layer;
    layer.path = p.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor clearColor].CGColor;
    //[UIColor colorWithWhite:0 alpha:0.].CGColor;
   layer.frame = self.bounds;
   [self.bgView.layer addSublayer:layer];;
   [temp setValue:layer forKey:F(@"%lu",(unsigned long)RemoteControlTypeOk)];
    _layersData = temp.copy;
    
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(press:)];
    press.minimumPressDuration = 0.05;
    [self addGestureRecognizer:press];
    return self;
}

- (void)press:(UILongPressGestureRecognizer *)press{
    static BOOL beginAni = NO;
    CGPoint touch = [press locationInView:self];
    CGPoint center_p = CGPointMake(kRemoteSize / 2., kRemoteSize / 2);
    CGFloat dis = hypot(fabs(touch.x - center_p.x), fabs(touch.y - center_p.y));
    
    CAShapeLayer * (^ b ) (RemoteControlType key) = ^ (RemoteControlType key) {
        CAShapeLayer *layer = _layersData[F(@"%lu",(unsigned long)key)];
        layer.fillColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
        return layer;
    };
    
    switch (press.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (beginAni) {
                break;
            }
            RemoteControlType type;
            if (dis < kRemoteSize / 4) { // ok
                type = RemoteControlTypeOk;
              } else {
                  BOOL Y = touch.y - center_p.y>0?YES:NO;
                  //-PI/2, PI/2
                  CGFloat angle = asin((touch.y - center_p.y)/dis);
                  CGFloat direction = (touch.x - center_p.x) > 0 ? 1: -1;
                  angle *= direction;
                  if (!Y) {
                    
                      if ((angle <=-45/180.*M_PI && angle >= -90/180.*M_PI) ||
                          (angle >=45/180.*M_PI && angle <= 90/180.*M_PI)) { // up
                          type = RemoteControlTypeUp;
                      } else if (angle >=0 && angle < 45 / 180.*M_PI) {
                          type = RemoteControlTypeLeft;
                      } else {
                          type = RemoteControlTypeRight;
                      }
                  } else {
                      if ((angle <=-45/180.*M_PI && angle >= -90/180.*M_PI) ||
                          (angle >=45/180.*M_PI && angle <= 90/180.*M_PI)) { // up
                          type = RemoteControlTypeDown;
                      } else if (angle >=0 && angle < 45 / 180.*M_PI){
                          type = RemoteControlTypeRight;
                      } else {
                          type = RemoteControlTypeLeft;
                      }
                      
                  }
              }
           self.cur_layer = b(type);
        }
        case UIGestureRecognizerStateChanged:
        {
            if (beginAni) {
                break;
            }
            beginAni = YES;
            [UIView animateWithDuration:0.25 animations:^{
                self.cur_layer.fillColor = [UIColor colorWithWhite:0 alpha:0.75].CGColor;
            } completion:^(BOOL finished) {
                beginAni = NO;
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            beginAni = NO;
            [self.cur_layer removeAllAnimations];
            self.cur_layer.fillColor = [UIColor clearColor].CGColor;
        }
        default:
            break;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
