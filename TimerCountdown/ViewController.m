//
//  ViewController.m
//  TimerCountdown
//
//  Created by jsl on 2018/3/7.
//  Copyright © 2018年 jsl. All rights reserved.
//

#import "ViewController.h"
#import "TimeLable.h"
#import<AudioToolbox/AudioToolbox.h>

@interface ViewController ()
{
    int secondsCountDown;
    int  totalCount;
    int downCount;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *CdDatePicker;
@property (strong, nonatomic) IBOutlet UILabel *CdLabel;
@property (strong, nonatomic) IBOutlet UIButton *CdFinishedBtn;
@property (strong, nonatomic) IBOutlet UIButton *CdCountDown;
@property (copy, nonatomic) NSString *CdCountDownStr;
@property (strong, nonatomic) IBOutlet UITextField *T1;
@property (strong, nonatomic) IBOutlet UITextField *T2;

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property(nonatomic,strong)NSTimer*countDownTimer;

@end

@implementation ViewController
- (IBAction)BtnoOnClick:(UIButton *)sender {
    _CdDatePicker.hidden=YES;
    if ([sender isEqual:_CdFinishedBtn]) {
        //完成按钮
        NSLog(@"完成按钮");
        if (_CdDatePicker!=nil) {
            [_CdDatePicker removeTarget:self action:@selector(dateChangeRM:) forControlEvents:UIControlEventValueChanged];
        }
        _CdLabel.hidden=YES;
        _CdDatePicker.hidden=YES;
        [_CdCountDown setTitle:@"开始计时" forState:UIControlStateNormal];
        secondsCountDown=[_T1.text intValue];
        [_countDownTimer invalidate];
        _countDownTimer =nil;
        _T1.hidden =_T2.hidden =NO;
        [_CdLabel setTextColor:[UIColor whiteColor]];
        [_CdLabel setText:[self countdownCent:secondsCountDown]];
    }else if ([sender isEqual:_CdCountDown]){
        if (secondsCountDown==0||downCount==0||[_T1.text intValue]<[_T2.text intValue]) {
            return;
        }
        //开始计时按钮
        _T1.hidden =_T2.hidden =YES;
        [_T1 resignFirstResponder];
        [_T2 resignFirstResponder];
        _CdFinishedBtn.enabled=_CdDatePicker.hidden=YES;
        _CdLabel.hidden=NO;
        NSLog(@"开始计时按钮");
        if ([_CdCountDown.titleLabel.text isEqualToString:@"开始计时"]) {
            [_CdCountDown setTitle:@"暂停" forState:UIControlStateNormal];
            //设置定时器
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
        }else if ([_CdCountDown.titleLabel.text isEqualToString:@"暂停"]){
            [_CdCountDown setTitle:@"继续" forState:UIControlStateNormal];
            //暂停定时器
             [_countDownTimer setFireDate:[NSDate distantFuture]];
        }else if ([_CdCountDown.titleLabel.text isEqualToString:@"继续"]){
            [_CdCountDown setTitle:@"暂停" forState:UIControlStateNormal];
            //启动定时器
            [_countDownTimer setFireDate:[NSDate distantPast]];
        }
    }else{
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:_T1]) {
        totalCount =[textField.text intValue];
    }
    if ([textField isEqual:_T2]) {
        if (totalCount<[textField.text intValue]) {
            return;
        }
        downCount =totalCount-[textField.text intValue];
    }
    
    secondsCountDown =totalCount;
}


-(NSString *)countdownCent:(int )secondsCountDown
{
    //设置倒计时显示的时间
    //NSString *str_hour = [NSString stringWithFormat:@"%ld",(long)secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02d",secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
//    self.timeLbl.text = [NSString stringWithFormat:@"倒计时   %@",format_time];
    return format_time;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _CdFinishedBtn.enabled=NO;
    _CdLabel.hidden =YES;
    
    secondsCountDown =0;
    [_CdLabel setFont:[UIFont systemFontOfSize:400.f]];
    _CdDatePicker.hidden=YES;
    
    _T1.delegate=self;
    _T2.delegate =self;
    _T1.keyboardType = UIKeyboardTypeNumberPad;
    _T2.keyboardType=UIKeyboardTypeNumberPad;
    //启动倒计时后会每秒钟调用一次方法 countDownAction
    
    //_CdCountDown.layer.cornerRadius = _CdCountDown.frame.size.width/2.0;
    //_CdCountDown.layer.masksToBounds = _CdCountDown.frame.size.width/2.0;

    //设置文字颜色
    //self.timeLbl.textColor = [UIColor  blackColor ];
    
    if(_CdDatePicker!=nil) {
       [_CdDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_T1 resignFirstResponder];
    [_T2 resignFirstResponder];
}

-(void)playBackgroundMusic:(NSString *)flag{
    if ( [flag isEqualToString:@"2"]) {
        //注册系统id
        //不超过三十秒的短音频
        SystemSoundID ID;
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"didi" withExtension:@"mp3"];
        //创建系统音频
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &ID);
        //播放 系统声音id从1000开始
        AudioServicesPlayAlertSound(ID);
    }else{
        //定义一个SystemSoundID
        SystemSoundID soundID = [flag isEqualToString:@"1"]?1000:1001;//具体参数详情下面贴出来
        //播放声音
        AudioServicesPlaySystemSound(soundID);
    }
    //振动vibrate
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

//实现倒计时动作
-(void)countDownAction{
    [_CdCountDown setTitle:@"暂停" forState:UIControlStateNormal];
    if (secondsCountDown==0) {
        return;
    }
    //倒计时-1
    secondsCountDown--;
    
    if (secondsCountDown ==downCount) {
        [_CdLabel setTextColor:[UIColor colorWithRed:222./255. green:184./255. blue:135./255. alpha:1]];
        [self playBackgroundMusic:@"1"];
    }
    
    //重新计算 时/分/秒
    //NSString *str_hour = [NSString stringWithFormat:@"%02d",secondsCountDown/3600];
    //NSString *str_minute = [NSString stringWithFormat:@"%02d",(secondsCountDown%3600)/60];
    //NSString *str_second = [NSString stringWithFormat:@"%02d",secondsCountDown%60];
    //NSString *format_time=[NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    if(secondsCountDown==0){
        _CdLabel.hidden =YES;
        [_CdCountDown setTitle:@"开始计时" forState:UIControlStateNormal];
        [_countDownTimer invalidate];
        [_CdDatePicker setHidden:NO];
        _T1.hidden=_T2.hidden=NO;
        secondsCountDown =totalCount;
        [_CdLabel setTextColor:[UIColor whiteColor]];
        [self playBackgroundMusic:@"2"];
    }
    
    //修改倒计时标签及显示内容
    _CdLabel.text =[self countdownCent:secondsCountDown];
    _CdDatePicker.hidden=YES;
}

-(void)dateChange:(UIDatePicker *)datePicker {;
    NSTimeInterval cm=datePicker.countDownDuration;
    NSLog(@"%lf",cm);
    secondsCountDown =cm;
}
-(void)dateChangeRM:(UIDatePicker *)datePicker{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
