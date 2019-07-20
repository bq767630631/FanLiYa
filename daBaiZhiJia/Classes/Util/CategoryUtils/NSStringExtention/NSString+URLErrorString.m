//
//  NSString+URLErrorString.m
//  zdbios
//
//  Created by skylink on 16/9/26.
//  Copyright © 2016年 skylink. All rights reserved.
//

#import "NSString+URLErrorString.h"

@implementation NSString (URLErrorString)

// http://blog.163.com/zhangtibin_iosdev/blog/static/240581024201672394022776/
//网络数据请求超时 DNS查询失败 HTTP请求重定向
+ (NSString *)urlErrorMsgWithError:(NSError *)error {

    NSString *errorMsg = @"未知网络错误";
    switch (error.code) {
        case NSURLErrorUnknown:                                      {} break;
        case NSURLErrorCancelled:                                    { errorMsg = @"网络连接取消"; } break;
        case NSURLErrorBadURL:                                       { errorMsg = @"无效的URL地址"; } break;
        case NSURLErrorTimedOut:                                     { errorMsg = @"网络连接超时"; } break;
        case NSURLErrorUnsupportedURL:                               { errorMsg = @"不支持的 URL 地址"; } break;
        case NSURLErrorCannotFindHost:                               { errorMsg = @"找不到服务器"; } break;
        case NSURLErrorCannotConnectToHost:                          { errorMsg = @"连接不上服务器"; } break;
        case NSURLErrorNetworkConnectionLost:                        { errorMsg = @"网络连接异常"; } break;
        case NSURLErrorDNSLookupFailed:                              { errorMsg = @"DNS查询失败"; } break;
        case NSURLErrorHTTPTooManyRedirects:                         { errorMsg = @"HTTP请求重定向"; } break;
        case NSURLErrorResourceUnavailable:                          { errorMsg = @"资源不可用"; } break;
        case NSURLErrorNotConnectedToInternet:                       { errorMsg = @"无网络连接"; } break;
        case NSURLErrorRedirectToNonExistentLocation:                { errorMsg = @"重定向到不存在的位置"; } break;
        case NSURLErrorBadServerResponse:                            { errorMsg = @"服务器异常响应"; } break;
        case NSURLErrorUserCancelledAuthentication:                  { errorMsg = @"用户取消授权"; } break;
        case NSURLErrorUserAuthenticationRequired:                   { errorMsg = @"需要取消授权"; } break;
        case NSURLErrorZeroByteResource:                             { errorMsg = @"零字节资源"; } break;
        case NSURLErrorCannotDecodeRawData:                          { errorMsg = @"无法解码原始数据"; } break;
        case NSURLErrorCannotDecodeContentData:                      { errorMsg = @"无法解码内容数据"; } break;
        case NSURLErrorCannotParseResponse:                          { errorMsg = @"无法解析响应"; } break;
        case NSURLErrorAppTransportSecurityRequiresSecureConnection: {} break;
        case NSURLErrorFileDoesNotExist:                             { errorMsg = @"文件不存在"; } break;
        case NSURLErrorFileIsDirectory:                              { errorMsg = @"文件是个目录"; } break;
        case NSURLErrorNoPermissionsToReadFile:                      { errorMsg = @"无读取文件权限"; } break;
        case NSURLErrorDataLengthExceedsMaximum:                     { errorMsg = @"请求数据长度超出最大限度"; } break;
        default:
            break;
    }
    
    return errorMsg;
}

@end
