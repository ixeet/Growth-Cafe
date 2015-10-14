//
//  CustomKeyboard.m
//
//  Created by Kalyan Vishnubhatla on 10/9/12.
//
//

#import "CustomKeyboard.h"

@implementation CustomKeyboard
@synthesize delegate, currentSelectedTextboxIndex;

- (id)init {
    self = [super init];
    if (self){
        
    }
    return self;
}

- (UIToolbar *)getToolbarWithPrevNextDone:(BOOL)prevEnabled :(BOOL)nextEnabled
{    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    toolbar.barTintColor=[UIColor colorWithRed:186.0/255 green:0.0/255 blue:2.0/255 alpha:1.0];
     toolbar.backgroundColor=[UIColor colorWithRed:186.0/255 green:0.0/255 blue:2.0/255 alpha:1.0];
    [toolbar sizeToFit];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
   
    
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    UISegmentedControl *tabNavigation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
    //tabNavigation.segmentedControlStyle = UISegmentedControlStyleBar;
    tabNavigation.tintColor=[UIColor whiteColor];
   // tabNavigation.backgroundColor=[UIColor colorWithRed:186.0 green:0.0 blue:2.0 alpha:1.0];
    [tabNavigation setEnabled:prevEnabled forSegmentAtIndex:0];
    [tabNavigation setEnabled:nextEnabled forSegmentAtIndex:1];
    tabNavigation.momentary = YES;
    [tabNavigation addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
    [tabNavigation setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    
    
    UIBarButtonItem *barSegment = [[UIBarButtonItem alloc] initWithCustomView:tabNavigation];
    
    [itemsArray addObject:barSegment];

    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [doneButton setTintColor:[UIColor whiteColor]];
    //[doneButton setTitleTextAttributes:attributes forState:UIControlStateNormal];

    [itemsArray addObject:doneButton];

    toolbar.items = itemsArray;
        
    return toolbar;
}

- (UIToolbar *)getToolbarWithDone
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [itemsArray addObject:flexButton];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(userClickedDone:)];
    [itemsArray addObject:doneButton];
    
    toolbar.items = itemsArray;
    
    return toolbar;
}

/* Previous / Next segmented control changed value */
- (void)segmentedControlHandler:(id)sender
{
    if (delegate){
        switch ([(UISegmentedControl *)sender selectedSegmentIndex]) {
            case 0:
                [delegate previousClicked:currentSelectedTextboxIndex];
                break;
            case 1:
                [delegate nextClicked:currentSelectedTextboxIndex];
                break;
            default:
                break;
        }
    }
}

- (void)userClickedDone:(id)sender {
    if (delegate){
        [delegate doneClicked:currentSelectedTextboxIndex];
    }
}

@end
