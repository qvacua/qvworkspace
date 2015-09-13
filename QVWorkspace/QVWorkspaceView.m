/**
* Tae Won Ha — @hataewon
*
* http://taewon.de
* http://qvacua.com
*
* See LICENSE
*/

#import "QVWorkspace.h"
#import "QVToolbarButtonDelegate.h"
#import "QVToolbar.h"
#import <PureLayout/PureLayout.h>
#import "NSView+QVWorkspace.h"
#import "QVWorkspaceDelegate.h"


static const CGFloat qMinCenterViewDimension = 100;


@implementation QVWorkspace {
  NSDictionary *_bars;
  NSMutableArray *_toolbarConstraints;
}

#pragma mark Public
- (void)addToolView:(NSView *)toolView displayName:(NSString *)displayName location:(QVToolbarLocation)location {
  [_bars[@(location)] addToolView:toolView displayName:displayName];

  [self updateToolbars];
}

- (void)removeToolView:(NSView *)toolView {
  [_bars.allValues makeObjectsPerformSelector:@selector(removeToolView:) withObject:toolView];

  [self updateToolbars];
}

- (void)toolbarWillResize:(QVToolbar *)toolbar {
  if ([_delegate respondsToSelector:@selector(toolbarWillResize:)]) {
    [_delegate toolbarWillResize:toolbar];
  }
}

- (void)toolbarDidResize:(QVToolbar *)toolbar {
  if ([_delegate respondsToSelector:@selector(toolbarDidResize:)]) {
    [_delegate toolbarDidResize:toolbar];
  }
}

- (CGFloat)toolbar:(QVToolbar *)toolbar willResizeToDimension:(CGFloat)dimension {
  if ([_delegate respondsToSelector:@selector(toolbar:willResizeToDimension:)]) {
    return [_delegate toolbar:toolbar willResizeToDimension:dimension];
  }

  return dimension;
}

#pragma mark NSView
- (instancetype)initWithFrame:(NSRect)frameRect {
  self = [super initWithFrame:frameRect];
  if (self == nil) {return nil;}

  _centerView = [[NSView alloc] initForAutoLayout];
  _centerView.wantsLayer = YES;
  _centerView.layer.backgroundColor = [NSColor yellowColor].CGColor;

  _topBar = [[QVToolbar alloc] initWithLocation:QVToolbarLocationTop];
  _rightBar = [[QVToolbar alloc] initWithLocation:QVToolbarLocationRight];
  _bottomBar = [[QVToolbar alloc] initWithLocation:QVToolbarLocationBottom];
  _leftBar = [[QVToolbar alloc] initWithLocation:QVToolbarLocationLeft];

  _bars = @{
      @(QVToolbarLocationTop) : _topBar,
      @(QVToolbarLocationRight) : _rightBar,
      @(QVToolbarLocationBottom) : _bottomBar,
      @(QVToolbarLocationLeft) : _leftBar,
  };

  for (QVToolbar *toolbar in _bars.allValues) {
    toolbar.workspace = self;
  }

  _toolbarConstraints = [[NSMutableArray alloc] initWithCapacity:50];

  return self;
}

- (void)updateConstraints {
  [self removeConstraints:_toolbarConstraints];
  [super updateConstraints];

  [_toolbarConstraints removeAllObjects];

  [_toolbarConstraints addObjectsFromArray:self.topBarConstraints];
  [_toolbarConstraints addObjectsFromArray:self.bottomBarConstraints];
  [_toolbarConstraints addObjectsFromArray:self.leftBarConstraints];
  [_toolbarConstraints addObjectsFromArray:self.rightBarConstraints];

  [_toolbarConstraints addObjectsFromArray:self.centerViewConstraints];
}

- (void)drawRect:(NSRect)dirtyRect {
  [[NSColor darkGrayColor] set];
  NSRectFill(self.bounds);
}

#pragma mark Private
- (void)updateToolbars {
  [self removeAllSubviews];

  [self addSubview:_centerView];

  for (QVToolbar *toolbar in _bars.allValues) {
    if (toolbar.tools.count > 0) {
      [self addSubview:toolbar];
    }
  }
}

- (NSArray *)centerViewConstraints {
  return @[
      [_centerView autoSetDimension:ALDimensionWidth toSize:qMinCenterViewDimension relation:NSLayoutRelationGreaterThanOrEqual],
      [_centerView autoSetDimension:ALDimensionHeight toSize:qMinCenterViewDimension relation:NSLayoutRelationGreaterThanOrEqual],
      _topBar.hasTools ? [_centerView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_topBar] : [_centerView autoPinEdgeToSuperviewEdge:ALEdgeTop],
      _bottomBar.hasTools ? [_centerView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_bottomBar] : [_centerView autoPinEdgeToSuperviewEdge:ALEdgeBottom],
      _leftBar.hasTools ? [_centerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_leftBar] : [_centerView autoPinEdgeToSuperviewEdge:ALEdgeLeft],
      _rightBar.hasTools ? [_centerView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_rightBar] : [_centerView autoPinEdgeToSuperviewEdge:ALEdgeRight],
  ];
}

- (NSArray *)topBarConstraints {
  if (_topBar.hasTools) {
    return @[
        [_topBar autoPinEdgeToSuperviewEdge:ALEdgeTop],
        [_topBar autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        [_topBar autoPinEdgeToSuperviewEdge:ALEdgeRight],
    ];
  }

  return @[];
}

- (NSArray *)bottomBarConstraints {
  if (_bottomBar.hasTools) {
    return @[
        [_bottomBar autoPinEdgeToSuperviewEdge:ALEdgeBottom],
        [_bottomBar autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        [_bottomBar autoPinEdgeToSuperviewEdge:ALEdgeRight],
    ];
  }

  return @[];
}

- (NSArray *)leftBarConstraints {
  if (_leftBar.hasTools) {
    return @[
        [_leftBar autoPinEdgeToSuperviewEdge:ALEdgeLeft],
        _topBar.hasTools > 0 ? [_leftBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_topBar] : [_leftBar autoPinEdgeToSuperviewEdge:ALEdgeTop],
        _bottomBar.hasTools > 0 ? [_leftBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_bottomBar] : [_leftBar autoPinEdgeToSuperviewEdge:ALEdgeBottom],
    ];
  }

  return @[];
}

- (NSArray *)rightBarConstraints {
  if (_rightBar.hasTools) {
    return @[
        [_rightBar autoPinEdgeToSuperviewEdge:ALEdgeRight],
        _topBar.hasTools > 0 ? [_rightBar autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_topBar] : [_rightBar autoPinEdgeToSuperviewEdge:ALEdgeTop],
        _bottomBar.hasTools > 0 ? [_rightBar autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_bottomBar] : [_rightBar autoPinEdgeToSuperviewEdge:ALEdgeBottom],
    ];
  }

  return @[];
}

@end
