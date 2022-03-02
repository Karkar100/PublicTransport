//
//  JMMulticastDelegate.h
//  BottomSheet
//
//  Created by Diana Princess on 27.02.2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(MulticastDelegate)
@interface JMMulticastDelegate : NSObject

- (instancetype)initWithTarget:(id)target
                delegateGetter:(SEL)delegateGetter
                delegateSetter:(SEL)delegateSetter NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)addDelegate:(id)delegate NS_SWIFT_NAME(addDelegate(_:));

- (void)removeDelegate:(id)delegate NS_SWIFT_NAME(removeDelegate(_:));

@end

NS_ASSUME_NONNULL_END
