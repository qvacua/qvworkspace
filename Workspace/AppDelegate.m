//
//  AppDelegate.m
//  Workspace
//
//  Created by Tae Won Ha on 27/12/14.
//  Copyright (c) 2014 Tae Won Ha. All rights reserved.
//

#import "AppDelegate.h"
#import "QVWorkspace.h"
#import "PureLayout.h"
#import "QVSeparatorLine.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  QVWorkspace *workspace = [[QVWorkspace alloc] initForAutoLayout];
  [[self.window contentView] addSubview:workspace];

  [workspace autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [workspace autoPinEdgeToSuperviewEdge:ALEdgeRight];
  [workspace autoPinEdgeToSuperviewEdge:ALEdgeTop];
  [workspace autoPinEdgeToSuperviewEdge:ALEdgeBottom];

  [workspace addToolView:[self dummyViewWithColor:[NSColor whiteColor]] displayName:@"Project" location:QVToolbarLocationLeft];
  [workspace addToolView:[self dummyViewWithColor:[NSColor brownColor]] displayName:@"Run" location:QVToolbarLocationLeft];
  [workspace addToolView:[self dummyViewWithColor:[NSColor cyanColor]] displayName:@"Structure" location:QVToolbarLocationRight];
//  [workspace addToolView:[self dummyViewWithColor:[NSColor magentaColor]] displayName:@"Changes" location:QVToolbarLocationTop];
  [workspace addToolView:[self dummyViewWithColor:[NSColor greenColor]] displayName:@"TODO" location:QVToolbarLocationBottom];
}

- (NSView *)dummyViewWithColor:(NSColor *)color {
  NSView *view = [[NSView alloc] initForAutoLayout];

  view.wantsLayer = YES;
  view.layer.backgroundColor = color.CGColor;

  return view;
}

@end
