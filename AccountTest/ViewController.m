//
//  ViewController.m
//  AccountTest
//
//  Created by MornChan on 16/7/11.
//  Copyright © 2016年 MornChan. All rights reserved.
//

#import "ViewController.h"
#import "AccountStatusView.h"
#define padding 50
#define layerViewWH 20
#define bezierCenter layerViewWH * 0.25
#define circleRadius 8
#define textFieldHeight 30


@interface ViewController ()<UITextFieldDelegate>

//手机号
@property(strong,nonatomic) UILabel * accountLabelBefore;
//变换后手机号
@property(strong,nonatomic) UILabel * accountLabelAfter;
//手机号分割线
@property(strong,nonatomic) UIView * firstBottomLine;
//验证码分割线
@property(strong,nonatomic) UIView * secondBottomLine;
//状态显示框
@property(strong,nonatomic) AccountStatusView * statusView;

@end

@implementation ViewController

- (void)setupSubviews
{
    //手机号分界线
    UIView * firstBottomLine = [[UIView alloc]initWithFrame:CGRectMake(padding, padding * 3, self.view.frame.size.width - padding *2, 1)];
    firstBottomLine.backgroundColor = [UIColor lightGrayColor];
    firstBottomLine.alpha = 0.5;
    self.firstBottomLine = firstBottomLine;
    [self.view addSubview:firstBottomLine];
    
    //手机号输入框
    UITextField * firstTextField = [[UITextField alloc]initWithFrame:CGRectMake(firstBottomLine.frame.origin.x, firstBottomLine.frame.origin.y - textFieldHeight, firstBottomLine.frame.size.width, textFieldHeight)];
    firstTextField.tag = 1;
    firstTextField.delegate = self;
    [firstTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:firstTextField];
    
    UILabel * accountLabelBefore = [[UILabel alloc]initWithFrame:CGRectMake(firstBottomLine.frame.origin.x, firstBottomLine.frame.origin.y - textFieldHeight, self.view.frame.size.width, 28)];
    accountLabelBefore.font = [UIFont systemFontOfSize:14];
    accountLabelBefore.text = @"手机号";
    accountLabelBefore.textColor = [UIColor lightGrayColor];
    accountLabelBefore.alpha = 0.7;
    self.accountLabelBefore = accountLabelBefore;
    [self.view addSubview:accountLabelBefore];
    
    UILabel * accountLabelAfter = [[UILabel alloc]initWithFrame:CGRectMake(firstTextField.frame.origin.x, accountLabelBefore.frame.origin.y - 5, 30, 30)];
    accountLabelAfter.font = [UIFont systemFontOfSize:12];
    accountLabelAfter.text = @"账号";
    accountLabelAfter.textColor = [UIColor lightGrayColor];
    accountLabelAfter.alpha = 0.0;
    self.accountLabelAfter = accountLabelAfter;
    [self.view addSubview:accountLabelAfter];
    
    AccountStatusView * statusView = [[AccountStatusView alloc]init];
    CGRect frames = statusView.frame;
    frames.origin = CGPointMake(padding + firstBottomLine.frame.size.width - statusView.frame.size.width, firstBottomLine.frame.origin.y - statusView.frame.size.height - 5);
    statusView.frame = frames;
    self.statusView = statusView;
    [self.view addSubview:statusView];

    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)textFieldChanged:(UITextField *)textField
{
    //手机号输入框
    if (textField.tag == 1)
    {
        if (!textField.hasText) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.accountLabelAfter.alpha = 0.0;
            } completion:^(BOOL finished) {
                if (finished) {
                    self.accountLabelAfter.transform = CGAffineTransformIdentity;
                    [UIView animateWithDuration:0.05 animations:^{
                        [self.statusView setHidden:YES];
                        self.accountLabelBefore.transform = CGAffineTransformIdentity;
                        self.accountLabelBefore.alpha = 1.0;
                        [self.accountLabelBefore setHidden:NO];
                    }];
                }
            }];
            return;
        }

        if (textField.text.length <2) {
            [UIView animateWithDuration:0.1 animations:^{
                if(self.accountLabelBefore.transform.ty == 0)
                {
                    self.accountLabelBefore.transform = CGAffineTransformTranslate(self.accountLabelBefore.transform, 0, -15);
                    [self.accountLabelBefore setHidden:YES];
                }
            } completion:^(BOOL finished) {
                if (finished) {
                    if (self.accountLabelAfter.transform.ty == 0) {
                        [self.statusView setHidden:NO];
                        [self.statusView showLoading];
                        [UIView animateWithDuration:0.1 animations:^{
                            self.accountLabelAfter.textColor = [UIColor blackColor];
                            self.accountLabelAfter.alpha = 0.7;
                            self.accountLabelAfter.transform = CGAffineTransformTranslate(self.accountLabelAfter.transform, 0, -15);
                        }completion:^(BOOL finished) {

                        }];
                    }
                }
            }];
        }
    }
    
    if (textField.text.length == 11) {
        
        [self.statusView showSuccess];
    }

    if (textField.text.length >11) {
        [self.statusView showError];
        self.firstBottomLine.backgroundColor = [UIColor redColor];
    }
    else self.firstBottomLine.backgroundColor = [UIColor lightGrayColor];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

@end
