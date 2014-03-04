//
//  ViewController.h
//  YunPhoto
//
//  Created by qingyun on 3/4/14.
//  Copyright (c) 2014 qingyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
     UIImageView *imageView  ;
    UIImage *savedImage;
}

@property (nonatomic, strong) UIActionSheet *sheet;


@end
