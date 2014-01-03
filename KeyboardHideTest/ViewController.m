//
//  ViewController.m
//  KeyboardHideTest
//
//  Created by SDT-1 on 2014. 1. 3..
//  Copyright (c) 2014년 SDT-1. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
{
    int _dy;
}

@end

@implementation ViewController


- (UITextField *)firstResponderTextField{
    
    for(id child in self.view.subviews){
        
        if([child isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField *)child;
            
            if(textField.isFirstResponder){
                return textField;
            }
        }
    }
    return nil;
    
}

-(IBAction)dissmissKeyboard:(id)sender{
    [[self firstResponderTextField] resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"keyboardWillShow noti: %@",noti);
    
    UITextField *firstResponder = (UITextField *)[self firstResponderTextField];
    int y = firstResponder.frame.origin.y + firstResponder.frame.size.height + 5;
    int viewHegiht =self.view.frame.size.height;
    
    NSDictionary *userInfo = [noti userInfo];
    CGRect rect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];//뭐하는 코드인지?
    int keyboardHeight = (int)rect.size.height;//키보드 높이 구함
    
    float animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]floatValue];//??
    
    if(keyboardHeight > (viewHegiht -y)){
        NSLog(@"keyboard hide");
        [UIView animateWithDuration:animationDuration animations:^{
            _dy = keyboardHeight - (viewHegiht - y);
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y -_dy);}];
    }
    else{
        NSLog(@"키보드가 가리지 않음");
        _dy = 0;
    }
    
}

- (void)keyboardWillHide:(NSNotification *)noti {
    NSLog(@"keyboardWillHide");
    
    if(_dy > 0){
        float animationDuration = [[[noti userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        [UIView animateWithDuration:animationDuration animations:^{
            self.view.center =CGPointMake(self.view.center.x, self.view.center.y -_dy);
        }];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
