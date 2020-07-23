//
//  ViewController.h
//  iZipper
//
//  Created by CrazyMind90 on 20/07/2020.
//  Copyright © 2020 iZipper. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SSZipArchive.h"

@interface ViewController : NSViewController


@property (strong) IBOutlet NSTextField *ZipFolder;

@property (strong) IBOutlet NSTextField *CreateZipAt;

@property (strong) IBOutlet NSTextField *ZipFileName;

@property (strong) IBOutlet NSButton *PassCheck;

@property (strong) IBOutlet NSTextField *PassText;

@property (strong) IBOutlet NSSegmentedControl *ZipSega;


@end

