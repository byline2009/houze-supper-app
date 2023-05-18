//
//  ZPAutoDebitDelegete.h
//  zpdk
//
//  Created by Nguyen Van Nghia on 10/1/20.
//  Copyright © 2020 VNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPaymentErrorCode.h"

typedef enum: NSInteger {
    BindingStatusSuccess = 1,
    BindingStatusFail = 0
} BindingStatus;

@protocol ZPConfirmAutoDebitDelegate <NSObject>
- (void)bindingDidComplete:(NSString * _Nonnull)bindingId stauts:(BindingStatus)status extra:(NSDictionary * _Nonnull)extra;
@end
