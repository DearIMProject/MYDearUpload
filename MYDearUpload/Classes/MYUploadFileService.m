//
//  MYUploadFileService.m
//  MYDearUpload
//
//  Created by APPLE on 2023/12/29.
//

#import "MYUploadFileService.h"
#import <YYModel/YYModel.h>
#import <MYNetwork/MYNetwork.h>
#import <MYDearUser/MYDearUser.h>

@interface MYUploadFileService ()

@end

@implementation MYUploadFileService

- (void)uploadFilePath:(NSString *)filePath
          withprogress:(void (^)(CGFloat))progressBlock
               success:(void (^)(void))success
               failure:(void (^)(NSError * _Nonnull))failure {
    
    NSString *fileName;
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",MYNetworkManager.shared.getHost,@"/file/upload",@""];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 设置响应数据类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 60;
    
    // 添加需要上传的文件
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
    
    NSMutableDictionary *param = @{}.mutableCopy;
    param[@"token"] = TheUserManager.user.token;
    
    // 设置上传进度回调
    [manager POST:urlString
       parameters:param
          headers:nil
constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData
                                    name:@"file"
                                fileName:filePath.lastPathComponent
                                mimeType:@"text/plain"];
    }
         progress:^(NSProgress *uploadProgress) {
        // 获取上传进度
        CGFloat progress = (CGFloat)uploadProgress.completedUnitCount / (CGFloat)uploadProgress.totalUnitCount;
        NSLog(@"上传进度: %.2f%%", progress * 100);
        if (progressBlock) {
            progressBlock(progress);
        }
    }
          success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
        MYResponseModel *model = [MYResponseModel yy_modelWithDictionary:responseObject];
        if (model.success) {
            if (success) {
                success();
            }
        } else {
            NSError *error = [NSError errorWithDomain:model.data[@"errorMsg"] code:1 userInfo:nil];
            if (failure) {
                failure(error);
            }
        }
    }
          failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传失败: %@", error);
        // 处理失败的响应
        if (failure){
            failure(error);
        }
    }];
}

@end
