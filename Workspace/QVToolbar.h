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
#import "QVToolbarButton.h"


@protocol QVToolbarDelegate;


@interface QVToolbar : NSView <QVToolbarButtonDelegate>

@property (nonatomic, weak) QVWorkspace *workspace;
@property (nonatomic, readonly) QVToolbarLocation location;
@property (nonatomic) NSUInteger dragIncrement;
@property (nonatomic, readonly) CGFloat dimension;
@property (nonatomic, readonly) NSOrderedSet *tools;
@property (nonatomic, weak) id <QVToolbarDelegate> delegate;

- (instancetype)initWithLocation:(QVToolbarLocation)location;
- (void)addToolView:(NSView *)toolView displayName:(NSString *)displayName;
- (void)removeToolView:(NSView *)toolView;
- (BOOL)hasTools;
- (BOOL)hasActiveTool;

#pragma mark NSResponder
- (void)mouseDown:(NSEvent *)theEvent;

#pragma mark NSView
- (void)drawRect:(NSRect)dirtyRect;
- (void)resetCursorRects;

@end
