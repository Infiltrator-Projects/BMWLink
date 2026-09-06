// SPDX-License-Identifier: GPL-3.0-or-later
#import <Foundation/Foundation.h>
#import "../../src/link/platform/apple/LinkDiagnosticsController.h"

NS_ASSUME_NONNULL_BEGIN
@class BmwLinkDiagnosticsController;
@protocol BmwLinkDiagnosticsControllerDelegate <NSObject>
- (void)diagnosticsControllerDidUpdate:(BmwLinkDiagnosticsController *)controller;
@end

@interface BmwLinkDiagnosticsController : LinkProductDiagnosticsController
- (instancetype)init;
@property(nonatomic, weak, nullable) id<BmwLinkDiagnosticsControllerDelegate> delegate;
@end
NS_ASSUME_NONNULL_END
