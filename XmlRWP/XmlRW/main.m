//
//  main.m
//  XmlRW
//
//  Created by sherwin.chen on 16/7/14.
//  Copyright © 2016年 Sherwin.Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMLReplace.h"

//./XmlRW "/Volumes/Data/SVN_Code/AndPK/xcar_data/Info.plist" "/Volumes/Data/SVN_Code/AndPK/workspace/temp20160714100848/X_CHEN"
void help()
{
    printf("*****************XmlRW 使用帮助*****************\n");
    printf("**使用参数：XmlRW <info.plist PATH> <CopyAPPDirPath>\n");
    printf("**参数1说明：<info.plist PATH> 资源配置项文件全路径值.\n");
    printf("**参数2说明：<CopyAPPDirPath>  已解包IPA后生成的文件夹全路径值.\n");
    printf("**案例参考: ./XmlRW \"/Volumes/Data/SVN_Code/AndPK/xcar_data/Info.plist\" \"/workspace/temp20160714100848/X_CHEN\"\n");
    printf("***********************************************\r\n");
    
    return;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        for (int i=0; i<argc; i++) {
//            printf("%s\n",argv[i]);
//        }
        
        if (argc==2) {
            char *para1 = (char *)argv[1];
            printf("%s",para1);
            
            if (strcmp(para1, "-help")==0) {
                help();
            }
            return 0;
        }
        
        printf("----------------------------------------------------------------------\r\n\n\n");
        printf("   深蓝蕴车极视Android参数配置工具 v1.0 20160715 by Sherwin\n");
        printf("----------------------------------------------------------------------\r\n\n\n");
        
        if (argc==3) {
            XMLReplace *xmlRW = [[XMLReplace alloc] init];
            xmlRW.strInfoPlistPath  = [NSString stringWithUTF8String:argv[1]];
            xmlRW.strCopyAPPDirPath = [NSString stringWithUTF8String:argv[2]];
            
            [xmlRW startWorker];
        }
        
    }
    return 0;
}
