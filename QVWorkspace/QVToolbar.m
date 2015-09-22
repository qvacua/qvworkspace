/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "QVToolbarButtonDelegate.h"
#import "QVToolbar.h"
#import "QVTool.h"
#import <PureLayout/PureLayout.h>


#define SQ(x) ((x)*(x))


static const CGFloat qToolMinimumDimension = 50;


@interface QVWorkspace ()

- (void)activeToolView:(NSView *)toolView didResize:(CGFloat)dimension;

@end


@implementation QVToolbar {
  NSMutableOrderedSet<QVTool *> *_tools;

  QVSeparatorLine *_buttonToToolViewSeparator;
  QVSeparatorLine *_separator;

  QVToolbarButtonOrientation _buttonOrientation;
  NSMutableArray *_toolBarConstraints;
  NSLayoutConstraint *_toolbarWidthConstraint;

  QVTool *_activeTool;

  BOOL _mouseDownOnGoing;
}

#pragma mark Public
- (instancetype)initWithLocation:(QVToolbarLocation)location {
  self = [super initForAutoLayout];
  if (self == nil) {return nil;}

  _location = location;
  if (_location == QVToolbarLocationTop || _location == QVToolbarLocationBottom) {
    _buttonOrientation = QVToolbarButtonOrientationHorizontal;
    _buttonToToolViewSeparator = horizontal_separator_line();
    _separator = horizontal_separator_line();
  } else {
    _buttonOrientation = _location == QVToolbarLocationLeft ? QVToolbarButtonOrientationVerticalLeft : QVToolbarButtonOrientationVerticalRight;
    _buttonToToolViewSeparator = vertical_separator_line();
    _separator = vertical_separator_line();
  }

  _tools = [[NSMutableOrderedSet alloc] initWithCapacity:5];
  _toolBarConstraints = [[NSMutableArray alloc] initWithCapacity:50];
  _mouseDownOnGoing = NO;
  _dragIncrement = 1;

  return self;
}

- (void)addToolView:(NSView *)toolView displayName:(NSString *)displayName {
  [_tools addObject:[[QVTool alloc] initWithToolView:toolView displayName:displayName]];

  [self updateToolbar];
}

- (void)removeToolView:(NSView *)toolView {
  [_tools removeObject:[[QVTool alloc] initWithToolView:toolView displayName:nil]];

  [self updateToolbar];
}

- (void)showTool:(QVTool *)tool {
  [self makeToolbarButtonActive:tool.button];

  if (tool.active) {
    _activeTool = tool;
    [self addSubview:_buttonToToolViewSeparator];
  } else {
    _activeTool = nil;
    [_buttonToToolViewSeparator removeFromSuperview];
  }

  self.needsUpdateConstraints = YES;
  self.superview.needsUpdateConstraints = YES;
}

- (void)setDimension:(CGFloat)dimension tool:(QVTool *)tool {
  tool.dimension = MAX(qToolMinimumDimension, dimension);

  if (tool == _activeTool) {
    _toolbarWidthConstraint.constant = self.dimension;
    [_workspace activeToolView:_activeTool.toolView didResize:_activeTool.dimension];
  }
}

#pragma mark NSView
- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor windowBackgroundColor] set];
  NSRectFill(self.bounds);
}

- (nullable NSView *)hitTest:(NSPoint)point {
  if (NSMouseInRect([self convertPoint:point fromView:self.superview], self.resizeCursorRect, self.isFlipped)) {
    return self;
  }

  return [super hitTest:point];
}


#pragma mark QVToolbarButtonDelegate
- (void)toolbarButton:(QVToolbarButton *)toolbarButton clickedWithEvent:(NSEvent *)event {
  [self showTool:toolbarButton.tool];
}

- (void)makeToolbarButtonActive:(QVToolbarButton *)toolbarButton {
  toolbarButton.active = !toolbarButton.active;
  toolbarButton.tool.active = toolbarButton.active;

  void (^block)(QVTool *, NSUInteger, BOOL *) = ^(QVTool *tool, NSUInteger idx, BOOL *stop) {
    if (toolbarButton != tool.button) {
      tool.active = NO;
      tool.button.active = NO;
    }
  };

  [_tools enumerateObjectsUsingBlock:block];
}

#pragma mark Properties
- (CGFloat)dimension {
  return self.buttonDimension
      + (self.hasActiveTool ? qSeparatorDimension + _activeTool.dimension : 0)
      + qSeparatorDimension;
}

#pragma mark NSResponder
- (BOOL)hasTools {
  return _tools.count > 0;
}

- (void)mouseDown:(NSEvent *)theEvent {
  if (_mouseDownOnGoing) {
    return;
  }

  if (!self.hasActiveTool) {
    [super mouseDown:theEvent];
    return;
  }

  CGPoint initialMouseDownLoc = [self convertPoint:theEvent.locationInWindow fromView:nil];
  BOOL mouseInResizeRect = NSMouseInRect(initialMouseDownLoc, self.resizeCursorRect, self.isFlipped);

  if (!mouseInResizeRect || theEvent.type != NSLeftMouseDown) {
    [super mouseDown:theEvent];
    return;
  }

  _mouseDownOnGoing = YES;
  _toolbarWidthConstraint.priority = NSLayoutPriorityDragThatCannotResizeWindow - 1;

  BOOL dragged = NO;
  NSEvent *curEvent = theEvent;
  while (curEvent.type != NSLeftMouseUp) {
    curEvent = [NSApp nextEventMatchingMask:NSLeftMouseDraggedMask | NSLeftMouseDown | NSLeftMouseUpMask
                                  untilDate:[NSDate distantFuture]
                                     inMode:NSEventTrackingRunLoopMode
                                    dequeue:YES];

    if (curEvent.type != NSLeftMouseDragged) {break;}

    CGPoint curMouseLoc = [self convertPoint:curEvent.locationInWindow fromView:nil];
    CGFloat distance = SQ(initialMouseDownLoc.x - curMouseLoc.x) + SQ(initialMouseDownLoc.y - curMouseLoc.y);

    if (!dragged && distance < 1) {continue;}

    NSPoint locInSuperview = [self.superview convertPoint:curEvent.locationInWindow fromView:nil];
    CGFloat newToolDimension = [self newToolDimension:locInSuperview];

    _activeTool.dimension = MAX(floor(newToolDimension), qToolMinimumDimension);
    _toolbarWidthConstraint.constant = self.dimension;

    [self.window invalidateCursorRectsForView:self];
    dragged = YES;
  }

  _toolbarWidthConstraint.priority = NSLayoutPriorityDragThatCannotResizeWindow;

  [_workspace activeToolView:_activeTool.toolView didResize:_activeTool.dimension];

  _mouseDownOnGoing = NO;
}

- (CGFloat)newToolDimension:(CGPoint)locInSuperview {
  CGFloat rawDimension = [self toolDimensionForLocationInSuperview:locInSuperview];
  return _dragIncrement * floor(rawDimension / _dragIncrement);
}

#pragma mark NSView
- (void)updateConstraints {
  [self removeConstraints:_toolBarConstraints];
  [self removeConstraint:_toolbarWidthConstraint];
  [_toolBarConstraints removeAllObjects];

  NSView *activeToolView = _activeTool.toolView;
  [activeToolView removeFromSuperview];

  [super updateConstraints];

  if (self.hasActiveTool) {
    [self addSubview:activeToolView];
    [self updateConstraintsForActiveToolView];
  }

  [self updateConstraintsForToolBar];

  [self.window invalidateCursorRectsForView:self];
}

- (CGRect)resizeCursorRect {
  CGRect rect = _separator.frame;
  CGFloat oneSideDimension = 3;

  if (_location == QVToolbarLocationTop) {
    return CGRectMake(NSMinX(rect), NSMinY(rect), NSWidth(rect), oneSideDimension);
  }

  if (_location == QVToolbarLocationBottom) {
    return CGRectMake(NSMinX(rect), NSMaxY(rect) - oneSideDimension, NSWidth(rect), oneSideDimension);
  }

  if (_location == QVToolbarLocationLeft) {
    return CGRectMake(NSMinX(rect) - oneSideDimension, NSMinY(rect), oneSideDimension, NSHeight(rect));
  }

  if (_location == QVToolbarLocationRight) {
    return CGRectMake(NSMaxX(rect), NSMinY(rect), oneSideDimension, NSHeight(rect));
  }

  return CGRectZero;
}

- (void)resetCursorRects {
  if (!self.hasActiveTool) {return;}

  if (_location == QVToolbarLocationTop || _location == QVToolbarLocationBottom) {
    [self addCursorRect:[self resizeCursorRect] cursor:[NSCursor resizeUpDownCursor]];
  } else {
    [self addCursorRect:[self resizeCursorRect] cursor:[NSCursor resizeLeftRightCursor]];
  }
}

- (NSString *)description {
  switch (_location) {
    case QVToolbarLocationTop:
      return @"top-toolbar";
    case QVToolbarLocationRight:
      return @"right-toolbar";
    case QVToolbarLocationBottom:
      return @"bottom-toolbar";
    case QVToolbarLocationLeft:
      return @"left-toolbar";
  }

  return @"error";
}

#pragma mark Private
- (void)updateConstraintsForToolBar {
  ALEdge superViewEdge;
  switch (_location) {
    case QVToolbarLocationTop:
      superViewEdge = ALEdgeTop;
      break;
    case QVToolbarLocationRight:
      superViewEdge = ALEdgeRight;
      break;
    case QVToolbarLocationBottom:
      superViewEdge = ALEdgeBottom;
      break;
    case QVToolbarLocationLeft:
      superViewEdge = ALEdgeLeft;
      break;
  }

  ALEdge firstEdge;
  if (_location == QVToolbarLocationTop || _location == QVToolbarLocationBottom) {
    firstEdge = ALEdgeLeft;
  } else {
    firstEdge = ALEdgeTop;
  }

  ALEdge selfEdge;
  ALEdge targetEdge;
  if (_location == QVToolbarLocationTop || _location == QVToolbarLocationBottom) {
    selfEdge = ALEdgeLeft;
    targetEdge = ALEdgeRight;
  } else {
    selfEdge = ALEdgeTop;
    targetEdge = ALEdgeBottom;
  }

  __block QVToolbarButton *prevButton;
  [_tools enumerateObjectsUsingBlock:^(QVTool *tool, NSUInteger idx, BOOL *stop) {
    QVToolbarButton *button = tool.button;
    [_toolBarConstraints addObjectsFromArray:[button autoSetDimensionsToSize:button.size]];

    [_toolBarConstraints addObject:[button autoPinEdgeToSuperviewEdge:superViewEdge]];
    if (idx == 0) {
      [_toolBarConstraints addObject:[button autoPinEdgeToSuperviewEdge:firstEdge]];
    } else {
      [_toolBarConstraints addObject:[button autoPinEdge:selfEdge toEdge:targetEdge ofView:prevButton]];
    }

    prevButton = button;
  }];

  if (_location == QVToolbarLocationTop) {
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
  }

  if (_location == QVToolbarLocationBottom) {
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeTop]];
  }

  if (_location == QVToolbarLocationLeft) {
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeTop]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeRight]];
  }

  if (_location == QVToolbarLocationRight) {
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeTop]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
    [_toolBarConstraints addObject:[_separator autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
  }

  switch (_location) {
    case QVToolbarLocationTop:
    case QVToolbarLocationBottom:
      [_toolBarConstraints addObject:[self autoSetDimension:ALDimensionHeight
                                                     toSize:self.buttonDimension + qSeparatorDimension
                                                   relation:NSLayoutRelationGreaterThanOrEqual]];
      _toolbarWidthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:self.dimension];
      break;
    case QVToolbarLocationRight:
    case QVToolbarLocationLeft:
      [_toolBarConstraints addObject:[self autoSetDimension:ALDimensionWidth
                                                     toSize:self.buttonDimension + qSeparatorDimension
                                                   relation:NSLayoutRelationGreaterThanOrEqual]];
      _toolbarWidthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:nil
                                                             attribute:NSLayoutAttributeNotAnAttribute
                                                            multiplier:1
                                                              constant:self.dimension];
      break;
  }

  _toolbarWidthConstraint.priority = NSLayoutPriorityDragThatCannotResizeWindow;
  [self addConstraint:_toolbarWidthConstraint];
}

- (BOOL)hasActiveTool {
  return _activeTool != nil;
}

- (void)updateConstraintsForActiveToolView {
  NSView *activeToolView = _activeTool.toolView;
  NSView *firstButton = [_tools[0] button];

  if (_location == QVToolbarLocationLeft) {
    [_toolBarConstraints addObjectsFromArray:@[
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeTop],
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeBottom],
        [_buttonToToolViewSeparator autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:firstButton],

        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeTop],
        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeBottom],
        [activeToolView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_buttonToToolViewSeparator],
        [activeToolView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_separator],
    ]];
    return;
  }

  if (_location == QVToolbarLocationRight) {
    [_toolBarConstraints addObjectsFromArray:@[
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeTop],
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeBottom],
        [_buttonToToolViewSeparator autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:firstButton],

        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeTop],
        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeBottom],
        [activeToolView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_separator],
        [activeToolView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_buttonToToolViewSeparator],
    ]];
    return;
  };

  if (_location == QVToolbarLocationTop) {
    [_toolBarConstraints addObjectsFromArray:@[
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeRight],
        [_buttonToToolViewSeparator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:firstButton],

        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeRight],
        [activeToolView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_buttonToToolViewSeparator],
        [activeToolView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_separator],
    ]];
    return;
  }

  if (_location == QVToolbarLocationBottom) {
    [_toolBarConstraints addObjectsFromArray:@[
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        [_buttonToToolViewSeparator autoPinEdgeToSuperviewEdge:ALEdgeRight],
        [_buttonToToolViewSeparator autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:firstButton],

        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        [activeToolView autoPinEdgeToSuperviewEdge:ALEdgeRight],
        [activeToolView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_separator],
        [activeToolView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_buttonToToolViewSeparator],
    ]];
    return;
  }
}

- (void)updateToolbar {
  [self _qvworkspace_removeAllSubviews];

  [self addSubview:_separator];

  for (QVTool *tool in _tools) {
    QVToolbarButton *button = tool.button;
    button.delegate = self;
    button.orientation = _buttonOrientation;
    [self addSubview:button];
  }

  self.needsUpdateConstraints = YES;
}

- (CGFloat)toolDimensionForLocationInSuperview:(CGPoint)locInSuperview {
  CGFloat newToolDimension = 0 - qSeparatorDimension - self.buttonDimension - qSeparatorDimension;

  switch (_location) {
    case QVToolbarLocationTop:
      newToolDimension += self.superview.bounds.size.height - locInSuperview.y;
      break;
    case QVToolbarLocationRight:
      newToolDimension += self.superview.bounds.size.width - locInSuperview.x;
      break;
    case QVToolbarLocationBottom:
      newToolDimension += locInSuperview.y;
      break;
    case QVToolbarLocationLeft:
      newToolDimension += locInSuperview.x;
      break;
  }

  return newToolDimension;
}

- (CGFloat)buttonDimension {
  QVToolbarButton *button = _tools[0].button;
  return (_location == QVToolbarLocationTop || _location == QVToolbarLocationBottom) ? button.size.height : button.size.width;
}

@end
