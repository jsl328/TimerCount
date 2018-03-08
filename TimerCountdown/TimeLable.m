//
//  TimeLable.m
//  TimerCountdown
//
//  Created by jsl on 2018/3/7.
//  Copyright © 2018年 jsl. All rights reserved.
//

#import "TimeLable.h"
@interface TimeLable ()
@property (nonatomic, strong)NSTimer *timer;
@end
@implementation TimeLable

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = NSTextAlignmentCenter;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
            self.hour--;
        }
    }
    
    self.text = [NSString stringWithFormat:@"%ld:%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
@end
