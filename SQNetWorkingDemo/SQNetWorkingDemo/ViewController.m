//
//  ViewController.m
//  SQNetWorking
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnClick:(id)sender {
    
    TestViewController *testVc = [[TestViewController alloc] init];
    [self presentViewController:testVc animated:NSYearForWeekOfYearCalendarUnit completion:nil];
}

@end
