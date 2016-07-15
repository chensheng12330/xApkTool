//
//  XMLReplace.h
//  XmlRW
//
//  Created by sherwin.chen on 16/7/14.
//  Copyright © 2016年 Sherwin.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"

typedef NS_ENUM(NSUInteger, XM_ECODE) {
    XME_InfoPlist,
};

@interface XMLReplace : NSObject

@property (nonatomic, strong) NSString *strShellPath;
@property (nonatomic, strong) NSString *strInfoPlistPath;
@property (nonatomic, strong) NSString *strCopyAPPDirPath;

-(int)startWorker;

@end
