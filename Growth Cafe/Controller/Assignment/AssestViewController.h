//
//  AssestViewController.h
//  Growth Cafe
//
//  Created by Mayank on 14/08/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
@protocol AssestViewControllerDelegate <NSObject>

-(void)DidSelectAssesst: (ALAsset *)selectedAsset andSender:(id)sender
;
-(void)DidNoSelectAssesst:(id)sender
;
@end
@interface AssestViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblAssest;
   __unsafe_unretained id <AssestViewControllerDelegate> mDelegate;
    
}
@property (nonatomic, strong) NSArray *photos;
- (IBAction)btnCancleClick:(id)sender;
+ (ALAssetsLibrary *)defaultAssetsLibrary;

@property (strong, nonatomic) IBOutlet MPMoviePlayerController *moviePlayer;
@property (nonatomic,assign)  id <AssestViewControllerDelegate> mDelegate;
@end
