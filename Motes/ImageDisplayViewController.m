//
//  ImageDisplayViewController.m
//  Motes
//
//  Created by Roy Hermann on 10/14/14.
//  Copyright (c) 2014 Roy Hermann. All rights reserved.
//

#import "ImageDisplayViewController.h"

@interface ImageDisplayViewController ()

@end

@implementation ImageDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.imageView setImage:_image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
