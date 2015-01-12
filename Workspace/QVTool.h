/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>
#import "QVWorkspace.h"


@class QVToolbar;
@class QVToolbarButton;


@interface QVTool : NSObject

@property (nonatomic, readonly) QVToolbarButton *button;
@property (nonatomic) BOOL active;
@property (nonatomic, readonly) NSView *toolView;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic) CGFloat dimension;

- (instancetype)initWithToolView:(NSView *)toolView displayName:(NSString *)displayName;

- (BOOL)isEqual:(id)other;
- (BOOL)isEqualToTool:(QVTool *)tool;
- (NSUInteger)hash;

@end
