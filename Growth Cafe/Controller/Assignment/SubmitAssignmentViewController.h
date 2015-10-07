//
//  SubmitAssignmentViewController.h
//  Growth Cafe
//
//  Created by Mayank on 13/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Assignment.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SubmitAssignmentViewController : UIViewController

- (IBAction)btnSubmitClick:(id)sender;
- (IBAction)btnBrowseClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *txtViewVideoDesc;
@property (strong, nonatomic) IBOutlet UITextView *txtViewURL;
@property (strong, nonatomic)  Assignment *assignment;
@property (strong, nonatomic) IBOutlet UITextView *txtViewVideoTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgAssest;
@property (strong, nonatomic) IBOutlet ALAsset *selectedAssest;
@property (strong, nonatomic) IBOutlet UIView *subView;


@end
