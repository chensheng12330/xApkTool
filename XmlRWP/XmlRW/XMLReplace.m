//
//  XMLReplace.m
//  XmlRW
//
//  Created by sherwin.chen on 16/7/14.
//  Copyright © 2016年 Sherwin.Chen. All rights reserved.
//

#import "XMLReplace.h"

#define CFBundleDisplayName (@"CFBundleDisplayName")
#define CFBundleDisplayName_en (@"CFBundleDisplayName_en")
#define CFBundleVersion (@"CFBundleVersion")
#define app_agent_id        (@"app_agent_id")
#define app_baidumap_key    (@"app_baidumap_key")
#define app_company_info    (@"app_company_info")
#define app_server_host     (@"app_server_host")
#define app_version_code    (@"app_version_code")
#define qzone_appid         (@"qzone_appid")
#define qzone_key           (@"qzone_key")
#define wx_app_secret       (@"wx_app_secret")
#define wx_appid            (@"wx_appid")
#define SUPPORT_4G          (@"SUPPORT_4G")
@implementation XMLReplace

-(int) startWorker
{
    //当前脚本执行径文件夹
    //NSString *shellPath = self.strShellPath;//@"/Volumes/Data/SVN_Code/AndPK/";
    printf("=========================================================\r\n");
    printf("---> 0x01 正在检查Info.plist是否配置完整...\n");
    
    //info.plist路径,用做数据源
    NSString *infoPlistPath = self.strInfoPlistPath;//[NSString stringWithFormat:@"%@/xcar_data/Info.plist",shellPath];
    
    NSDictionary *dataSource=[[NSDictionary alloc] initWithContentsOfFile:infoPlistPath];
    if (dataSource.count<1) {
        printf("--->[EOR] 0x01 info.plist数据不完整，请重新配置。");
        return XME_InfoPlist;
    }

    
    printf("--->[OK] 0x02 正在程序名称/公司名称...\n");
    
    NSString *copyAPPDir=self.strCopyAPPDirPath; //@"/workspace/temp20160714100848/X_CHEN";
    
    //修改程序名称：
    //修改公司名称：
    NSString *txtXML_en = [NSString stringWithFormat:@"%@/res/values/strings.xml",copyAPPDir];
    NSString *txtXML_ch = [NSString stringWithFormat:@"%@/res/values-zh/strings.xml",copyAPPDir];
    
    if (txtXML_ch.length<1 || txtXML_en.length<1 ) {
        printf("--->[EOR] 0x02 /res/values/strings.xml || res/values-zh/strings.xml 文件有误，请重新配置... \r\n");
        return 2;
    }
    
   
    [self updateAPPName:txtXML_en rpData:@{@"app_name":dataSource[CFBundleDisplayName],
                                           @"me_copy_right":[NSString stringWithFormat:@"CopyRight&#169; 2015&#8211;2017 %@ All rights reserved",dataSource[app_company_info]]}];
    
    [self updateAPPName:txtXML_ch rpData:@{@"app_name":dataSource[CFBundleDisplayName_en],
                                           @"me_copy_right":[NSString stringWithFormat:@"CopyRight&#169; 2015&#8211;2017 %@ All rights reserved",dataSource[app_company_info]]}];
    
    printf("--->[OK] 0x02 完成程序名称/公司名称修改. \r\n\n");
    
    
    //apkYML string
    //修改版本号：
    printf("---> 0x03 正在修改版本号...\n");
    NSString *apktoolYML = [NSString stringWithFormat:@"%@/apktool.yml",copyAPPDir];
    
    if (apktoolYML.length<1) {
        printf("--->[EOR] 0x03 /apktool.yml 文件有误，请重新配置... \r\n");
        return 3;
    }
    
    [self updateVersion:apktoolYML versionCode:[NSString stringWithFormat:@"'%@'",dataSource[app_version_code]] versionName:dataSource[CFBundleVersion]];
    printf("--->[OK] 0x03 完成版本号修改. \r\n\n");
    
    
    printf("---> 0x04 正在修改AndroidManifest.xml相关配置项目...\n");
    //修改\AndroidManifest.xm
    NSString *manifest = [NSString stringWithFormat:@"%@/AndroidManifest.xml",copyAPPDir];
    
    //dataSource[SUPPORT_4G]
    NSString *sp4g = dataSource[SUPPORT_4G];
    if (sp4g==NULL || [sp4g boolValue] ) {
        sp4g = @"true";
    }
    else{
        sp4g = @"false";
    }
    
    //PARAM.AGENT_ID
    NSDictionary *rpData = @{@"com.baidu.lbsapi.API_KEY":dataSource[app_baidumap_key],
                             @"PARAM.BASE_URL":[NSString stringWithFormat:@"http://%@",dataSource[app_server_host]],
                             @"PARAM.AGENT_ID":dataSource[app_agent_id],
                             @"PARAM.SHARE.QQ.APPID":dataSource[qzone_appid],
                             @"PARAM.SHARE.QQ.APPKEY":dataSource[qzone_key],
                             @"PARAM.SHARE.WEIXIN.APPSECRET":dataSource[wx_app_secret],
                             @"PARAM.SHARE.WEIXIN.APPID":dataSource[wx_appid],
                             @"PARAM.IS_SUPPORT_4G":sp4g
                             };
    
    [self updateAndroidManifestPath:manifest rpData:rpData];
    printf("--->[OK] 0x04 已完成AndroidManifest.xml相关配置项目...\n");
    printf("=========================================================\r\n");
    printf("--->[OK] 参数设置完成\n");
    return 0;
    
}


-(void) updateAPPName:(NSString*)path rpData:(NSDictionary*) rpData
{
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    
    NSArray *array = [xmlEle children];
    //NSLog(@"count : %d", [array count]);
    
    NSArray *keys = [rpData allKeys];
    int setCount=0;
    
    for (int i = 0; i < [array count]; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        
        for (int j=0; j<[keys count]; j++) {
            
            NSString *keyN = keys[j];
            
            if ([[[ele attributeForName:@"name"] stringValue] isEqualToString:keyN]) {
                
                NSString *valueN = rpData[keyN];
                
                [ele setStringValue:valueN];
                //NSLog(@"KEY值：%@ 设置值：%@",keyN,valueN);
                setCount++;
                
                if (setCount==keys.count) {
                    
                    //写入文件
                    [[xmlDoc XMLData] writeToFile:path atomically:YES];
                    
                    return;
                }
            }
        }
        
    }
}

-(NSRange) findReplaceRangForString:(NSString*) apkYML key:(NSString*) findkey
{
    NSRange vcRang= [apkYML rangeOfString:findkey options:NSBackwardsSearch];
    NSRange edRang = vcRang;
    edRang.location = vcRang.location+vcRang.length;
    
    NSUInteger edStrLen = 0;
    
    for (NSUInteger i=edRang.location; i<apkYML.length; i++) {
        unichar charStr = [apkYML characterAtIndex:i];
        if (charStr=='\n') {
            edStrLen = i - edRang.location;
            break;
        }
    }
    
    edRang.length = edStrLen;
    
    return edRang;
}

-(void) updateVersion:(NSString*)path  versionCode:(NSString*) vCode versionName:(NSString*) vName
{
    NSString *apkYML = [NSString stringWithContentsOfFile:path encoding:4 error:nil];
    //@"versionCode: "
    
    NSRange rang = [self findReplaceRangForString:apkYML key:@"versionCode: "];
    apkYML = [apkYML stringByReplacingCharactersInRange:rang withString:vCode];
    
    rang = [self findReplaceRangForString:apkYML key:@"versionName: "];
    apkYML = [apkYML stringByReplacingCharactersInRange:rang withString:vName];
    
    //NSLog(@"%@",apkYML);
    [apkYML writeToFile:path atomically:YES encoding:4 error:nil];
    
    return;
}

-(void) updateAndroidManifestPath:(NSString*) path rpData:(NSDictionary*) rpData
{
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithXMLString:xmlString options:0 error:nil];
    
    NSArray *array = [xmlDoc nodesForXPath:@"manifest/application/meta-data" error:nil];;
    
    NSArray *keys = [rpData allKeys];
    int setCount=0;
    
    for (int i = 0; i < [array count]; i++) {
        GDataXMLElement *ele = [array objectAtIndex:i];
        
        for (int j=0; j<[keys count]; j++) {
            
            NSString *keyN = keys[j];
            
            if ([[[ele attributeForName:@"name"] stringValue] isEqualToString:keyN]) {
                
                id valueN = rpData[keyN];
                if (![valueN isKindOfClass:[NSString class]]) {
                    valueN = [valueN stringValue];
                }
                
                [[ele attributeForName:@"value"] setStringValue:valueN];
                
                //NSLog(@"KEY值：%@ 设置值：%@",keyN,valueN);
                setCount++;
                
                if (setCount==keys.count) {
                    
                    //写入文件
                    //NSLog(@"%@",array);
                    [[xmlDoc XMLData] writeToFile:path atomically:YES];
                    
                    return;
                }
            }
        }
        
    }

}

@end
