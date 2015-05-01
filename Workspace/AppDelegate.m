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

@implementation AppDelegate {
  QVWorkspace *_workspace;
}

- (IBAction)changeCenterView:(id)sender {
  NSView *centerView = [[NSView alloc] initForAutoLayout];
  centerView.wantsLayer = YES;
  centerView.layer.backgroundColor = [NSColor blueColor].CGColor;
  
  _workspace.centerView = centerView;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  _workspace = [[QVWorkspace alloc] initForAutoLayout];
  [[self.window contentView] addSubview:_workspace];

  [_workspace autoPinEdgeToSuperviewEdge:ALEdgeLeft];
  [_workspace autoPinEdgeToSuperviewEdge:ALEdgeRight];
  [_workspace autoPinEdgeToSuperviewEdge:ALEdgeTop];
  [_workspace autoPinEdgeToSuperviewEdge:ALEdgeBottom];

  [_workspace addToolView:[self dummyViewWithColor:[NSColor whiteColor]] displayName:@"Project" location:QVToolbarLocationLeft];
  [_workspace addToolView:[self dummyViewWithColor:[NSColor brownColor]] displayName:@"Run" location:QVToolbarLocationLeft];
  [_workspace addToolView:[self dummyViewWithColor:[NSColor cyanColor]] displayName:@"Structure" location:QVToolbarLocationRight];
//  [workspace addToolView:[self dummyViewWithColor:[NSColor magentaColor]] displayName:@"Changes" location:QVToolbarLocationTop];
  [_workspace addToolView:[self dummyViewWithColor:[NSColor greenColor]] displayName:@"TODO" location:QVToolbarLocationBottom];
}

- (NSView *)dummyViewWithColor:(NSColor *)color {
  NSView *view = [[NSView alloc] initForAutoLayout];

  view.wantsLayer = YES;
  view.layer.backgroundColor = color.CGColor;

  return view;
}

@end
