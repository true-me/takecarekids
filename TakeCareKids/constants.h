//
//  constants.h
//  OCTraining
//
//  Created by Jeffrey Ma on 6/16/13.
//  Copyright (c) 2013 Jeffrey Ma. All rights reserved.
//
#ifndef MMPDLog
#ifdef DEBUG
#define MMPDLog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define MMPDLog(...) do { } while (0)
#endif
#endif

#ifndef MMPALog
#define MMPALog(format, ...) NSLog((@"%s [Line %d] " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#endif

/*--------------------Iphone5 的判断------------------------------------------------------*/
#define IS_IPHONE_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define REST_API_URL @"http://125.76.234.67:8080/alarm/rest.do?meth="
#define REST_API_HOST @"125.76.234.67"
#define REST_API_KEY @"atestkey"