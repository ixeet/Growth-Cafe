//
//  FilterViewController.m
//  Growth Cafe
//
//  Created by Mayank on 19/09/15.
//  Copyright (c) 2015 Scolere. All rights reserved.
//

#import "FilterViewController.h"

#import "AFHTTPRequestOperationManager.h"
@interface FilterViewController ()
{
    NSMutableArray *arraySchools,*arrayClass,*arrayHome,*arrayCourse,*arrayModule;
    AFNetworkReachabilityStatus previousStatus;
    AppDropdownType selectedDataSource;
}
@end

@implementation FilterViewController
@synthesize lblStatus,btnDepartment,btnGroup,btnOrganization,viewNetwork,btnCourse,btnModule;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    arraySchools=[AppGlobal getDropdownList:TEACHER_DATA];
    arrayClass=[[NSMutableArray alloc]init];
    arrayHome=[[NSMutableArray alloc]init];
    arrayCourse=[[NSMutableArray alloc]init];
    arrayModule=[[NSMutableArray alloc]init];

    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if(status==AFNetworkReachabilityStatusNotReachable)
        {   previousStatus=status;
            [self showNetworkStatus:NO_INTERNET_MSG newVisibility:NO] ;
        }else{
            previousStatus=status;
            [self showNetworkStatus:REESTABLISH_INTERNET_MSG newVisibility:YES];
            
        }
    }];
    selectedDataSource  =SCHOOL_DATA;
    btnOrganization.backgroundColor=[UIColor whiteColor];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)btnDoneClick:(id)sender {
}

- (IBAction)btnBackClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnClose:(id)sender {
    [self showNetworkStatus:@"" newVisibility:YES];
}
- (void)showNetworkStatus:(NSString *)status newVisibility:(BOOL)newVisibility
{
    
    lblStatus.text=status;
    [viewNetwork setHidden:newVisibility];
}
#pragma mark - Table view data source

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    [super setEditing:editing animated:animated];
//    [self.tableView setEditing:editing animated:animated];
//    [self.tableView reloadData];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSLog(@"You are in: %s", __FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(selectedDataSource) {
        case SCHOOL_DATA:
        {
           return [arraySchools count];
            
            
            break;
        }
        case CLASS_DATA:
        {
            return [arrayClass count];
             break;
        }
        case ROOM_DATA:
        {
           return [arrayHome count];
             break;
        }
        case COURSE_DATA:
        {
            
            return [arrayCourse count];
            break;
            
        }

        case MODULE_DATA:
        {
           
                return [arrayModule count];
                break;
           
        }

        case TITLE_DATA:
        {
            
            return 0;
            break;
        }
            
        case TEACHER_DATA:
        {
            
            return 0;
            break;
        }
       
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

     NSDictionary *dic;
    switch(selectedDataSource) {
        case SCHOOL_DATA:
        {
            dic = arraySchools[indexPath.row];
            cell.textLabel.text=[dic objectForKey:@"schoolName"];
            break;
        }
        case CLASS_DATA:
        {
            dic = arrayClass[indexPath.row];
            cell.textLabel.text=[dic objectForKey:@"className"];
            break;
        }
        case ROOM_DATA:
        {
            dic = arrayHome[indexPath.row];
            cell.textLabel.text=[dic objectForKey:@"homeRoomName"];
            break;
        }
        case COURSE_DATA:
        {
            dic = arrayCourse[indexPath.row];
            cell.textLabel.text=[dic objectForKey:@"courseName"];
            break;
        }
        case MODULE_DATA:
        {
            dic = arrayModule[indexPath.row];
            cell.textLabel.text=[dic objectForKey:@"moduleName"];
            break;
        }
            
        case TITLE_DATA:
        {
            return 0;
        }
            
        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    if([dic objectForKey:@"selected"]!=nil)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
    cell.textLabel.font=font;
    
   
    return cell;
    
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        switch(selectedDataSource) {
            case SCHOOL_DATA:
            {
                NSMutableDictionary *responseDic = [ arraySchools objectAtIndex:indexPath.row];
                
                [responseDic removeObjectForKey:@"selected"];

                for (NSMutableDictionary *dic in arrayClass) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }

                 [arrayClass removeAllObjects];
                [arrayHome removeAllObjects];
                [arrayCourse removeAllObjects];
                [arrayModule removeAllObjects];
                [arrayClass addObjectsFromArray:[responseDic objectForKey:@"classList"]];

                
//                for (NSDictionary*tempDic in arraySchools) {
//                   if( [tempDic objectForKey:@"selected"]!=nil)
//                   {
//                       
//                       [arrayClass addObjectsFromArray: [tempDic objectForKey:@"classList"]];
//                       for (NSMutableDictionary *dic in arrayClass) {
//                           NSMutableDictionary *tempDic=dic;
//                           [tempDic removeObjectForKey:@"selected"];
//                       }
//                       NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayClass];
//                       NSArray *arrayWithoutDuplicates = [orderedSet array];
//                       [arrayClass removeAllObjects];
//                       [arrayClass addObjectsFromArray:arrayWithoutDuplicates];
//
//                       
//                   }
//                }
              
                
                break;
            }
            case CLASS_DATA:
            {
                NSMutableDictionary *responseDic = [ arrayClass objectAtIndex:indexPath.row];
                [responseDic removeObjectForKey:@"selected"];

                for (NSMutableDictionary *dic in arrayHome) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                
                [arrayHome removeAllObjects];
             
                [arrayCourse removeAllObjects];
                [arrayModule removeAllObjects];
                [arrayHome addObjectsFromArray:[responseDic objectForKey:@"homeRoomList"]];

                
                
//                for (NSDictionary*tempDic in arrayHome) {
//                    if( [tempDic objectForKey:@"selected"]!=nil)
//                    {
//                        [arrayHome addObjectsFromArray: [tempDic objectForKey:@"homeRoomList"]];
//                        for (NSMutableDictionary *dic in arrayHome) {
//                            NSMutableDictionary *tempDic=dic;
//                            [tempDic removeObjectForKey:@"selected"];
//                        }
//                        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayHome];
//                        NSArray *arrayWithoutDuplicates = [orderedSet array];
//                        [arrayHome removeAllObjects];
//                        [arrayHome addObjectsFromArray:arrayWithoutDuplicates];
//                        
//                        
//                    }
//                }
                
                break;
            }
            case ROOM_DATA:
            {
                NSMutableDictionary *responseDic = [ arrayHome objectAtIndex:indexPath.row];
                [responseDic removeObjectForKey:@"selected"];
                for (NSMutableDictionary *dic in arrayCourse) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                [arrayCourse removeAllObjects];
                [arrayModule removeAllObjects];
                [arrayCourse addObjectsFromArray:[responseDic objectForKey:@"courseList"]];
              
//                for (NSDictionary*tempDic in arrayCourse) {
//                    if( [tempDic objectForKey:@"selected"]!=nil)
//                    {
//                        [arrayHome addObjectsFromArray: [tempDic objectForKey:@"homeRoomList"]];
//                        for (NSMutableDictionary *dic in arrayCourse) {
//                            NSMutableDictionary *tempDic=dic;
//                            [tempDic removeObjectForKey:@"selected"];
//                        }
//                        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayCourse];
//                        NSArray *arrayWithoutDuplicates = [orderedSet array];
//                        [arrayCourse removeAllObjects];
//                        [arrayCourse addObjectsFromArray:arrayWithoutDuplicates];
//                        
//                        
//                    }
//                }
                
                break;

            }
            case COURSE_DATA:
            {
                NSMutableDictionary *responseDic = [ arrayCourse objectAtIndex:indexPath.row];
                [responseDic removeObjectForKey:@"selected"];
                for (NSMutableDictionary *dic in arrayModule) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                
                [arrayModule removeAllObjects];
                [arrayModule addObjectsFromArray:[responseDic objectForKey:@"moduleList"]];
           
//                for (NSDictionary*tempDic in arrayModule) {
//                    if( [tempDic objectForKey:@"selected"]!=nil)
//                    {
//                        [arrayHome addObjectsFromArray: [tempDic objectForKey:@"homeRoomList"]];
//                        for (NSMutableDictionary *dic in arrayModule) {
//                            NSMutableDictionary *tempDic=dic;
//                            [tempDic removeObjectForKey:@"selected"];
//                        }
//                        NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayModule];
//                        NSArray *arrayWithoutDuplicates = [orderedSet array];
//                        [arrayModule removeAllObjects];
//                        [arrayModule addObjectsFromArray:arrayWithoutDuplicates];
//                        
//                        
//                    }
//                }
                
                break;
            }
            case MODULE_DATA:
            {
                NSMutableDictionary *responseDic = [ arrayCourse objectAtIndex:indexPath.row];
                [responseDic removeObjectForKey:@"selected"];
                
                
                break;

                
            }
           
                
            default:
                [NSException raise:NSGenericException format:@"Unexpected FormatType."];
        }

    }else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        switch(selectedDataSource) {
            case SCHOOL_DATA:
            {
                NSDictionary *responseDic = [ arraySchools objectAtIndex:indexPath.row];
                for (NSMutableDictionary *dic in arraySchools) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                [responseDic setValue:@"1" forKey:@"selected"];
               [arrayClass removeAllObjects];
//                for (NSMutableDictionary *dic in arrayClass) {
//                    NSMutableDictionary *tempDic=dic;
//                    [tempDic removeObjectForKey:@"selected"];
//                }
                [arrayClass addObjectsFromArray: [responseDic objectForKey:@"classList"]];
                  [tblContentView reloadData];
//                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayClass];
//                NSArray *arrayWithoutDuplicates = [orderedSet array];
//                [arrayClass removeAllObjects];
//                [arrayClass addObjectsFromArray:arrayWithoutDuplicates];
                break;
            }
            case CLASS_DATA:
            {
                NSDictionary *responseDic = [ arrayClass objectAtIndex:indexPath.row];
                for (NSMutableDictionary *dic in arrayClass) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                [responseDic setValue:@"1" forKey:@"selected"];
//                for (NSMutableDictionary *dic in arrayHome) {
//                    NSMutableDictionary *tempDic=dic;
//                    [tempDic removeObjectForKey:@"selected"];
//                }

                [arrayHome removeAllObjects];
                
                [arrayHome addObjectsFromArray: [responseDic objectForKey:@"homeRoomList"]];
                  [tblContentView reloadData];
//                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayHome];
//                NSArray *arrayWithoutDuplicates = [orderedSet array];
//                [arrayHome removeAllObjects];
//                [arrayHome addObjectsFromArray:arrayWithoutDuplicates];

                
                
                 break;
            }
            case ROOM_DATA:
            {
                NSDictionary *responseDic = [ arrayHome objectAtIndex:indexPath.row];
                for (NSMutableDictionary *dic in arrayHome) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                [responseDic setValue:@"1" forKey:@"selected"];
//                for (NSMutableDictionary *dic in arrayCourse) {
//                    NSMutableDictionary *tempDic=dic;
//                    [tempDic removeObjectForKey:@"selected"];
//                }
                
                 [arrayCourse removeAllObjects];
                
                [arrayCourse addObjectsFromArray: [responseDic objectForKey:@"courseList"]];
                  [tblContentView reloadData];
//                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayCourse];
//                NSArray *arrayWithoutDuplicates = [orderedSet array];
//                [arrayCourse removeAllObjects];
//                [arrayCourse addObjectsFromArray:arrayWithoutDuplicates];
                
                
                
                break;
            }
            case COURSE_DATA:
            {
                NSDictionary *responseDic = [ arrayCourse objectAtIndex:indexPath.row];
                
                for (NSMutableDictionary *dic in arrayCourse) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                [responseDic setValue:@"1" forKey:@"selected"];
                 [arrayModule removeAllObjects];
                
//                for (NSMutableDictionary *dic in arrayModule) {
//                    NSMutableDictionary *tempDic=dic;
//                    [tempDic removeObjectForKey:@"selected"];
//                }
                
                
                
                [arrayModule addObjectsFromArray: [responseDic objectForKey:@"moduleList"]];
                  [tblContentView reloadData];
//                NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:arrayModule];
//                NSArray *arrayWithoutDuplicates = [orderedSet array];
//                [arrayModule removeAllObjects];
//                [arrayModule addObjectsFromArray:arrayWithoutDuplicates];
                
                
                
                break;
            }
            case MODULE_DATA:
            {
                NSDictionary *responseDic = [ arrayModule objectAtIndex:indexPath.row];
                for (NSMutableDictionary *dic in arrayModule) {
                    NSMutableDictionary *tempDic=dic;
                    [tempDic removeObjectForKey:@"selected"];
                }
                [responseDic setValue:@"1" forKey:@"selected"];
                [tblContentView reloadData];
                 break;
            }
            case TITLE_DATA:
                
            default:
                [NSException raise:NSGenericException format:@"Unexpected FormatType."];
        }

    }

    
}

- (IBAction)btnModuleClick:(id)sender{
    if([arrayModule count]==0)
        return;
    btnCourse.backgroundColor=[UIColor clearColor];
    btnModule.backgroundColor=[UIColor whiteColor];
    btnOrganization.backgroundColor=[UIColor clearColor];
    btnDepartment.backgroundColor=[UIColor  clearColor];
    btnGroup.backgroundColor=[UIColor clearColor];
    selectedDataSource=MODULE_DATA;
    [tblContentView reloadData];
}
- (IBAction)btnCourseClick:(id)sender{
    if([arrayCourse count]==0)
        return;
    btnCourse.backgroundColor=[UIColor whiteColor];
    btnModule.backgroundColor=[UIColor clearColor];
    btnOrganization.backgroundColor=[UIColor clearColor];
    btnDepartment.backgroundColor=[UIColor  clearColor];
    btnGroup.backgroundColor=[UIColor clearColor];
    selectedDataSource=COURSE_DATA;
    [tblContentView reloadData];
}
- (IBAction)btnGroupClick:(id)sender {
    if([arrayHome count]==0)
        return;
    btnCourse.backgroundColor=[UIColor clearColor];
    btnModule.backgroundColor=[UIColor clearColor];
    btnOrganization.backgroundColor=[UIColor clearColor];
    btnDepartment.backgroundColor=[UIColor  clearColor];
    btnGroup.backgroundColor=[UIColor whiteColor];
    selectedDataSource=ROOM_DATA;
    [tblContentView reloadData];
}

- (IBAction)btnDepartmentClick:(id)sender {
    if([arrayClass count]==0)
        return;
    btnCourse.backgroundColor=[UIColor clearColor];
    btnModule.backgroundColor=[UIColor clearColor];
    btnDepartment.backgroundColor=[UIColor whiteColor];
    btnOrganization.backgroundColor=[UIColor clearColor];
    btnGroup.backgroundColor=[UIColor clearColor];
    selectedDataSource=CLASS_DATA;
  [tblContentView reloadData];

    
}

- (IBAction)btnOrganizationClick:(id)sender {
    btnCourse.backgroundColor=[UIColor clearColor];
    btnModule.backgroundColor=[UIColor clearColor];
    btnDepartment.backgroundColor=[UIColor clearColor];
    btnOrganization.backgroundColor=[UIColor whiteColor];
    btnGroup.backgroundColor=[UIColor clearColor];
    selectedDataSource=SCHOOL_DATA;
    [tblContentView reloadData];
    
  }


@end
//
