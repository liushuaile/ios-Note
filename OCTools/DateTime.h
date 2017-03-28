//
//  DateTime.h
//  iCalendar
//
//  Created by tang peter on 13/11/13.
//  Copyright (c) 2013 aia. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MTLIB/MTLIB.h>
#import <sqlite3.h>
#import "MyEncryptor.h"
#import "SBJson.h"

@interface DateTime : NSObject{
    NSLocale *dateTimeLocale;
    
    NSDateFormatter *syncDateFormatter;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateTimeFormatter;
    NSDateFormatter *dateFormatterForDB;
    NSDateFormatter *dateTimeFormatterForDB;
    NSDateFormatter *homeDateFormatter;
    NSDateFormatter *chiDateTimeFormatter;
    
    NSCalendar *calendar;
    NSCalendarUnit calendarUnit;
    NSDateComponents *currentDateComp;
    NSDateComponents *dayShowingDateComp;
    NSMutableArray *monthArr;
    NSMutableArray *weekArr;
    NSMutableArray *dayArr;
}

@property (nonatomic, retain) NSLocale *dateTimeLocale;

@property (nonatomic, retain) NSDateFormatter *syncDateFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *dateTimeFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatterForDB;
@property (nonatomic, retain) NSDateFormatter *dateTimeFormatterForDB;
@property (nonatomic, retain) NSDateFormatter *homeDateFormatter;
@property (nonatomic, retain) NSDateFormatter *chiDateTimeFormatter;
@property (nonatomic, retain) NSCalendar *calendar;
@property (nonatomic, assign) NSCalendarUnit calendarUnit;
@property (nonatomic, retain) NSDateComponents *currentDateComp;
@property (nonatomic, retain) NSDateComponents *dayShowingDateComp;
@property (nonatomic, retain) NSMutableArray *monthArr;
@property (nonatomic, retain) NSMutableArray *weekArr;
@property (nonatomic, retain) NSMutableArray *dayArr;

-(NSString *) getMonthViewDay:(NSInteger)index;
-(NSString *) getMonthViewShowing;
+(NSString *) retrieveDate;
-(void) resetMonthView;
-(BOOL) isMonthDaySameMonth:(NSInteger)index;
-(BOOL) isMonthDayToday:(NSInteger)index;
-(BOOL) isMonthAllow:(NSInteger)offset;

-(NSString *) getWeekViewDay:(NSInteger)index;
-(NSString *) getWeekViewShowing;
-(CGRect) getWeekCurrentTimeRect;
-(void) resetWeekView;
-(BOOL) isWeekDayToday:(NSInteger)index;
-(BOOL) isWeekAllow:(NSInteger)offset;

-(NSString *) getDayViewDay:(NSInteger)index;
-(NSString *) getDayViewDateForDB:(NSInteger)index;
-(NSString *) getDayViewShowing;
-(NSString *) getDayMonthViewShowing;
-(NSString *) getDayMonthViewShowingDateStr;
-(void) setDayViewShowing:(NSInteger)index;
+(BOOL) verifyDate:(NSArray *)dateArr;
-(BOOL) isDaySameMonth:(NSInteger)index;
-(BOOL) isDayToday:(NSInteger)index;
-(BOOL) isDayMonthAllow:(NSInteger)offset;
-(BOOL) isDayShowing:(NSInteger)index;
-(BOOL) isToday;
-(CGRect) getDayCurrentTimeRect;


-(NSString *) getDateStringForDB:(NSDate *) dateVal;



//-(BOOL) generateMonth:(NSString *)fromDate with:(NSInteger)monthOffset;
//-(BOOL) generateWeek:(NSString *)fromDate with:(NSInteger)weekOffset;
//-(BOOL) generateDay:(NSString *)fromDate with:(NSInteger)dayOffset;
//-(NSString *) getCurrentDateString;

@end
