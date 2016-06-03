//
// Created by Baidu on 13-10-1.
// Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import "BDVRPickerTableViewCell.h"

// 类实现
@implementation BDVRPickerTableViewCell

- (void)initializeInputView
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIViewController *popoverContent = [[UIViewController alloc] init];
        popoverContent.view = _pickerView;
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
        _popoverController.delegate = self;
        [popoverContent release];
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initializeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initializeInputView];
    }
    return self;
}

- (UIView *)inputView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return nil;
    }
    else
    {
        return _pickerView;
    }
}

- (UIView *)inputAccessoryView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return nil;
    }
    else
    {
        if (!_inputAccessoryView)
        {
            _inputAccessoryView = [[UIToolbar alloc] init];
            _inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
            _inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [_inputAccessoryView sizeToFit];
            CGRect frame = _inputAccessoryView.frame;
            frame.size.height = 44.0f;
            _inputAccessoryView.frame = frame;

            UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
            UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

            NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
            [_inputAccessoryView setItems:array];
            [doneBtn release];
            [flexibleSpaceLeft release];
        }
        
        return _inputAccessoryView;
    }
}

- (void)done:(id)sender
{
    [self resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        CGSize pickerSize = [_pickerView sizeThatFits:CGSizeZero];
        CGRect frame = _pickerView.frame;
        frame.size = pickerSize;
        _pickerView.frame = frame;
        _popoverController.popoverContentSize = pickerSize;
        [_popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

        for (UIView *subview in self.superview.subviews)
        {
            if ([subview isFirstResponder])
            {
                [subview resignFirstResponder];
            }
        }
        return NO;
    }
    else
    {
        [_pickerView setNeedsLayout];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    UITableView *view = (UITableView *) self.superview;
    while (![view isKindOfClass:[UITableView class]]) {
        view = (UITableView *) [view superview];
    }
    [view deselectRowAtIndexPath:[view indexPathForCell:self] animated:YES];
    return [super resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected)
    {
        [self becomeFirstResponder];
    }
}

- (void)deviceDidRotate:(NSNotification*)notification
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [_popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else
    {
        [_pickerView setNeedsLayout];
    }
}

#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark -
#pragma mark UIKeyInput Protocol Methods

- (BOOL)hasText
{
    return YES;
}

- (void)insertText:(NSString *)theText
{
}

- (void)deleteBackward
{
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate Protocol Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    UITableView *tableView = (UITableView *)self.superview;
    [tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
    [self resignFirstResponder];
}

- (void)dealloc
{
    [_pickerView release];
    [_popoverController release];
    [_inputAccessoryView release];
    [super dealloc];
}

@end // BDVRPickerTableViewCell