//
//  ViewController.m
//  YunPhoto
//
//  Created by qingyun on 3/4/14.
//  Copyright (c) 2014 qingyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize sheet;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *selectBtn = [[UIButton alloc]init];
    selectBtn.frame = CGRectMake(30, 450, 80, 40);
    [selectBtn addTarget:self action:@selector(UserImageClicked) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:selectBtn];
    
    UILabel *selectLabel = [[UILabel alloc]init];
    selectLabel.frame = CGRectMake(0, 0, 80, 40);
    selectLabel.text = @"chose";
    selectLabel.textColor = [UIColor redColor];
    [selectBtn addSubview:selectLabel];
    
    imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(0, 20, 320, 320);
    [self.view addSubview:imageView];
    //imageView.layer.masksToBounds = YES;
    //imageView.layer.cornerRadius = 160;
    
    
    UIButton *saveBtn = [[UIButton alloc]init];
    saveBtn.frame = CGRectMake(250, 450, 80, 40);
    [saveBtn addTarget:self action:@selector(saveImgBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    UILabel *saveLabel = [[UILabel alloc]init];
    saveLabel.frame = CGRectMake(0, 0, 80, 40);
    saveLabel.text = @"save";
    saveLabel.textColor = [UIColor redColor];
    [saveBtn addSubview:saveLabel];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)UserImageClicked
{
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        self.sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    self.sheet.tag = 255;
    //[self.sheet showInView:self.view];
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [self.sheet showInView:self.view];
    } else {
        [self.sheet showInView:window];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{}];
    }
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

   
    imageView.image =  [self circleImage:img withParam:1];
    //保存图片
   
    savedImage = imageView.image;

//    
//    NSData *imageData = UIImageJPEGRepresentation(image, COMPRESSED_RATE);
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
//    
//    [HttpRequestManager uploadImage:compressedImage httpClient:self.httpClient delegate:self];
    
}


//圆形的图片
-(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context,0); //边框线
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


-(void)saveImgBtnPress
{
     [self saveImageToPhotos:savedImage];
}


- (void)saveImageToPhotos:(UIImage*)savedImage
{
    if(imageView.image)
    {
         UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}
// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}



// 调用示例



@end
