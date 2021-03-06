/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>


@class QVToolbar;
@protocol QVWorkspaceDelegate;


typedef enum {
  QVToolbarLocationTop = 0,
  QVToolbarLocationRight,
  QVToolbarLocationBottom,
  QVToolbarLocationLeft,
} QVToolbarLocation;


@interface QVWorkspace : NSView

@property (readonly) QVToolbar *topBar;
@property (readonly) QVToolbar *rightBar;
@property (readonly) QVToolbar *bottomBar;
@property (readonly) QVToolbar *leftBar;
@property id<QVWorkspaceDelegate> delegate;

@property (nonatomic) NSView *centerView;

#pragma mark Public
- (void)addToolView:(NSView *)toolView displayName:(NSString *)displayName location:(QVToolbarLocation)location;
- (void)removeToolView:(NSView *)toolView;
- (void)toolbarWillResize:(QVToolbar *)toolbar;
- (void)toolbarDidResize:(QVToolbar *)toolbar;
- (CGFloat)toolbar:(QVToolbar *)toolbar willResizeToDimension:(CGFloat)dimension;

#pragma mark NSView
- (instancetype)initWithFrame:(NSRect)frameRect;
- (void)updateConstraints;
- (void)drawRect:(NSRect)dirtyRect;

@end
