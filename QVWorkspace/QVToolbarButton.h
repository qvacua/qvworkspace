/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import <Cocoa/Cocoa.h>
#import "QVToolbarButtonDelegate.h"


@class QVTool;


typedef NS_ENUM(NSInteger, QVToolbarButtonOrientation) {
    QVToolbarButtonOrientationHorizontal = 0,
    QVToolbarButtonOrientationVerticalLeft,
    QVToolbarButtonOrientationVerticalRight,
};


@interface QVToolbarButton : NSView

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, weak) QVTool *tool;
@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic, weak) id <QVToolbarButtonDelegate> delegate;
@property (nonatomic, readonly) CGSize size;

@property QVToolbarButtonOrientation orientation;

- (instancetype)initWithTitle:(NSString *)title;

#pragma mark NSResponder
- (void)mouseUp:(NSEvent *)theEvent;

#pragma mark NSView
- (void)drawRect:(NSRect)dirtyRect;

@end

