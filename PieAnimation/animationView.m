#import "animationView.h"

@interface animationView ()

@property (nonatomic, strong) CAShapeLayer *boxShape;    //空心的黑色方块
@property (nonatomic, strong) CAShapeLayer *circleShape; //表示进度的圆形

@end


@implementation animationView

#pragma mark 重写初始化, 完成黑色方块, 进度圆形的设置
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //绘制黑色方块的外部曲线 及 内部圆形的空心曲线
        UIBezierPath *innerRoundPath = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                      radius:self.bounds.size.width * 0.8f / 2
                                                                  startAngle:0.0
                                                                    endAngle:M_PI * 2
                                                                   clockwise:YES];
        
        UIBezierPath *outerBoxPath = [UIBezierPath bezierPathWithRect:self.bounds];
        
        [outerBoxPath appendPath:innerRoundPath];

        //渲染出空心的黑色方块
        self.boxShape             = [CAShapeLayer layer];
        self.boxShape.frame       = self.bounds;
        self.boxShape.path        = outerBoxPath.CGPath;
        self.boxShape.fillRule    = kCAFillRuleEvenOdd;
        self.boxShape.fillColor   = [UIColor blackColor].CGColor;
        self.boxShape.strokeColor = [UIColor clearColor].CGColor;
        self.boxShape.lineWidth   = 0;
        
        //绘制进度圆形的曲线并渲染, 设置初始的进度值
        UIBezierPath *circlePath     = [UIBezierPath bezierPathWithArcCenter:self.center
                                                                      radius:self.bounds.size.width * 0.35f /2
                                                                  startAngle:M_PI * (- 0.5)
                                                                    endAngle:M_PI * (  1.5)
                                                                   clockwise:YES];
        self.circleShape             = [CAShapeLayer layer];
        self.circleShape.path        = circlePath.CGPath;
        self.circleShape.fillColor   = [UIColor clearColor].CGColor;
        self.circleShape.strokeColor = [UIColor blackColor].CGColor;
        self.circleShape.lineWidth   = self.bounds.size.width * 0.35f;
        self.circleShape.strokeStart = 0.f;
        self.circleShape.strokeEnd   = 1.f;
        
        //设置整体 view 的透明度, 并提交给本 view 的layer
        self.alpha = 0.5f;
        [self.layer addSublayer :self.boxShape];
        [self.layer addSublayer :self.circleShape];
    }
    return self;
}

#pragma mark 重写进度值的 setter, getter 方法, 设置进度
@synthesize progressValue = _progressValue;
-(void)setProgressValue :(CGFloat)progressValue{
 
    _progressValue               = progressValue;
    self.circleShape.strokeStart = progressValue;
    
    //当进度条达到1的时候(即进度实现了100%)
    if (_progressValue == 1.f) {

        //设置收尾的放大动画
        CABasicAnimation *scaleAnimation   = [CABasicAnimation animation];
        scaleAnimation.keyPath             = @"transform.scale";
        scaleAnimation.toValue             = @3.f;
        scaleAnimation.duration            = 0.5f;
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode            = kCAFillModeForwards;
        
        //提交给 boxShape
        [self.boxShape addAnimation:scaleAnimation forKey:nil];
        
    } else {
        
        //如果进度还没有到100%, 就去掉这个收尾动画及效果
        [self.boxShape removeAllAnimations];
        
    }
    
}
-(CGFloat)progressValue{
    return _progressValue;
}

@end
