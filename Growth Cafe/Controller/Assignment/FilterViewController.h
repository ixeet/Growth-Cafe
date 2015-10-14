//
//  FilterViewController.h
//  Growth Cafe
//
//  Created by Mayank on 19/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FilterViewControllerDelegate <NSObject>

-(void)DidSelectFilter: (NSMutableDictionary *)selectedAsset andSender:(id)sender
;
-(void)DidNoSelectFilter:(id)sender
;
@end
@interface FilterViewController : UIViewController
{
    IBOutlet UITableView *tblContentView;

}
- (IBAction)btnDoneClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@property (strong, nonatomic)  NSString *strComeFrom;
@property (strong, nonatomic) IBOutlet UIView *viewNetwork;
- (IBAction)btnClose:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnCourse;
@property (strong, nonatomic) IBOutlet UIButton *btnModule;

@property (strong, nonatomic) IBOutlet UIButton *btnGroup;
@property (strong, nonatomic) IBOutlet UIButton *btnDepartment;
@property (strong, nonatomic) IBOutlet UIButton *btnOrganization;
@property (strong, nonatomic) IBOutlet UIButton *btnStatus;
- (IBAction)btnGroupClick:(id)sender;
- (IBAction)btnDepartmentClick:(id)sender;
- (IBAction)btnOrganizationClick:(id)sender;

- (IBAction)btnCourseClick:(id)sender;
- (IBAction)btnModuleClick:(id)sender;
- (IBAction)btnStatusClick:(id)sender;
@property (nonatomic,assign)  id <FilterViewControllerDelegate> mDelegate;
@end
