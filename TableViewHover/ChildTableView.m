//
//  ChildTableView.m
//  TableViewHover
//
//  Created by Stan on 2021/5/2.
//

#import "ChildTableView.h"

@implementation ChildTableView
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
