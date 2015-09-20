/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>
#import "QVWorkspaceView.h"
#import "QVToolbarButton.h"


@interface QVToolbar : NSView <QVToolbarButtonDelegate>

@property (nonatomic, weak) QVWorkspace *workspace;
@property (nonatomic, readonly) QVToolbarLocation location;
@property (nonatomic) NSUInteger dragIncrement;
@property (nonatomic, readonly) CGFloat dimension;
@property (nonatomic, readonly) NSOrderedSet<QVTool *> *tools;

#pragma mark Public
- (instancetype)initWithLocation:(QVToolbarLocation)location;
- (void)addToolView:(NSView *)toolView displayName:(NSString *)displayName;
- (void)removeToolView:(NSView *)toolView;
- (BOOL)hasTools;
- (void)showTool:(QVTool *)tool;

#pragma mark NSResonder
- (void)mouseDown:(NSEvent *)theEvent;

#pragma mark NSView
- (void)drawRect:(NSRect)dirtyRect;
- (void)resetCursorRects;

@end
