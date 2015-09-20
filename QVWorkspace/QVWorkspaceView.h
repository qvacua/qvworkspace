/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>
#import "QVWorkspaceDelegate.h"


@class QVToolbar;


typedef NS_ENUM(NSInteger, QVToolbarLocation){
  QVToolbarLocationTop = 0,
  QVToolbarLocationRight,
  QVToolbarLocationBottom,
  QVToolbarLocationLeft,
};


@interface QVWorkspace : NSView

@property (nonnull, readonly) QVToolbar *topBar;
@property (nonnull, readonly) QVToolbar *rightBar;
@property (nonnull, readonly) QVToolbar *bottomBar;
@property (nonnull, readonly) QVToolbar *leftBar;
@property (nullable) id<QVWorkspaceDelegate> delegate;

@property (nullable, nonatomic) NSView *centerView;

#pragma mark Public
- (void)addToolView:(nonnull NSView *)toolView displayName:(nonnull NSString *)displayName location:(QVToolbarLocation)location;
- (void)removeToolView:(nonnull NSView *)toolView;

- (void)showToolView:(nonnull NSView *)toolView;
- (void)setDimension:(CGFloat)dimension toolView:(nonnull NSView *)toolView;

#pragma mark NSView
- (nonnull instancetype)initWithFrame:(NSRect)frameRect;
- (void)updateConstraints;
- (void)drawRect:(NSRect)dirtyRect;

@end
