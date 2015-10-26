//
//  InstructionViewController.h
//  Growth Cafe
//
//  Created by Mayank on 18/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InstructionViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
