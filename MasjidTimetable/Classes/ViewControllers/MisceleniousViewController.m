//
//  MisceleniousViewController.m
//  Masjid Timetable
//
//  Created by Vardan Abrahamyan on 5/19/15.
//  Copyright (c) 2015 Lentrica Software. All rights reserved.
//

#import "MisceleniousViewController.h"
#import "AFNetworking.h"
#import <UserNotifications/UserNotifications.h>

@interface MisceleniousViewController ()

@end

@implementation MisceleniousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self webserviceCall];
    [self webserviceCall2];
    
    [[self.lblDisplayDate layer] setCornerRadius:5.0f];
    [[self.lblDisplayDate layer] setMasksToBounds:YES];
    
    [[self.lblDisplayDateSecond layer] setCornerRadius:5.0f];
    [[self.lblDisplayDateSecond layer] setMasksToBounds:YES];
    
    [[self.viewGradient layer] setCornerRadius:5.0f];
    [[self.viewGradient layer] setMasksToBounds:YES];
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.viewGradient.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:1.0/255.0 green:0.72/255.0 blue:0.20/255.0 alpha:1.0] CGColor], (id)    [[UIColor colorWithRed:1.0/255.0 green:0.82/255.0 blue:0.50/255.0 alpha:1.0] CGColor], nil];
    [self.viewGradient.layer insertSublayer:gradient atIndex:0];*/
    
    
    //[self.viewGradient addSubview:self.lblDisplayDate];
    
    //[self.viewGradient.layer addSublayer:gradient];

    
    UIImage *image = [UIImage imageNamed:@"gradient_1.png"];
     self.viewGradient.backgroundColor = [UIColor colorWithPatternImage:image];
    
    
    
    /*CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.lblDisplayDate.bounds;
   // UIColor *startColour = [UIColor colorWithHue:1.00 saturation:0.72 brightness:20.00 alpha:1.0];
   // UIColor *endColour = [UIColor colorWithHue:1.00 saturation:0.82 brightness:0.50 alpha:1.0];
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor orangeColor], (id)[UIColor redColor], nil];
    
    [self.lblDisplayDate.layer insertSublayer:gradient atIndex:0];*/
    
    
    
    //self.lblDisplayDate.textColor =[UIColor whiteColor];

    /*CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.lblDisplayDate.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor redColor], (id)[UIColor whiteColor], nil];
    [self.lblDisplayDate.layer addSublayer:gradient];*/
    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *defaults=[[NSUserDefaults standardUserDefaults] valueForKey:@"themeChanged"];
    if ([defaults intValue]==0 || defaults.length==0)
    {
        [self.backImage setImage:[UIImage imageNamed:@"background.png"]];
    } else if ( [defaults intValue] == 1) {
        [self.backImage setImage:[UIImage imageNamed:@"theme1.png"]];
    } else {
        [self.backImage setImage:[UIImage imageNamed:@"summerTheme.png"]];
    }
}


- (void)webserviceCall {
    
    [SVProgressHUD showWithStatus:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", strDate);
    
    //2017-10-07

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    //NSString *url = [NSString stringWithFormat:@"http://www.moonsighting.org.uk/scripts/hijri.js?return=json&date=%@", strDate];
    NSString *url = [NSString stringWithFormat:@"http://www.wifaqululama.co.uk/hijri?api=1"];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:url  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [SVProgressHUD dismiss];
                                             //NSArray *json = (NSArray *) JSON;
                                             //NSLog(@"%@", json);
                                             
                                             NSDictionary *dictResponse = [[NSDictionary alloc]init];
                                             dictResponse = JSON;
                                             NSLog(@"%@", dictResponse);
                                             
                                             
                                             NSArray *islamic = dictResponse[@"islamic"];
                                             NSLog(@"%@", islamic);
                                             
                                             NSLog(@"%@", islamic[0]);
                                             NSLog(@"%@", islamic[1]);
                                             NSLog(@"%@", islamic[2]);
                                             //NSLog(@"%@", islamic[3]);
                                             
                                             NSString *strConcate = [NSString stringWithFormat:@"%@ %@ %@ Hijri", islamic[0], islamic[1], islamic[2]];
                                             self.lblDisplayDate.text = strConcate;
                                             
                                             //NSString *displayDate = islamic[""];
                                             
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

- (void)webserviceCall2 {
    
    [SVProgressHUD showWithStatus:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MM-yyyy";
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", strDate);
    
    //09-10-2017//dd-mm-yyyy
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    
    [httpClient registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    NSString *url = [NSString stringWithFormat:@"https://api.aladhan.com/gToH?date=%@", strDate];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:url  parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             [SVProgressHUD dismiss];
                                             //NSArray *json = (NSArray *) JSON;
                                             //NSLog(@"%@", json);
                                             
                                             NSDictionary *dictResponse = [[NSDictionary alloc]init];
                                             dictResponse = JSON;
                                             NSLog(@"%@", dictResponse);
                                             
                                             
                                             NSDictionary *data = [[NSDictionary alloc]init];
                                             data = dictResponse[@"data"];
                                             NSLog(@"%@", data);

                                             
                                             NSDictionary *dataHijri = [[NSDictionary alloc]init];
                                             dataHijri = data[@"hijri"];
                                             NSLog(@"%@", dataHijri);
                                             
                                             NSString *day = [NSString stringWithFormat:@"%@",dataHijri[@"day"]];
                                             NSLog(@"%@", day);
                                             
                                             
                                             NSDictionary *monthDict = [[NSDictionary alloc]init];
                                             monthDict = dataHijri[@"month"];
                                             
                                             NSString *month = [NSString stringWithFormat:@"%@",monthDict[@"en"]];
                                             NSLog(@"%@", month);
                                             
                                             NSString *year = [NSString stringWithFormat:@"%@",dataHijri[@"year"]];
                                             NSLog(@"%@", year);

                                             
                                             NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                                             [formatter setLocale:[NSLocale currentLocale]];
                                             [formatter setNumberStyle:NSNumberFormatterOrdinalStyle];
                                             NSString *sampleFormat = [formatter stringFromNumber:[NSNumber numberWithInteger:day.intValue]];
                                             
//                                             NSLog(@"%@ %@ %@ Hijri",sampleFormat,month,year);
                                             NSString *combineStr = [NSString stringWithFormat:@"%@ %@ %@ Hijri",sampleFormat,month,year];
                                             self.lblDisplayDateSecond.text = combineStr;
                                             
                                             
//                                             NSString *strConcate = [NSString stringWithFormat:@"%@ %@ %@ Hijri", islamic[1], islamic[2], islamic[3]];
//                                             self.self.lblDisplayDateSecond.text = strConcate;
                                             
                                             //NSString *displayDate = islamic[""];
                                             
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [SVProgressHUD dismiss];
                                                                                        }];
    [operation start];
}

- (NSString *)getOrdinalStringFromInteger:(NSInteger)integer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterOrdinalStyle];
    return [formatter stringFromNumber:[NSNumber numberWithInteger:integer]];
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
