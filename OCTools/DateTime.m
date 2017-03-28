//
//  DateTime.m
//  iCalendar
//
//  Created by tang peter on 13/11/13.
//  Copyright (c) 2013 aia. All rights reserved.
//

#import "DateTime.h"
//#import "MShareDB.h"
@implementation DateTime


@synthesize dateTimeLocale;
@synthesize syncDateFormatter, dateFormatter, dateTimeFormatter, dateFormatterForDB, dateTimeFormatterForDB, homeDateFormatter, chiDateTimeFormatter, calendar, calendarUnit, currentDateComp, dayShowingDateComp;

@synthesize monthArr, weekArr, dayArr;

-(id) init{
    self = [super init];
    if (self){
        dateTimeLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
        
        syncDateFormatter = [[NSDateFormatter alloc] init];
        [syncDateFormatter setLocale:dateTimeLocale];
        [syncDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [syncDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:dateTimeLocale];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        [dateTimeFormatter setLocale:dateTimeLocale];
        [dateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        dateFormatterForDB = [[NSDateFormatter alloc] init];
        [dateFormatterForDB setLocale:dateTimeLocale];
        [dateFormatterForDB setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateFormatterForDB setDateFormat:@"yyyyMMdd"];
        
        dateTimeFormatterForDB = [[NSDateFormatter alloc] init];
        [dateTimeFormatterForDB setLocale:dateTimeLocale];
        [dateTimeFormatterForDB setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [dateTimeFormatterForDB setDateFormat:@"yyyyMMddHHmmss"];
        
        homeDateFormatter = [[NSDateFormatter alloc] init];
        [homeDateFormatter setLocale:dateTimeLocale];
        [homeDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [homeDateFormatter setDateFormat:@"yyyy.MM.dd"];
        
        chiDateTimeFormatter = [[NSDateFormatter alloc] init];
        [chiDateTimeFormatter setLocale:self.dateTimeLocale];
        [chiDateTimeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        [chiDateTimeFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        calendarUnit = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSWeekCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        currentDateComp = [calendar components:calendarUnit fromDate:[NSDate date]];
        
        dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [currentDateComp year], [currentDateComp month], [currentDateComp day]]]];
        
        monthArr = [[NSMutableArray alloc] init];
        weekArr = [[NSMutableArray alloc] init];
        dayArr = [[NSMutableArray alloc] init];
        
        //Prepare for month and day
        NSDateComponents *tempMonthDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [currentDateComp year], [currentDateComp month]]]];
        NSDateComponents *tempMonthDayShiftDateComp = [[NSDateComponents alloc] init];
        if ([tempMonthDateComp weekday] == 1){
            [tempMonthDayShiftDateComp setDay:-7];
        }
        else{
            [tempMonthDayShiftDateComp setDay:(0 - ([tempMonthDateComp weekday] - 1))];
        }
        NSDate *firstMonthDate = [calendar dateByAddingComponents:tempMonthDayShiftDateComp toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempMonthDateComp year], [tempMonthDateComp month]]] options:0];
        [tempMonthDayShiftDateComp setDay:1];
        
        //prepare for week
        NSDateComponents *tempWeekDayShiftComp = [[NSDateComponents alloc] init];
        [tempWeekDayShiftComp setDay:(0 - ([dayShowingDateComp weekday] - 1))];
        NSDate *firstWeekDate = [calendar dateByAddingComponents:tempWeekDayShiftComp toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [dayShowingDateComp year], [dayShowingDateComp month], [dayShowingDateComp day]]] options:0];
        [tempWeekDayShiftComp setDay:1];
        
        for (int i = 0; i < 42; i++) {
            [monthArr addObject:[dateFormatter stringFromDate:firstMonthDate]];
            [dayArr addObject:[dateFormatter stringFromDate:firstMonthDate]];
            firstMonthDate = [calendar dateByAddingComponents:tempMonthDayShiftDateComp toDate:firstMonthDate options:0];
        }
        
        for (int i = 0; i < 7; i++) {
            [weekArr addObject:[dateFormatter stringFromDate:firstWeekDate]];
            firstWeekDate = [calendar dateByAddingComponents:tempWeekDayShiftComp toDate:firstWeekDate options:0];
        }
        
        tempMonthDayShiftDateComp = nil;
        [tempMonthDayShiftDateComp release];
        tempMonthDayShiftDateComp = nil;
        firstMonthDate = nil;
        [tempWeekDayShiftComp release];
        tempWeekDayShiftComp = nil;
        firstWeekDate = nil;
    }
    return self;
}

-(NSString *) getMonthViewDay:(NSInteger)index{
    NSDateComponents *tempMonthViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[monthArr objectAtIndex:index]]];
    NSString *stringToReturn = [NSString stringWithFormat:@"%d", [tempMonthViewDay day]];
    tempMonthViewDay = nil;
    return stringToReturn;
}

-(NSString *) getMonthViewShowing{
    return [NSString stringWithFormat:@"%d年%d月", [dayShowingDateComp year], [dayShowingDateComp month]];
}

+(NSString *) retrieveDate{
    //    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbName];
//    NSMutableString *dbPath=[[NSMutableString alloc]init];
//    [dbPath setString:[MShareDB dbPath]];
    NSString *dbPath = [AIAUtils PathIAppPrivateDB];
    sqlite3 *database;
    NSString *str = @"";
    NSMutableString *queryStr = [[NSMutableString alloc] init];
    const char *query;
    sqlite3_stmt *statment;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
        [queryStr setString:@""];
        [queryStr appendString:@"SELECT "];
        [queryStr appendString:@"\"WeatherInfo\".\"location\" "];
        [queryStr appendString:@"FROM "];
        [queryStr appendString:@"\"main\".\"WeatherInfo\" "];
        [queryStr appendString:@"WHERE "];
        [queryStr appendString:@"\"WeatherInfo\".\"id\"=5;"];
        
        query = [queryStr UTF8String];
        
        if (sqlite3_prepare_v2(database, query, -1, &statment, nil) == SQLITE_OK){
            while (sqlite3_step(statment) == SQLITE_ROW) {
                str = [MyEncryptor descrypt:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statment, 0)]];
            }
            sqlite3_finalize(statment);
        }
        sqlite3_close(database);
    }
    dbPath = nil;
    [queryStr release];
    queryStr = nil;
    query = nil;
    statment = nil;
    return str;
}

-(void) resetMonthView{
    NSDateComponents *tempMonthDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [dayShowingDateComp year], [dayShowingDateComp month]]]];
    [monthArr removeAllObjects];
    NSDateComponents *tempMonthDayShiftDateComp = [[NSDateComponents alloc] init];
    if ([tempMonthDateComp weekday] == 1){
        [tempMonthDayShiftDateComp setDay:-7];
    }
    else{
        [tempMonthDayShiftDateComp setDay:(0 - ([tempMonthDateComp weekday] - 1))];
    }
    NSDate *firstMonthDate = [calendar dateByAddingComponents:tempMonthDayShiftDateComp toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempMonthDateComp year], [tempMonthDateComp month]]] options:0];
    [tempMonthDayShiftDateComp setDay:1];
    for (int i = 0; i < 42; i++) {
        [monthArr addObject:[dateFormatter stringFromDate:firstMonthDate]];
        firstMonthDate = [calendar dateByAddingComponents:tempMonthDayShiftDateComp toDate:firstMonthDate options:0];
    }
    if (([tempMonthDateComp month] == [currentDateComp month]) && ([tempMonthDateComp year] == [currentDateComp year])){
        dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [currentDateComp year], [currentDateComp month], [currentDateComp day]]]];
    }
    else{
        dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempMonthDateComp year], [tempMonthDateComp month]]]];
    }
    tempMonthDateComp = nil;
    [tempMonthDayShiftDateComp release];
    tempMonthDayShiftDateComp = nil;
    firstMonthDate = nil;
}

-(BOOL) isMonthDaySameMonth:(NSInteger)index{
    NSDateComponents *tempMonthViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[monthArr objectAtIndex:index]]];
    if (([tempMonthViewDay month] == [dayShowingDateComp month]) && ([tempMonthViewDay year] && [dayShowingDateComp year])){
        tempMonthViewDay = nil;
        return YES;
    }
    tempMonthViewDay = nil;
    return NO;
}

-(BOOL) isMonthDayToday:(NSInteger)index{
    NSDateComponents *tempMonthViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[monthArr objectAtIndex:index]]];
    if (([tempMonthViewDay day] == [currentDateComp day]) && ([tempMonthViewDay month] == [currentDateComp month]) && ([tempMonthViewDay year] == [currentDateComp year])){
        tempMonthViewDay = nil;
        return YES;
    }
    tempMonthViewDay = nil;
    return NO;
}

-(BOOL) isMonthAllow:(NSInteger)offset{
    NSDateComponents *tempOffset = [[NSDateComponents alloc] init];
    [tempOffset setMonth:offset];
    
    NSDateComponents *tempDiff = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [currentDateComp year], [currentDateComp month]]] toDate:[calendar dateByAddingComponents:tempOffset toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [dayShowingDateComp year], [dayShowingDateComp month]]] options:0] options:0];
    
    if (([tempDiff month] > -7) && ([tempDiff month] < 7)){
        [monthArr removeAllObjects];
        
        NSDateComponents *tempMonthDateComp = [calendar components:calendarUnit fromDate:[calendar dateByAddingComponents:tempOffset toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [dayShowingDateComp year], [dayShowingDateComp month]]] options:0]];
        NSDateComponents *tempMonthDayShiftDateComp = [[NSDateComponents alloc] init];
        if ([tempMonthDateComp weekday] == 1){
            [tempMonthDayShiftDateComp setDay:-7];
        }
        else{
            [tempMonthDayShiftDateComp setDay:(0 - ([tempMonthDateComp weekday] - 1))];
        }
        NSDate *firstMonthDate = [calendar dateByAddingComponents:tempMonthDayShiftDateComp toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempMonthDateComp year], [tempMonthDateComp month]]] options:0];
        [tempMonthDayShiftDateComp setDay:1];
        for (int i = 0; i < 42; i++) {
            [monthArr addObject:[dateFormatter stringFromDate:firstMonthDate]];
            firstMonthDate = [calendar dateByAddingComponents:tempMonthDayShiftDateComp toDate:firstMonthDate options:0];
        }
        if (([tempMonthDateComp month] == [currentDateComp month]) && ([tempMonthDateComp year] == [currentDateComp year])){
            dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [currentDateComp year], [currentDateComp month], [currentDateComp day]]]];
        }
        else{
            dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempMonthDateComp year], [tempMonthDateComp month]]]];
        }
        
        [tempOffset release];
        tempOffset = nil;
        tempDiff = nil;
        tempMonthDateComp = nil;
        [tempMonthDayShiftDateComp release];
        tempMonthDayShiftDateComp = nil;
        firstMonthDate = nil;
        return YES;
    }
    [tempOffset release];
    tempOffset = nil;
    tempDiff = nil;
    return NO;
}

-(NSString *) getWeekViewDay:(NSInteger)index{
    NSDateComponents *tempWeekViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[weekArr objectAtIndex:index]]];
    NSString *stringToReturn = [NSString stringWithFormat:@"%d", [tempWeekViewDay day]];
    tempWeekViewDay = nil;
    return stringToReturn;
}

-(NSString *) getWeekViewShowing{
    NSDateComponents *tempFirstDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[weekArr objectAtIndex:0]]];
    NSDateComponents *tempLastDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[weekArr objectAtIndex:6]]];
    NSString *stringToReturn;
    if ([tempFirstDay year] == [tempLastDay year]){
        if ([tempFirstDay month] == [tempLastDay month]){
            stringToReturn = [NSString stringWithFormat:@"%d年%d月", [tempLastDay year], [tempLastDay month]];
        }
        else{
            stringToReturn = [NSString stringWithFormat:@"%d年%d月至%d月", [tempFirstDay year], [tempFirstDay month], [tempLastDay month]];
        }
    }
    else{
        stringToReturn = [NSString stringWithFormat:@"%d年%d月至%d年%d月", [tempFirstDay year], [tempFirstDay month], [tempLastDay year], [tempLastDay month]];
        
    }
    tempFirstDay = nil;
    tempLastDay = nil;
    return stringToReturn;
}

-(CGRect) getWeekCurrentTimeRect{
    return CGRectMake(81, ((4 + ([currentDateComp hour] * 44)) + ([currentDateComp minute] * 44 / 60)), 916, 6);
}

-(void) resetWeekView{
    NSDateComponents *tempWeekDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [dayShowingDateComp year], [dayShowingDateComp month], [dayShowingDateComp day]]]];
    [weekArr removeAllObjects];
    NSDateComponents *tempWeekDayShiftDateComp = [[NSDateComponents alloc] init];
    [tempWeekDayShiftDateComp setDay:(0 - ([tempWeekDateComp weekday] - 1))];
    NSDate *firstWeekDate = [calendar dateByAddingComponents:tempWeekDayShiftDateComp toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekDateComp year], [tempWeekDateComp month], [tempWeekDateComp day]]] options:0];
    [tempWeekDayShiftDateComp setDay:1];
    for (int i = 0; i < 7; i++) {
        [weekArr addObject:[dateFormatter stringFromDate:firstWeekDate]];
        firstWeekDate = [calendar dateByAddingComponents:tempWeekDayShiftDateComp toDate:firstWeekDate options:0];
    }
    if (([tempWeekDateComp week] == [currentDateComp week]) && ([tempWeekDateComp year] == [currentDateComp year])){
        dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [currentDateComp year], [currentDateComp month], [currentDateComp day]]]];
    }
    else{
        dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekDateComp year], [tempWeekDateComp month], [tempWeekDateComp day]]]];
    }
    tempWeekDateComp = nil;
    [tempWeekDayShiftDateComp release];
    tempWeekDayShiftDateComp = nil;
    firstWeekDate = nil;
}

-(BOOL) isWeekDayToday:(NSInteger)index{
    NSDateComponents *tempWeekViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[weekArr objectAtIndex:index]]];
    if (([tempWeekViewDay day] == [currentDateComp day]) && ([tempWeekViewDay month] == [currentDateComp month]) && ([tempWeekViewDay year] == [currentDateComp year])){
        tempWeekViewDay = nil;
        return YES;
    }
    tempWeekViewDay = nil;
    return NO;
}

-(BOOL) isWeekAllow:(NSInteger)offset{
    NSDateComponents *tempOffset = [[NSDateComponents alloc] init];
    [tempOffset setWeek:offset];
    
    NSDateComponents *tempWeekFirstDateComp = [calendar components:calendarUnit fromDate:[calendar dateByAddingComponents:tempOffset toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [dayShowingDateComp year], [dayShowingDateComp month], [dayShowingDateComp day]]] options:0]];
    NSDateComponents *tempWeekLastDateComp = [calendar components:calendarUnit fromDate:[calendar dateByAddingComponents:tempOffset toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [dayShowingDateComp year], [dayShowingDateComp month], [dayShowingDateComp day]]] options:0]];
    NSDateComponents *tempWeekdayDiff = [[NSDateComponents alloc] init];
    [tempWeekdayDiff setDay:(0 - ([tempWeekFirstDateComp weekday] - 1))];
    tempWeekFirstDateComp = [calendar components:calendarUnit fromDate:[calendar dateByAddingComponents:tempWeekdayDiff toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekFirstDateComp year], [tempWeekFirstDateComp month], [tempWeekFirstDateComp day]]] options:0]];
    [tempWeekdayDiff setDay:(7 - [tempWeekLastDateComp weekday])];
    tempWeekLastDateComp = [calendar components:calendarUnit fromDate:[calendar dateByAddingComponents:tempWeekdayDiff toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekLastDateComp year], [tempWeekLastDateComp month], [tempWeekLastDateComp day]]] options:0]];
    NSDateComponents *tempWeekMonthDiff = [[NSDateComponents alloc] init];
    if (offset > 0){
        tempWeekMonthDiff = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [currentDateComp year], [currentDateComp month]]] toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekFirstDateComp year], [tempWeekFirstDateComp month], [tempWeekFirstDateComp day]]] options:0];
        
    }
    else{
        tempWeekMonthDiff = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [currentDateComp year], [currentDateComp month]]] toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekLastDateComp year], [tempWeekLastDateComp month], [tempWeekLastDateComp day]]] options:0];
    }
    if (([tempWeekMonthDiff month] > -6) && ([tempWeekMonthDiff month] < 6)){
        [weekArr removeAllObjects];
        NSDate *tempFirstDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekFirstDateComp year], [tempWeekFirstDateComp month], [tempWeekFirstDateComp day]]];
        [tempWeekdayDiff setDay:1];
        for (int i= 0; i < 7; i++) {
            [weekArr addObject:[dateFormatter stringFromDate:tempFirstDate]];
            tempFirstDate = [calendar dateByAddingComponents:tempWeekdayDiff toDate:tempFirstDate options:0];
        }
        if ([tempWeekFirstDateComp week] == [currentDateComp week] && [tempWeekFirstDateComp year] == [currentDateComp year]){
            dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [currentDateComp year], [currentDateComp month], [currentDateComp day]]]];
        }
        else{
            dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [tempWeekFirstDateComp year], [tempWeekFirstDateComp month], [tempWeekFirstDateComp day]]]];
        }
        [tempOffset release];
        tempOffset = nil;
        tempWeekFirstDateComp = nil;
        tempWeekLastDateComp = nil;
        [tempWeekdayDiff release];
        tempWeekdayDiff = nil;
        tempWeekMonthDiff = nil;
        tempFirstDate = nil;
        return YES;
    }
    [tempOffset release];
    tempOffset = nil;
    tempWeekFirstDateComp = nil;
    tempWeekLastDateComp = nil;
    [tempWeekdayDiff release];
    tempWeekdayDiff = nil;
    tempWeekMonthDiff = nil;
    return NO;
}

-(NSString *) getDayViewDay:(NSInteger)index{
    NSDateComponents *tempDayViewDay  =[calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:index]]];
    NSString *stringToReturn = [NSString stringWithFormat:@"%d", [tempDayViewDay day]];
    tempDayViewDay = nil;
    return stringToReturn;
}

-(NSString *) getDayViewDateForDB:(NSInteger)index{
    return [dateFormatter stringFromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:index]]];
}

-(NSString *) getDayViewShowing{
    return [NSString stringWithFormat:@"%d年%d月%d日", [dayShowingDateComp year], [dayShowingDateComp month], [dayShowingDateComp day]];
}

-(NSString *) getDayMonthViewShowing{
    NSDateComponents *tempDayMonthDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:10]]];
    NSString *stringToReturn = [NSString stringWithFormat:@"%d年%d月", [tempDayMonthDateComp year], [tempDayMonthDateComp month]];
    tempDayMonthDateComp = nil;
    return stringToReturn;
}

-(NSString *)getDayMonthViewShowingDateStr{
    return [dateFormatter stringFromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d", [dayShowingDateComp year], [dayShowingDateComp month], [dayShowingDateComp day]]]];
}

-(void) setDayViewShowing:(NSInteger)index{
    dayShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:index]]];
}

+(BOOL) verifyDate:(NSArray *)dateArr{
    BOOL pass = NO;
    NSString *service = @"";
    NSDictionary *data = [NSDictionary dictionary];
    for (NSDictionary *dict in dateArr) {
        if ([[dict objectForKey:@"key"] isEqualToString:@"Service"]) {
            service = [dict objectForKey:@"value"];
        }
        else if ([[dict objectForKey:@"key"] isEqualToString:@"Data"]){
            SBJsonParser *analysis = [[SBJsonParser alloc] init];
            data = [analysis objectWithString:[dict objectForKey:@"value"]];
            [analysis release];
            analysis = nil;
        }
    }
    //    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbName];
//    NSMutableString *dbPath=[[NSMutableString alloc]init];
//    [dbPath setString:[MShareDB dbPath]];
    NSString *dbPath = [AIAUtils PathIAppPrivateDB];
    sqlite3 *database;
    NSArray *tempArray0 = [NSArray array];
    NSArray *tempArray1 = [NSArray array];
    NSMutableString *queryStr = [[NSMutableString alloc] init];
    const char *query;
    sqlite3_stmt *statment;
    
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
        [queryStr setString:@""];
        [queryStr appendString:@"SELECT "];
        [queryStr appendString:@"\"WeatherInfo\".\"location\" "];
        [queryStr appendString:@"FROM "];
        [queryStr appendString:@"\"main\".\"WeatherInfo\" "];
        [queryStr appendString:@"WHERE "];
        [queryStr appendString:@"\"WeatherInfo\".\"id\"=4;"];
        
        query = [queryStr UTF8String];
        
        if (sqlite3_prepare_v2(database, query, -1, &statment, nil) == SQLITE_OK){
            while (sqlite3_step(statment) == SQLITE_ROW) {
                tempArray0 = [[MyEncryptor descrypt:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statment, 0)]] componentsSeparatedByString:@","];
            }
            sqlite3_finalize(statment);
        }
        
        [queryStr setString:@""];
        [queryStr appendString:@"SELECT "];
        [queryStr appendString:@"\"WeatherInfo\".\"location\" "];
        [queryStr appendString:@"FROM "];
        [queryStr appendString:@"\"main\".\"WeatherInfo\" "];
        [queryStr appendString:@"WHERE "];
        [queryStr appendString:@"\"WeatherInfo\".\"id\"=3;"];
        
        query = [queryStr UTF8String];
        
        if (sqlite3_prepare_v2(database, query, -1, &statment, nil) == SQLITE_OK){
            while (sqlite3_step(statment) == SQLITE_ROW) {
                tempArray1 = [[MyEncryptor descrypt:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statment, 0)]] componentsSeparatedByString:@","];
            }
            sqlite3_finalize(statment);
        }
        sqlite3_close(database);
    }
    if (([tempArray0 count] > 0) && ([tempArray1 count] > 0)) {
        if ([service isEqualToString:[tempArray0 objectAtIndex:0]]) {
            if ([[[data objectForKey:[tempArray0 objectAtIndex:1]] objectForKey:[tempArray0 objectAtIndex:2]] isEqualToString:[tempArray0 objectAtIndex:3]]){
                for (int i = 0; i < ([tempArray1 count] / 2); i++) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
                    [formatter setDateFormat:@"yyyyMMddHHmmss"];
                    
                    NSDate *dateStr0 = [formatter dateFromString:[tempArray1 objectAtIndex:(2 * i)]];
                    NSDate *dateStr1 = [formatter dateFromString:[tempArray1 objectAtIndex:((2 * i) + 1)]];
                    [formatter release];
                    formatter = nil;
                    if (([[NSDate date] compare:dateStr0] >= 0) && ([[NSDate date] compare:dateStr1] <= 0)){
                        pass = YES;
                        break;
                    }
                }
            }
        }
    }
    
    dbPath = nil;
    tempArray0 = nil;
    tempArray1 = nil;
    [queryStr release];
    queryStr = nil;
    query = nil;
    statment = nil;
    return pass;
}

-(BOOL) isDaySameMonth:(NSInteger)index{
    NSDateComponents *tempDayMonthViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:10]]];
    NSDateComponents *tempDayViewDay = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:index]]];
    if (([tempDayViewDay month] == [tempDayMonthViewDay month]) && ([tempDayViewDay year] && [tempDayMonthViewDay year])){
        tempDayMonthViewDay = nil;
        tempDayViewDay = nil;
        return YES;
    }
    tempDayMonthViewDay = nil;
    tempDayViewDay = nil;
    return NO;
}

-(BOOL) isDayToday:(NSInteger)index{
    NSDateComponents *tempDayViewDay  =[calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:index]]];
    if (([tempDayViewDay day] == [currentDateComp day]) && ([tempDayViewDay month] == [dayShowingDateComp month]) && ([tempDayViewDay year] == [dayShowingDateComp year])){
        tempDayViewDay = nil;
        return YES;
    }
    return NO;
}

-(BOOL)isDayMonthAllow:(NSInteger)offset{
    NSDateComponents *tempOffset = [[NSDateComponents alloc] init];
    [tempOffset setMonth:offset];
    
    NSDateComponents *tempDayMonthShowingDateComp = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:10]]];
    
    NSDateComponents *tempDiff = [calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [currentDateComp year], [currentDateComp month]]] toDate:[calendar dateByAddingComponents:tempOffset toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempDayMonthShowingDateComp year], [tempDayMonthShowingDateComp month]]] options:0] options:0];
    
    if (([tempDiff month] > -7) && ([tempDiff month] < 7)){
        [dayArr removeAllObjects];
        
        NSDateComponents *tempDayMonthDateComp = [calendar components:calendarUnit fromDate:[calendar dateByAddingComponents:tempOffset toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempDayMonthShowingDateComp year], [tempDayMonthShowingDateComp month]]] options:0]];
        NSDateComponents *tempDayMonthDayShiftDateComp = [[NSDateComponents alloc] init];
        if ([tempDayMonthDateComp weekday] == 1){
            [tempDayMonthDayShiftDateComp setDay:-7];
        }
        else{
            [tempDayMonthDayShiftDateComp setDay:(0 - ([tempDayMonthDateComp weekday] - 1))];
        }
        NSDate *firstMonthDate = [calendar dateByAddingComponents:tempDayMonthDayShiftDateComp toDate:[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-01", [tempDayMonthDateComp year], [tempDayMonthDateComp month]]] options:0];
        [tempDayMonthDayShiftDateComp setDay:1];
        for (int i = 0; i < 42; i++) {
            [dayArr addObject:[dateFormatter stringFromDate:firstMonthDate]];
            firstMonthDate = [calendar dateByAddingComponents:tempDayMonthDayShiftDateComp toDate:firstMonthDate options:0];
        }
        
        [tempOffset release];
        tempOffset = nil;
        tempDiff = nil;
        tempDayMonthDateComp = nil;
        [tempDayMonthDayShiftDateComp release];
        tempDayMonthDayShiftDateComp = nil;
        firstMonthDate = nil;
        return YES;
    }
    [tempOffset release];
    tempOffset = nil;
    tempDiff = nil;
    return NO;
}

-(BOOL) isDayShowing:(NSInteger)index{
    NSDateComponents *tempDayViewDay  =[calendar components:calendarUnit fromDate:[dateFormatter dateFromString:[dayArr objectAtIndex:index]]];
    if (([tempDayViewDay day] == [dayShowingDateComp day]) && ([tempDayViewDay month] == [dayShowingDateComp month]) && ([tempDayViewDay year] == [dayShowingDateComp year])){
        tempDayViewDay = nil;
        return YES;
    }
    return NO;
}

-(BOOL) isToday{
    NSString *todayStr = [dateTimeFormatterForDB stringFromDate:[NSDate date]];
    todayStr = nil;
    return NO;
}

-(CGRect) getDayCurrentTimeRect{
    return CGRectMake(42, ([currentDateComp hour] * (1058.0f / 24.0f) + ([currentDateComp minute] * (1058.0f / (24.0f * 60.0f)))) + 16, 415, 6);
}



-(NSString *)getDateStringForDB:(NSDate *)dateVal{
    return [dateFormatterForDB stringFromDate:dateVal];
}

//-(NSString *) getCurrentDateString{
//    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
//}

-(void) dealloc{
    [dateTimeLocale release];
    dateTimeLocale = nil;
    
    [syncDateFormatter release];
    syncDateFormatter = nil;
    [dateFormatter release];
    dateFormatter = nil;
    [dateTimeFormatter release];
    dateTimeFormatter = nil;
    [homeDateFormatter release];
    homeDateFormatter = nil;
    [chiDateTimeFormatter release];
    chiDateTimeFormatter = nil;
    [calendar release];
    calendar = nil;
    currentDateComp = nil;
    dayShowingDateComp = nil;
    [monthArr removeAllObjects];
    [monthArr release];
    monthArr = nil;
    [weekArr removeAllObjects];
    [weekArr release];
    weekArr = nil;
    [dayArr removeAllObjects];
    [dayArr release];
    dayArr = nil;
    [super dealloc];
}

@end
