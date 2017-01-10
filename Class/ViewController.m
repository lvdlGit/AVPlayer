//
//  ViewController.m
//  AVPlayer
//
//  Created by lvdl on 16/11/29.
//  Copyright © 2016年 www.palcw.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>


#define TopViewHeight 40
#define BottomViewHeight 65
#define mainWidth [UIScreen mainScreen].bounds.size.width
#define mainHeight [UIScreen mainScreen].bounds.size.height

#define MARGIN		5
#define LABEL_W		45
#define LABEL_H		20
#define CHOOSE		30

#define kRedColor               RGBA(255, 100, 100, 1)   // 红色
#define kRedColorAlpha(a)       RGBA(255, 100, 100, a)   // 红色

#define kGreenColor             RGBA(0, 200, 200, 1)     // 绿色
#define kGreenColorAlpha(a)     RGBA(0, 200, 200, a)     // 绿色

#define kLineColor              RGBA(220, 221, 221, 1)   // 分割线颜色
#define kLineColorAlpha(a)      RGBA(220, 221, 221, a)   // 分割线颜色


#define  RGBA(r, g, b, a)       [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]


@interface ViewController ()

//status bar
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UILabel *titleLabel;

//bottom bar
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic,strong)UISlider *movieProgressSlider;//进度条
@property (nonatomic, strong) UILabel *totleTime;

@property (nonatomic,assign)BOOL isPlay;
@property (nonatomic,assign)CGFloat ProgressBeginToMove;
@property (nonatomic,assign)CGFloat totalMovieDuration;//视频总时间

//player
@property (nonatomic,strong)AVPlayer *player;
@property (nonatomic,strong)AVPlayerItem *playerItem;


//touch evens
@property (nonatomic,assign)BOOL isSlideOrClick;

@property (nonatomic,strong)UISlider *volumeViewSlider;
@property (nonatomic,assign)float systemVolume;//系统音量值
@property (nonatomic,assign)float systemBrightness;//系统亮度
@property (nonatomic,assign)CGPoint startPoint;//起始位置坐标
//
@property (nonatomic,assign)BOOL isTouchBeganLeft;//起始位置方向
@property (nonatomic,copy)NSString *isSlideDirection;//滑动方向
@property (nonatomic,assign)float startProgress;//起始进度条
@property (nonatomic,assign)float NowProgress;//进度条当前位置

//监控进度
@property (nonatomic,strong)NSTimer *avTimer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self prefersStatusBarHidden];
    
    self.view.backgroundColor = kLineColor;
    
    // 本地 视频
    _url = [[NSBundle mainBundle] URLForResource:@"1455968234865481297704" withExtension:@"mp4"];
    /*
    @"http://7xqhmn.media1.z0.glb.clouddn.com/femorning-20161106.mp4",
    @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4",
    @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
    @"http://baobab.wdjcdn.com/14525705791193.mp4",
    @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
    @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
    @"http://baobab.wdjcdn.com/14564977406580.mp4",
    @"http://baobab.wdjcdn.com/1456316686552The.mp4",
    @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
    @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
    @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
    @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
    @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
    @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
    @"http://baobab.wdjcdn.com/1456653443902B.mp4",
    @"http://baobab.wdjcdn.com/1456231710844S(24).mp4"
     
    // 已下载
    @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
     */
    
    // 不能 播放 网络视频 没 缓存
//    _url = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1455968234865481297704.mp4"] ;
    
    // status bar
    [self createTopView];
    
    // player 播放视频
    [self createAvPlayer];
    
    // bottom bar
    [self createBottomView];
    
    // 系统音量 调节滑块
    [self creatVolumeSlider];

    // 屏幕亮度
    [self sysBrightness];
}

#pragma mark - 头部View
- (void)createTopView
{
    CGFloat titleLableWidth = mainHeight;
    _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, TopViewHeight)];
    [self.view addSubview:_topView];
    _topView.backgroundColor = kRedColor;
    
    _backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, TopViewHeight)];
    [_topView addSubview:_backBtn];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(mainHeight/2-titleLableWidth/2, 0, titleLableWidth, TopViewHeight)];
    [_topView addSubview:_titleLabel];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.text = @"我是标题";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - 播放器躯干
- (void)createAvPlayer
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    CGRect playerFrame = CGRectMake(0, TopViewHeight, mainHeight, mainWidth - TopViewHeight - BottomViewHeight);
    
    AVURLAsset *asset = [AVURLAsset assetWithURL: _url];
    
    //获取视频总时长
    Float64 duration = CMTimeGetSeconds(asset.duration);
    _totalMovieDuration = duration;
    
    _playerItem = [AVPlayerItem playerItemWithAsset:asset];
    _player = [[AVPlayer alloc] initWithPlayerItem:_playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = playerFrame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
}

#pragma mark - 底部View
- (void)createBottomView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, mainWidth - BottomViewHeight, mainHeight, BottomViewHeight)];
    [self.view addSubview:_bottomView];
    _bottomView.backgroundColor = kGreenColor;
    
    CGFloat barY = 5;
    
    // play btn
    _playBtn = [[UIButton alloc]initWithFrame:CGRectMake(MARGIN, barY, CHOOSE, CHOOSE)];
    [_bottomView addSubview:_playBtn];
    [_playBtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // currentTime
    CGFloat curX = CGRectGetMaxX(self.playBtn.frame) + MARGIN;
    _currentTime = [[UILabel alloc]initWithFrame:CGRectMake(curX, barY + MARGIN, LABEL_W, LABEL_H)];
    [_bottomView addSubview:_currentTime];
    _currentTime.backgroundColor = [UIColor clearColor];
    _currentTime.font = [UIFont systemFontOfSize:10];
    _currentTime.textColor = [UIColor whiteColor];
    _currentTime.textAlignment = NSTextAlignmentCenter;
    _currentTime.text = [self convertMovieTimeToText:0];
    
    //进度条
    curX = CGRectGetMaxX(self.currentTime.frame) + MARGIN;
    CGFloat slidW = mainHeight - MARGIN * 6 - 30 - LABEL_W * 2 - CHOOSE;
    _movieProgressSlider = [[UISlider alloc]initWithFrame:CGRectMake(curX, barY + 5, slidW, 20)];
    [_bottomView addSubview:_movieProgressSlider];
    [_movieProgressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
    [_movieProgressSlider setMaximumTrackTintColor:[UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f]];
    [_movieProgressSlider setThumbImage:[UIImage imageNamed:@"progressThumb.png"] forState:UIControlStateNormal];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [_movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    
    
    curX = CGRectGetMaxX(_movieProgressSlider.frame) + MARGIN;
    _totleTime = [[UILabel alloc]initWithFrame:CGRectMake(curX, barY + MARGIN, LABEL_W, LABEL_H)];
    [_bottomView addSubview:_totleTime];
    _totleTime.backgroundColor = [UIColor clearColor];
    _totleTime.font = [UIFont systemFontOfSize:10];
    _totleTime.textColor = [UIColor whiteColor];
    _totleTime.textAlignment = NSTextAlignmentCenter;
    _totleTime.text = [self convertMovieTimeToText:_totalMovieDuration];
}

#pragma mark - 音量
- (void)creatVolumeSlider
{
    // 音量
    CGFloat curX = CGRectGetMaxX(_playBtn.frame) + MARGIN;
    UILabel *volume = [[UILabel alloc] init];
    [_bottomView addSubview:volume];
    volume.frame = CGRectMake(curX, CGRectGetMaxY(_playBtn.frame) + MARGIN, CHOOSE, LABEL_H);
    volume.font = [UIFont systemFontOfSize:12];
    volume.text = @"音量:";
    volume.textAlignment = NSTextAlignmentCenter;
    volume.textColor = [UIColor whiteColor];
    
    curX = CGRectGetMaxX(volume.frame) + MARGIN;
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    [_bottomView addSubview:volumeView];
    volumeView.frame = CGRectMake(curX,CGRectGetMinY(volume.frame), 100, 30);
    [volumeView setShowsVolumeSlider:YES];
    [volumeView setShowsRouteButton:YES];
    [volumeView sizeToFit];
    //设置滑块图片
    [volumeView setVolumeThumbImage:[UIImage imageNamed:@"progressThumb.png"] forState:UIControlStateNormal];
//    [volumeView setMaximumVolumeSliderImage:[UIImage imageNamed:@"pingfen_select"]        forState:UIControlStateNormal];
    
    // 纵向滑动屏幕 调节音量
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
}

- (void)sysBrightness
{
    //获取系统亮度
    _systemBrightness = [UIScreen mainScreen].brightness;
}

#pragma mark - btn click
//返回Click
- (void)backClick
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        //do someing
        [weakSelf.avTimer invalidate];
        weakSelf.avTimer = nil;
    }];
}

//播放/暂停 Click
- (void)playClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    _isPlay = btn.selected;
    [self playOrStop:_isPlay];
}

#pragma mark - play
- (void)playOrStop:(BOOL)isPlay
{
    if (isPlay) {
        
        //1.通过实际百分比获取秒数。
        float dragedSeconds = floorf(_totalMovieDuration * _NowProgress);
        CMTime newCMTime = CMTimeMake(dragedSeconds,1);
        
        //2.更新电影到实际秒数。
        [_player seekToTime:newCMTime];
        
        //3.play 并且重启timer
        [_player play];
    
        _avTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
    }
    else{
        [_player pause];
        [_avTimer invalidate];
    }
}

-(void)updateUI
{
    //1.根据播放进度与总进度计算出当前百分比。
    float new = CMTimeGetSeconds(_player.currentItem.currentTime) / CMTimeGetSeconds(_player.currentItem.duration);
    
    //2.计算当前百分比与实际百分比的差值，
    float DValue = new - _NowProgress;
    
    //3.实际百分比更新到当前百分比
    _NowProgress = new;
    
    //4.当前百分比加上差值更新到实际进度条
    self.movieProgressSlider.value = self.movieProgressSlider.value + DValue;
    
    //5.当前播放时间 s
    CGFloat currentTime = _player.currentTime.value / (CGFloat)_player.currentTime.timescale;
    self.currentTime.text = [self convertMovieTimeToText:currentTime];
}

#pragma mark - slider click
//按住滑块
-(void)scrubbingDidBegin
{
    _ProgressBeginToMove = _movieProgressSlider.value;
}

//释放滑块
-(void)scrubbingDidEnd
{
    [self UpdatePlayer];
}

//拖动停止后更新avplayer
-(void)UpdatePlayer
{
    //1.暂停播放
    [self playOrStop:NO];
    
    //2.存储实际百分比值
    _NowProgress = _movieProgressSlider.value;
    
    //3.重新开始播放
    [self playOrStop:YES];
}

#pragma mark - touch 左半部分 屏幕亮度 , 右半部分 音量

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(event.allTouches.count == 1){
        //保存当前触摸的位置
        CGPoint point = [[touches anyObject] locationInView:self.view];
        _startPoint = point;
        _startProgress = _movieProgressSlider.value;
        _systemVolume = _volumeViewSlider.value;
        NSLog(@"volume:%f",_volumeViewSlider.value);
        if(point.x < self.view.frame.size.width/2){
            _isTouchBeganLeft = YES;
        }else{
            _isTouchBeganLeft = NO;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isSlideOrClick = YES;
    //右半区调整音量
    CGPoint location = [[touches anyObject] locationInView:self.view];
    CGFloat changeY = location.y - _startPoint.y;
    CGFloat changeX = location.x - _startPoint.x;
    
    //初次滑动没有滑动方向，进行判断。已有滑动方向，直接进行操作
    if ([_isSlideDirection isEqualToString:@"横向"]) {
        int index = location.x - _startPoint.x;
        if(index>0){
            _movieProgressSlider.value = _startProgress + abs(index)/10 * 0.008;
        }else{
            _movieProgressSlider.value = _startProgress - abs(index)/10 * 0.008;
        }
    }else if ([_isSlideDirection isEqualToString:@"纵向"]){
        if (_isTouchBeganLeft) {
            int index = location.y - _startPoint.y;
            if(index>0){
                [UIScreen mainScreen].brightness = _systemBrightness - abs(index)/10 * 0.01;
            }else{
                [UIScreen mainScreen].brightness = _systemBrightness + abs(index)/10 * 0.01;
            }
            
        }else{
            int index = location.y - _startPoint.y;
            if(index>0){
                [_volumeViewSlider setValue:_systemVolume - (abs(index)/10 * 0.05) animated:YES];
                [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }else{
                [_volumeViewSlider setValue:_systemVolume + (abs(index)/10 * 0.05) animated:YES];
                [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        
    }else{
        //"第一次"滑动
        if(fabs(changeX) > fabs(changeY)){
            _isSlideDirection = @"横向";//设置为横向
        }else if(fabs(changeY)>fabs(changeX)){
            _isSlideDirection = @"纵向";//设置为纵向
        }else{
            _isSlideOrClick = NO;
            NSLog(@"不在五行中。");
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    if (_isSlideOrClick) {
        _isSlideDirection = @"";
        _isSlideOrClick = NO;
        
        CGFloat changeY = point.y - _startPoint.y;
        CGFloat changeX = point.x - _startPoint.x;
        //如果位置改变 刷新进度条
        if(fabs(changeX) > fabs(changeY)){
            [self UpdatePlayer];
        }
        return;
    }
}

//时间文字转换
-(NSString*)convertMovieTimeToText:(CGFloat)seconds
{
    NSInteger hour = seconds / 3600;
    NSInteger time = (NSInteger)seconds % 3600;
    NSInteger min  = (NSInteger)time / 60;
    NSInteger sec  = time % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hour, (long)min, (long)sec];
}

#pragma mark - 状态栏与横屏设置
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//允许横屏旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//支持左右旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight|UIInterfaceOrientationMaskLandscapeLeft;
}

//默认为右旋转
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
