// SPDX-License-Identifier: GPL-3.0-or-later
#import <Foundation/Foundation.h>
#import "../../src/link/platform/apple/LinkDiagnosticsController.h"

NS_ASSUME_NONNULL_BEGIN
@class BmwLinkDiagnosticsController;
@protocol BmwLinkDiagnosticsControllerDelegate <NSObject>
- (void)diagnosticsControllerDidUpdate:(BmwLinkDiagnosticsController *)controller;
@end

@interface BmwLinkDiagnosticsController : NSObject
@property(nonatomic, weak, nullable) id<BmwLinkDiagnosticsControllerDelegate> delegate;
@property(nonatomic, copy, readonly) NSString *statusText;
@property(nonatomic, copy, readonly, nullable) NSString *peripheralName;
@property(nonatomic, copy, readonly, nullable) NSString *adapterIdentifier;
@property(nonatomic, copy, readonly) NSString *vehicleVINText;
@property(nonatomic, copy, readonly) NSString *faultScanStatusText;
@property(nonatomic, copy, readonly) NSArray<NSString *> *storedDTCs;
@property(nonatomic, copy, readonly) NSArray<NSString *> *pendingDTCs;
@property(nonatomic, copy, readonly) NSArray<NSString *> *permanentDTCs;
@property(nonatomic, copy, readonly) NSString *readinessStatusText;
@property(nonatomic, copy, readonly) NSArray<NSString *> *readinessMonitorStatus;
@property(nonatomic, copy, readonly) NSArray<NSString *> *freezeFrameContext;
@property(nonatomic, copy, readonly) NSString *diagnosticCapabilityText;
@property(nonatomic, copy, readonly) NSString *diagnosticCapabilityDetailText;
@property(nonatomic, copy, readonly) NSString *standardResponderSummary;
@property(nonatomic, copy, readonly) NSString *supportedPIDSummary;
@property(nonatomic, copy, readonly) NSArray<NSString *> *standardLiveValueRows;
@property(nonatomic, readonly, getter=isActive) BOOL active;
@property(nonatomic, readonly, getter=isReady) BOOL ready;
@property(nonatomic, readonly) NSUInteger recordedSampleCount;
@property(nonatomic, copy, readonly) NSArray<NSString *> *availableLanguageTags;
@property(nonatomic, copy, readonly) NSArray<NSString *> *availableLanguageNames;
@property(nonatomic, copy, readonly) NSString *selectedLanguageTag;
@property(nonatomic, copy, readonly) NSArray<NSString *> *availableMeasurementSystemKeys;
@property(nonatomic, copy, readonly) NSArray<NSString *> *availableMeasurementSystemNames;
@property(nonatomic, copy, readonly) NSString *selectedMeasurementSystemKey;
@property(nonatomic, readonly) BOOL preferFavouriteSignals;
@property(nonatomic, readonly) BOOL showUnavailableParameters;
- (void)start;
- (void)disconnect;
- (NSString *)localizedTextForKey:(NSString *)key;
- (void)setSelectedLanguageTag:(NSString *)tag;
- (void)setSelectedMeasurementSystemKey:(NSString *)key;
- (void)setPreferFavouriteSignals:(BOOL)enabled;
- (void)setShowUnavailableParameters:(BOOL)enabled;
- (nullable NSData *)csvDataSnapshot;
@end
NS_ASSUME_NONNULL_END
