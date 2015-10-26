//
//  FollowListViewController.h
//  Growth Cafe
//
//  Created by Mayank on 03/10/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowListViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UILabel *lblMaintitletxt;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitletxt1;
@property (strong, nonatomic) IBOutlet UICollectionView *colUserView;
@property (strong, nonatomic) IBOutlet UILabel *lblSubtitletxt2;
- (IBAction)btnBackClick:(id)sender;
- (IBAction)btnDoneClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;

@end
