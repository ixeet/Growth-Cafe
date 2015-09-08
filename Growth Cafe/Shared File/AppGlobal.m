//
//  AppGlobal.m
//  sLMS
//
//  Created by Mayank on 07/07/15.
//  Copyright (c) 2015 Mayank. All rights reserved.
//

#import "AppGlobal.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
@implementation AppGlobal

//Show warning message
+(void)showAlertWithMessage:(NSString*)msg title:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

//Set View Position
+(void)setViewPositionWithView:(UIView*)view axisX:(NSInteger)axisX axisY:(NSInteger)axisY withAnimation:(BOOL)animation{
    
    if (animation) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGRect rect=view.frame;
                             rect.origin.x=axisX;
                             rect.origin.y=axisY;
                             view.frame=rect;
                             
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
        
    }else{
        
        CGRect rect=view.frame;
        rect.origin.x=axisX;
        rect.origin.y=axisY;
        view.frame=rect;
    }
    
}

//Custom Button
+(void)roundButton:(UIButton*)btn withFontColor:(UIColor*)fontColor withBG:(UIColor*)BGcolor withRadius:(NSInteger)radius withborderWidth:(float)borderWidth{
    
    [btn setTitleColor:fontColor forState:UIControlStateNormal];
    btn.backgroundColor = BGcolor;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = borderWidth;
    btn.layer.cornerRadius = radius;
}


//Round View
+(void)roundView:(UIView*)view withRadius:(NSInteger)radius borderWidth:(float)width color:(UIColor*)bcolor setshadow:(BOOL)shadow shadowOffset:(CGSize)shadowOffset shadowOpacity:(float)shadowOpacity shadowColor:(UIColor*)shadowColor{
    
    [view.layer setBorderWidth:width];
    [view.layer setBorderColor:bcolor.CGColor];
    view.layer.cornerRadius = radius;
    view.clipsToBounds = YES;
    
    if (shadow) {
        view.layer.masksToBounds = NO;
        view.layer.shadowOffset = shadowOffset;
        view.layer.shadowOpacity = shadowOpacity;
        view.layer.shadowColor = shadowColor.CGColor;
    }
    
    
    // [view.layer setNeedsDisplay];
}


//Manage User Default Value
+(void)setValueInDefault:(NSString *)key value:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:(NSString*)key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(id)getValueInDefault:key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:(NSString*)key];
    
}


//Create Error Object
+(NSError*)createErrorObjectWithDescription:(NSString*)error_str errorCode:(NSInteger)errorCode{
    
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:error_str forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:@"Login" code:errorCode userInfo:details];
    
    return error;
}


//NSDate Convert to String
+(NSString*)nsdateConvertToStringWithFormate:(NSString *)Formate date:(NSDate*)date{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:Formate];
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    format.timeZone=localTimeZone;
    NSString *_strdate=[format stringFromDate:date];
    
    return _strdate;
}

//string date cinver to nsdate
+(NSDate*)convertStringDateToNSDate:(NSString*)str_date{
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:key_Custom_DateFormate];
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    format.timeZone=localTimeZone;
    NSDate *date=[format dateFromString:str_date];
    
    
    return date;
}
//Manage Read And Write File
+(NSMutableArray *)readFileData:(NSString *)strPath
{
    
    NSData *fileData = [NSData dataWithContentsOfFile:strPath];
    NSMutableArray *favArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
    return favArray;
    
}


+(void)writeFile:(NSString *)filePath andData:(NSMutableArray *)arrayData
{
    NSData  *data=[NSJSONSerialization dataWithJSONObject:arrayData options:0 error:nil];
    NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:NO];
    [stream open];
    [stream write:data.bytes maxLength:data.length];
    [stream close];
    stream = nil;
  
    
}
+(void)writeUserDataOnFile:(NSDictionary *)arrayData
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath =  [NSString stringWithFormat:@"%@/%@.txt",[arr objectAtIndex:0],@"userProfile" ];
    
    NSData  *data=[NSJSONSerialization dataWithJSONObject:arrayData options:0 error:nil];
    NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:NO];
    [stream open];
    [stream write:data.bytes maxLength:data.length];
    [stream close];
    stream = nil;

    
}
+(UserDetails *)readUserDetail
{
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *filePath =  [NSString stringWithFormat:@"%@/%@.txt",[arr objectAtIndex:0 ],@"userProfile"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *favArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
   return  [self getUserDetailObject:favArray];
  
}
+(UserDetails *)getUserDetailObject:(NSDictionary *)responseDic
{
    NSLog(@"%@",[responseDic valueForKey:@"firstName"]);
//    UserDetail  *userDetail= [[UserDetail alloc]init];
//    userDetail.userId= [responseDic valueForKey:@"userId"];
//    userDetail.title=[responseDic valueForKey:@"title"];
//    userDetail.username=[responseDic valueForKey:@"userName"];
//    userDetail.userFirstName=[responseDic valueForKey:@"firstName"];
//    userDetail.userLastName=[responseDic valueForKey:@"lastName"];
//    userDetail.userEmail=[responseDic valueForKey:@"emailId"];
//    userDetail.classId= [responseDic valueForKey:@"classId"];
//    userDetail.className=[responseDic valueForKey:@"className"];
//    userDetail.homeRoomId= [responseDic valueForKey:@"homeRoomId"];
//    userDetail.homeRoomName=[responseDic valueForKey:@"homeRoomName"];
//    userDetail.schoolId=[responseDic valueForKey:@"schoolId"];
//    userDetail.schoolName=[responseDic valueForKey:@"schoolName"];
//    userDetail.address=[responseDic valueForKey:@"address"];
//    userDetail.userFBID=[responseDic valueForKey:@"userfbid"];
    UserDetails  *user= [[UserDetails alloc]init];
    user.userId= [responseDic objectForKey:@"userId"];
    user.title=[responseDic objectForKey:@"title"];
    user.username=[responseDic objectForKey:@"userName"];
    user.userFirstName=[responseDic objectForKey:@"firstName"];
    user.userLastName=[responseDic objectForKey:@"lastName"];
    user.userEmail=[responseDic objectForKey:@"emailId"];
    user.classId= [responseDic objectForKey:@"classId"];
    user.className=[responseDic objectForKey:@"className"];
    user.homeRoomId= [responseDic objectForKey:@"homeRoomId"];
    user.homeRoomName=[responseDic objectForKey:@"homeRoomName"];
    user.schoolId=[responseDic objectForKey:@"schoolId"];
    user.schoolName=[responseDic objectForKey:@"schoolName"];
    user.address=[responseDic objectForKey:@"address"];
  
    return user;
}
//
//Manage Get/ Set Drop Down List
+(NSMutableArray*)getDropdownList:(AppDropdownType)dropdownName{
    
    NSMutableArray *stateList=[[NSMutableArray alloc] init];
    NSString *filePath =  @"";
    
    
    switch(dropdownName) {
      
        case SCHOOL_DATA:{
            
            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            filePath =  [NSString stringWithFormat:@"%@/%@.txt",[arr objectAtIndex:0],[self getDropdownFileName:dropdownName] ];
        }break;
        case CLASS_DATA:
        case ROOM_DATA:
        case  COURSE_DATA:
        case TITLE_DATA:
        {
            filePath =  [[NSBundle mainBundle] pathForResource:[self getDropdownFileName:dropdownName] ofType:@"txt"];
//            NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//            filePath =  [NSString stringWithFormat:@"%@/%@.txt",[arr objectAtIndex:0],[self getDropdownFileName:dropdownName] ];
            
        }break;
        default:
            break;
    }
    
    
    
    //read File
    [stateList addObjectsFromArray:[AppGlobal readFileData:filePath]];
    return stateList;
    
}
+(void)setDropdownList:(AppDropdownType)dropdownName andData:(NSData *)data{
    
    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath =  [NSString stringWithFormat:@"%@/%@.txt",[arr objectAtIndex:0],[self getDropdownFileName:dropdownName] ];
    //NSLog(@"filePath: %@",filePath);
    [self  writeFile:filePath andData:data ];
    
}

+(NSString*)getDropdownFileName:(AppDropdownType )dropdownName{
    
    NSString *fileName;
    switch(dropdownName) {
        case SCHOOL_DATA:
            fileName = @"SchoolList";
            break;
        case CLASS_DATA:
            fileName = @"classList";
            break;
        case ROOM_DATA:
            fileName = @"homeroomList";
            break;
            
        case TITLE_DATA:
            fileName = @"titleList";
            break;
            
        case COURSE_DATA:
            fileName = @"CourseList";
            break;
        

        default:
            [NSException raise:NSGenericException format:@"Unexpected FormatType."];
    }
    
    
    return fileName;
}

//Calculate Dynamic Size of text
+(CGSize)calculateTextSizeWithString:(NSString*)text width:(CGFloat)width font:(UIFont*)font{
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:
                                          @{  NSFontAttributeName: font,
                                              NSParagraphStyleAttributeName:paragraphStyle}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize size = rect.size;
    size.width=width;
    //NSLog(@"Text: %@ \n size %@",text, NSStringFromCGSize(size));
    return size;
}

//Check Data Available in string or note
+(BOOL)checkDataAvailableInString:(NSString*)str_data{
    
    NSString *trim_Str= [str_data stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (trim_Str.length != 0) {
        return YES;
    }else{
        return NO;
    }
    
}


//Formatter Currency
+(NSString*)returnFormattedCurrency:(NSNumber*)currency{
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    [numberFormatter setCurrencySymbol:@"$"];
    
    numberFormatter.negativePrefix = [NSString stringWithFormat:@"- %@", numberFormatter.currencySymbol];
    numberFormatter.negativeSuffix = @"";
    
    NSString *numberAsString = [numberFormatter stringFromNumber:currency];
    
    return numberAsString;
}

+(NSNumber*)returnNumberOfFormattedString:(NSString*)currency{
    
    //currency=[currency stringByReplacingOccurrencesOfString:@"$ " withString:@""];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    [numberFormatter setCurrencySymbol:@"$"];
    
    numberFormatter.negativePrefix = [NSString stringWithFormat:@"- %@", numberFormatter.currencySymbol];
    numberFormatter.negativeSuffix = @"";
    
    
    NSNumber *num=[numberFormatter numberFromString:currency];
    
    return num;
}

+(NSString*)returnWithoutFormattedCurrency:(NSString *)currency{
    
    NSRange range=[currency rangeOfString:@"$"];
    
    NSString *_currency;
    
    if (range.location == NSNotFound  ) {
        _currency=currency;
    }else{
        NSNumber *nPrice=[self returnNumberOfFormattedString:currency];
        _currency=[NSString stringWithFormat:@"%.2f",[nPrice doubleValue]];
        
        
    }
    
    return _currency;
}

//Manage Image Bytes
+(NSMutableArray*)returnBytesArrayOfNSData:(NSData*)data{
    
    NSUInteger len = data.length;
    uint8_t *bytes = (uint8_t *)[data bytes];
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:len];
    int i = 0;
    while(i < len){
        
        [result addObject:[NSNumber numberWithInteger:bytes[i]]];
        i++;
    }
    
    return result;
}


+(NSMutableData*)returnNSDataOfBytesArray:(NSArray*)bytes{
    
    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:bytes.count];
    for (NSNumber *byteVal in bytes) {
        Byte b = (Byte)(byteVal.intValue);
        [data appendBytes:&b length:1];
    }
    
    return data;
}


//element Set Enabled
+(void)elementSetEnabled:(BOOL)enabled OfView:(UIView*)view{
    for (id obj in [view subviews]) {
        if ([obj isKindOfClass:[UITextField class]] || [obj isKindOfClass:[UIButton class]] || [obj isKindOfClass:[UITextView class]]) {
            [obj setEnabled:enabled];
        }
    }
}
+ (void)ShowHidePickeratWindow:(UIView *)viewFromWindow fromWindow:(UIView *)viewAtWindow withVisibility:(BOOL)bIsPickerHidden {
    CGRect rectFrame = [viewFromWindow frame];
    CGRect rectScreen = viewAtWindow.frame;
    
    if (!bIsPickerHidden) {
        rectFrame.origin.y = rectScreen.size.height;
    }
    else{
        [viewFromWindow resignFirstResponder];
        rectFrame.origin.y = rectScreen.size.height - 255;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         [viewFromWindow setFrame:rectFrame];
                         /** code **/
                     }
                     completion:^(BOOL finished) {
                         /** code **/
                     }];
}

+(UIImage*)generateThumbnail:(NSString *)url
{
    url=@"http://191.239.57.54:8080/SLMS/test.m4v";
    //    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    //    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //    generator.appliesPreferredTrackTransform=TRUE;
    //   ;
    //    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    //    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
    //        if (result != AVAssetImageGeneratorSucceeded) {
    //            NSLog(@"couldn't generate thumbnail, error:%@", error);
    //        }
    //       return [[UIImage alloc] initWithCGImage:im];
    //
    //    };
    //
    //    CGSize maxSize = CGSizeMake(320, 180);
    //    generator.maximumSize = maxSize;
    //    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:url] options:nil];
    AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime time = CMTimeMake(1, 60);
    CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
    NSLog(@"err==%@, imageRef==%@", err, imgRef);
    return [[UIImage alloc] initWithCGImage:imgRef];
}
+(BOOL)validateEmailWithString:(NSString*)email;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return ![emailTest evaluateWithObject:email];
}
+ (BOOL) validateUrlWithString: (NSString *) stringURL {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:stringURL];
}
+(CGSize)getTheExpectedSizeOfLabel:(NSString*) labelstring andFontSize:(int) fontsize labelWidth:(float )width
{
    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumLabelSize = CGSizeMake(width,9999);

    CGSize expectedLabelSize = [labelstring sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:fontsize] constrainedToSize:maximumLabelSize
                                           lineBreakMode:NSLineBreakByTruncatingTail];
   // CGSize size = [labelstring sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
 //   CGSize adjustedSize = CGSizeMake(ceilf(281.0f), ceilf(size.height));
    //adjust the label the the new height.
    //CGRect newFrame = yourLabel.frame;
   // newFrame.size.height = expectedLabelSize.height;
   // yourLabel.frame = newFrame;
    return expectedLabelSize;
}
+(CGSize)getTheExpectedSizeOfLabel:(NSString*) labelstring
{
    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [labelstring sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:13] constrainedToSize:maximumLabelSize
                                           lineBreakMode:NSLineBreakByCharWrapping];
    // CGSize size = [labelstring sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:12]}];
    
    // Values are fractional -- you should take the ceilf to get equivalent values
    //   CGSize adjustedSize = CGSizeMake(ceilf(281.0f), ceilf(size.height));
    //adjust the label the the new height.
    //CGRect newFrame = yourLabel.frame;
    // newFrame.size.height = expectedLabelSize.height;
    // yourLabel.frame = newFrame;
    return expectedLabelSize;
}
+(NSString*) timeLeftSinceDate: (NSDate *)dateT
{
 //   NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    // or specifc Timezone: with name
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:key_Custom_DateFormate];
    NSString *localDateString = [dateFormatter stringFromDate:dateT];
    
    
    
    // or specifc Timezone: with name
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:key_Custom_DateFormate];
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
     NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
   format.timeZone=timeZone;
    NSDate *date=[format dateFromString:localDateString];
   
    NSString *timeLeft;
    
    NSDate *today10am =[NSDate date];
  
    
    NSInteger seconds = [today10am timeIntervalSinceDate:date];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes) seconds -= minutes * 60;
    
    if(days) {
        timeLeft = [NSString stringWithFormat:@"%ld Days", (long)days*-1];
    }
    else if(hours) {
        timeLeft = [NSString stringWithFormat: @"%ld Hrs", (long)hours*-1];
    }
    else if(minutes) { timeLeft = [NSString stringWithFormat: @"%ld mins", (long)minutes*-1];
    }
    else if(seconds)
        timeLeft = [NSString stringWithFormat: @"%ld sec", (long)seconds*-1];
    if(timeLeft==nil)
        timeLeft=@"0 sec";
    return timeLeft;
}
// this method is used to get the server's url from settings bundle
+ (NSString*)getServerURL
{
    NSString* settingsUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"url_preference"];
    
    NSString *bPath = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [bPath stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
    
    NSString*  firstValueDefault = nil;
    NSDictionary *prefItem;
    for (prefItem in prefSpecifierArray)
    {
        NSString *keyValueStr = [prefItem objectForKey:@"Key"];
        id defaultValue       = [prefItem objectForKey:@"DefaultValue"];
        
        if ([keyValueStr isEqualToString:@"url_preference"]){
            firstValueDefault = defaultValue;
        }
    }
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:firstValueDefault,@"url_preference",nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
    settingsUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"url_preference"];
    
    if(settingsUrl == nil){
        settingsUrl = kProdURL;
    }
    
    NSString *serverURL = kGROWTHURL(settingsUrl);
    
    return serverURL ;
}
// this method removes unwanted white spaces from a string
+ (NSString*)removeUnwantedspaces:(NSString*)oldString
{
    NSString* newString = oldString;
    
    NSCharacterSet* whitespaces = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate* noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray* parts = [newString componentsSeparatedByCharactersInSet:whitespaces];
    NSArray* filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
    newString = [filteredArray componentsJoinedByString:@" "];
    
    return newString;
}

+(void)setImageAvailableAtLocal:(NSString*)imgName AndImageData:(NSData*)arrayData
{

    NSArray *titleWords = [imgName componentsSeparatedByString:@"/"];
    imgName=[titleWords objectAtIndex:[titleWords count]-1];
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath =  [NSString stringWithFormat:@"%@/%@",[arr objectAtIndex:0], imgName];
    
    
    
//    NSData  *data=[NSJSONSerialization dataWithJSONObject:arrayData options:0 error:nil];
    NSOutputStream *stream = [[NSOutputStream alloc] initToFileAtPath:filePath append:NO];
    [stream open];
    [stream write:arrayData.bytes maxLength:arrayData.length];
    [stream close];
    stream = nil;
}
+(NSData*)getImageAvailableAtLocal:(NSString*)imgName
{
    NSArray *titleWords = [imgName componentsSeparatedByString:@"/"];
    imgName=[titleWords objectAtIndex:[titleWords count]-1];

    
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *filePath =  [NSString stringWithFormat:@"%@/%@",[arr objectAtIndex:0 ],imgName];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    return fileData;
}

+(BOOL)checkImageAvailableAtLocal:(NSString*)imgName
{
    NSArray *titleWords = [imgName componentsSeparatedByString:@"/"];
    imgName=[titleWords objectAtIndex:[titleWords count]-1];

    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *filePath =  [NSString stringWithFormat:@"%@/%@",[arr objectAtIndex:0 ],imgName];
    BOOL isDirectory;
     BOOL fileExistsAtPath = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    if(fileExistsAtPath){
         return YES;
    

    }

    
    return NO;
}



@end

