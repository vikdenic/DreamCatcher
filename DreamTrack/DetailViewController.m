//
//  DetailViewController.m
//  DreamTrack
//
//  Created by Johnny Appleseed on 11/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation DetailViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    self.descriptionTextView.text = self.descriptionString;
}

@end
