//
//  ViewController.m
//  iZipper
//
//  Created by CrazyMind90 on 20/07/2020.
//  Copyright © 2020 iZipper. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _PassText.hidden = YES;
    _PassCheck.state = 0;
    _ZipSega.selectedSegment = 0;
    
    _ZipFileName.hidden = NO;
    _PassCheck.title = @"Set password";
    _ZipFolder.stringValue = @"";
    _ZipFolder.placeholderString = @"Folder or File to zip";
    _CreateZipAt.placeholderString = @"Create at path";
    
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
 


-(BOOL) CreateDir:(NSString *)AtPath {
    
    BOOL Done = NO;
    
   if ([[NSFileManager defaultManager] createDirectoryAtPath:AtPath withIntermediateDirectories:YES attributes:nil error:nil])
       Done = YES;
    
    return Done;
    
}

-(void) CopyFile:(NSString *)Copy ToPath:(NSString *)ToPath {
    
    [[NSFileManager defaultManager] copyItemAtPath:Copy toPath:ToPath error:nil];
}


-(void) RemoveFile:(NSString *)File {
    
    [[NSFileManager defaultManager] removeItemAtPath:File error:nil];
}


-(BOOL) isFolder:(NSString *)FolderPath {
    
    BOOL Folder;
    NSString *PathCheck = FolderPath;
      
      if ([[PathCheck pathExtension] isEqual:@""])
          Folder = YES;
      else
          Folder = NO;
    
    
    return Folder;
}



- (IBAction)PassCheckButton:(id)sender {
    
    if (_PassCheck.state == 0)
        _PassText.hidden = YES;
         else
        _PassText.hidden = NO;
}




- (IBAction)iZipperButton:(id)sender {
    
    switch (_ZipSega.selectedSegment) {
          case 0:
              [self performSelector:@selector(Zip)];
              break;
            
          case 1:
              [self performSelector:@selector(UnZip)];
              break;
              
          default:
              break;
      }
   
}


- (IBAction)ZipSega:(id)sender {
    
    switch (_ZipSega.selectedSegment) {
            case 0:
            _ZipFileName.hidden = NO;
            _PassCheck.title = @"Set password";
            _ZipFolder.stringValue = @"";
            _ZipFolder.placeholderString = @"Folder or File to zip";
            _CreateZipAt.placeholderString = @"Create at path";
                break;
              
            case 1:
            _ZipFileName.hidden = YES;
            _PassCheck.title = @"Unlock password";
            _ZipFolder.stringValue = @"";
            _ZipFolder.placeholderString = @"File to Unzip";
            _CreateZipAt.placeholderString = @"Unzip to path";
                break;
                
            default:
                break;
        }
}



-(void) UnZip {
    
 
    
        NSString *ZipFolder = _ZipFolder.stringValue;
        NSString *CreateZipAt = _CreateZipAt.stringValue;
        NSString *PassText = _PassText.stringValue;
        NSUInteger PassCheck = _PassCheck.state;
    
    
       __block BOOL Done = NO;
        
        
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
                HUD.mode = MBProgressHUDAnimationFade;
        
                        [self.view addSubview:HUD];
        
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                  
                           HUD.detailsLabelText = @"Preparing";
                  
                  
                  NSString *Password = nil;
                  
                  if (PassCheck == 1) {
                      
                      Password = PassText;
                  }
                        
                  
 
                  
                  [SSZipArchive unzipFileAtPath:ZipFolder toDestination:CreateZipAt preserveAttributes:NO overwrite:YES nestedZipLevel:0 password:Password error:nil delegate:nil progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
                      
 
                      
                  HUD.taskInProgress = YES;
         
                  HUD.detailsLabelText = [NSString stringWithFormat:@"%lu/%lu",total,entryNumber];
                   
                      
                  } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
                      
                      
                        if (!succeeded)
                        Done = NO;
                        else
                        Done = YES;
                      
                      
                  }];
                  
                                

                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (!Done)
                    [self performSelector:@selector(ErrorMessage) withObject:nil afterDelay:0.10];

                        
                         [HUD hide:YES];

                        });
                  
      

                 });
    
    
}


-(void) ErrorMessage {

    NSWindow *window  = [NSApplication sharedApplication].keyWindow;
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"Something went wrong";
    alert.informativeText = @"!";
    [alert addButtonWithTitle:@"OK"];

    [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {

    }];
    
}


-(void) Zip {
    

    
        NSString *ZipFolder = _ZipFolder.stringValue;
        NSString *CreateZipAt = _CreateZipAt.stringValue;
        NSString *ZipFileName = _ZipFileName.stringValue;
        NSString *PassText = _PassText.stringValue;
        NSUInteger PassCheck = _PassCheck.state;
    
    
    
    BOOL FileExistsA = [[NSFileManager defaultManager] fileExistsAtPath:ZipFolder];
    BOOL FileExistsB = [[NSFileManager defaultManager] fileExistsAtPath:CreateZipAt];
    
    NSUInteger isFirstLabel = 0;
    
      if (FileExistsA)
          isFirstLabel = 1;
    
      if (FileExistsB)
          isFirstLabel = 2;
    
      if (FileExistsA && FileExistsB)
          isFirstLabel = 3;
    
    if (FileExistsA && FileExistsB && ![ZipFileName isEqual:@""]) {
        
      
        
                MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
                HUD.mode = MBProgressHUDAnimationFade;
        
                        [self.view addSubview:HUD];
        
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                  
                           HUD.detailsLabelText = @"Preparing";
                  
                  
          NSString *Password = nil;
          
          if (PassCheck == 1) {
              
              Password = PassText;
          }
                  
                  
         // Check If File OR Folder
          if (![self isFolder:ZipFolder]) {
              
          NSString *RealPath = [NSString stringWithFormat:@"%@/.%@",CreateZipAt,ZipFileName];
              
              
          if ([self CreateDir:RealPath])
          [self CopyFile:ZipFolder ToPath:[NSString stringWithFormat:@"%@/%@.%@",RealPath,[[ZipFolder lastPathComponent] stringByDeletingPathExtension],[[ZipFolder lastPathComponent] pathExtension]]];
              
              
              
              [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/%@.zip",CreateZipAt,ZipFileName] withContentsOfDirectory:RealPath keepParentDirectory:NO withPassword:Password andProgressHandler:^(NSUInteger entryNumber, NSUInteger total) {
                            
                             HUD.taskInProgress = YES;
                     
                             HUD.detailsLabelText = [NSString stringWithFormat:@"%lu/%lu",total,entryNumber];
                             
                             
                         }];

              
                  [self RemoveFile:RealPath];
              
              
              
              
              
          } else {
 
              
              
              [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@/%@.zip",CreateZipAt,ZipFileName] withContentsOfDirectory:ZipFolder keepParentDirectory:NO withPassword:Password andProgressHandler:^(NSUInteger entryNumber, NSUInteger total) {
                 
                  HUD.taskInProgress = YES;
          
                  HUD.detailsLabelText = [NSString stringWithFormat:@"%lu/%lu",total,entryNumber];
                  
                  
              }];
           
          }
                  


                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                         [HUD hide:YES];
                        
                        

                        });
                  
      

                 });
        
        
    }
        
        
    if (isFirstLabel == 2) {
        
        NSWindow *window  = [NSApplication sharedApplication].keyWindow;
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Couldn't find path at first label";
        alert.informativeText = @"!";
        [alert addButtonWithTitle:@"OK"];

        [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {

        }];
        
    }
    
    
    if (isFirstLabel == 1) {
        
        NSWindow *window  = [NSApplication sharedApplication].keyWindow;
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Couldn't find path at Second label";
        alert.informativeText = @"!";
        [alert addButtonWithTitle:@"OK"];

        [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {

        }];
        
   }
    
    
    if ([ZipFileName isEqual:@""] && isFirstLabel == 3) {
        
        
        NSWindow *window  = [NSApplication sharedApplication].keyWindow;
        NSAlert *alert = [NSAlert new];
        alert.messageText = @"Zip File Name is empty";
        alert.informativeText = @"!";
        [alert addButtonWithTitle:@"OK"];

        [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {

        }];
    }
 
     

}

 
- (IBAction)CrazyMind:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/CrazyMind90"];
    [[NSWorkspace sharedWorkspace] openURL:url];
    
}


@end
