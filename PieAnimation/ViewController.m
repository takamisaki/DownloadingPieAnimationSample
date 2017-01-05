#import "ViewController.h"
#import "animationView.h"

@interface ViewController ()

@property (nonatomic, strong)        animationView *animationViewInstance; //动画 view
@property (nonatomic, weak  ) IBOutlet UIImageView *iconView;
@property (nonatomic, weak  ) IBOutlet UISlider    *processSlider; //提供 progressValue 的slider
@property (nonatomic, weak  ) IBOutlet UILabel     *textLabel; //文字"进度条"
@property (nonatomic, weak  ) IBOutlet UILabel     *appName; //显示下载状态或者 app name

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化显示图片的 iconView
    self.iconView.layer.cornerRadius  = 10; //设置圆角
    self.iconView.layer.masksToBounds = YES; //不显示 view 以外的 sublayer 部分
    //提交给 self.view
    [self.view addSubview:self.iconView];
    
    
    
    //初始化显示动画的 , 位置覆盖iconView
    self.animationViewInstance = [[animationView alloc] initWithFrame:self.iconView.bounds];
    //提交给iconView
    [self.iconView addSubview:self.animationViewInstance];
    
    
    //把动画 view 的 progressValue 和 slider 的 value 关联
    self.animationViewInstance.progressValue = self.processSlider.value;
    
    //为 slider 条件 action
    [self.processSlider addTarget:self
                           action:@selector(processChanged)
                 forControlEvents:UIControlEventValueChanged];
}

//设置 slider 滑动触发的 action, 同时根据 value 设定 label 的显示文字
-(void)processChanged{
    self.animationViewInstance.progressValue = self.processSlider.value;
    if (self.processSlider.value < 1.f) {
        self.appName.text = @"下载中";
    }else{
        self.appName.text = @"GTA 5";
    }
}

@end
