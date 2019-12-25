//
//  PrinterExecutorByZebraBitmap.h
//  Runner
//
//  Created by ebestmobile on 2019/12/23.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrinterExecutorByZebraBitmap : NSObject

@property (nonatomic) NSString *address;
@property (nonatomic) NSString *imgPath;

- (void)printByAddress;

@end

NS_ASSUME_NONNULL_END
