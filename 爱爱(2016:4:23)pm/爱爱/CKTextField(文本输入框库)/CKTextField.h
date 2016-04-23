//
//  CKTextField.h
//  CKTextField
//
//  Created by Christian Klaproth on 12.09.14.
//  Copyright (c) 2014 Christian Klaproth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CKExternalKeyboardSupportedTextField.h"

@class CKTextField;

enum CKTextFieldValidationResult {
    CKTextFieldValidationUnknown,
    CKTextFieldValidationPassed,
    CKTextFieldValidationFailed
};

/**
 * Adds optional methods that are sent to the UITextFieldDelegate.
 */
@protocol CKTextFieldValidationDelegate <NSObject>

@optional

- (void)textField:(CKTextField*)aTextField validationResult:(enum CKTextFieldValidationResult)aResult forText:(NSString*)aText;

@end

@interface CKTextField : CKExternalKeyboardSupportedTextField

//
// User Defined Runtime Attributes (--> Storyboard!)
//
// *******************************************************
//                                                       *
//                                                       *

@property (nonatomic) IBInspectable NSString* validationType;
@property (nonatomic) IBInspectable NSString* minLength;
@property (nonatomic) IBInspectable NSString* maxLength;
@property (nonatomic) IBInspectable NSString* minValue;
@property (nonatomic) IBInspectable NSString* maxValue;
@property (nonatomic) IBInspectable NSString* pattern;

//                                                       *
//                                                       *
// *******************************************************

@property (nonatomic, weak) id<CKTextFieldValidationDelegate> validationDelegate;

- (void)shake;
- (void)showAcceptButton;
- (void)hideAcceptButton;

@end
