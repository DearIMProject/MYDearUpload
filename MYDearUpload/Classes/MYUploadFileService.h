//
//  MYUploadFileService.h
//  MYDearUpload
//
//  Created by APPLE on 2023/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYUploadFileService : NSObject

/// 上传文件接口
/// - Parameters:
///   - filePath: 文件路径
///   - progressBlock: 上传进度条
///   - success: 上传成功
///   - failure: 上传失败
- (void)uploadFilePath:(NSString *)filePath
          withprogress:(void(^)(CGFloat progress))progressBlock
               success:(void(^)(void))success
               failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
