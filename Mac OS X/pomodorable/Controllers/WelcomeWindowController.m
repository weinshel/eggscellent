//
//  WelcomeWindowController.m
//  pomodorable
//
//  Created by Kyle Kinkade on 12/3/11.
//  Copyright (c) 2011 Monocle Society LLC  All rights reserved.
//

#import "WelcomeWindowController.h"
#import "AppDelegate.h"
#import "NSAttributedString+Hyperlink.h"

@implementation WelcomeWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self)
    {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    autoLogin = NO;
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [self.window.contentView addSubview:generalOptionsView];
    [self performSelector:@selector(populateMoreInformation) withObject:nil afterDelay:0.0f];
    
    if(NSClassFromString(@"NSUserNotification"))
    {
        [[NSUserDefaults standardUserDefaults] setInteger:ActivitySourceReminders forKey:@"taskManagerType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSMenuItem *reminderItem = [taskIntegrationButton itemAtIndex:1];
        [reminderItem setHidden:NO];
        [taskIntegrationButton selectItem:reminderItem];
    }
}

#pragma mark - Custom Methods: General

- (void)processAutoLogin
{
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;    
    if(autoLogin)
    {
        [appDelegate updateLoginItem:YES];
    }
    else
    {
        [appDelegate updateLoginItem:NO];
    }
}

#pragma mark - Custom Methods: More Information

- (void)setupURL:(NSURL *)url forTextField:(NSTextField *)textField
{
    // both are needed, otherwise hyperlink won't accept mousedown
    [textField setAllowsEditingTextAttributes: YES];
    [textField setSelectable: YES];
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:[NSAttributedString hyperlinkFromString:textField.stringValue withURL:url]];
    
    // set the attributed string to the NSTextField
    [textField setAttributedStringValue: string];
    
}

- (void)populateMoreInformation
{
//    //setup pomodoro book pdf link
//    [self setupURL:[NSURL URLWithString:@"http://www.pomodorotechnique.com/resources/ThePomodoroTechnique_v1-3.pdf"]
//      forTextField:pomodoroBookLink];
//    
//    //setup pomdoro cheat sheet pdf link
//    [self setupURL:[NSURL URLWithString:@"http://www.pomodorotechnique.com/resources/EGG_cheat_sheet.pdf"]
//      forTextField:pomodoroCheatSheetLink];
    
    //setup pomodorable Feedback and Support link
    [self setupURL:[NSURL URLWithString:@"http://www.monoclesociety.com/r/eggscellent/support"]
      forTextField:pomodorableFeedbackAndSupportLink];
    
    //setup pomdorable facebook link
    [self setupURL:[NSURL URLWithString:@"http://www.facebook.com/eggscellent"]
      forTextField:pomodorableFacebookLink];
    
    //setup pomodorable twitter link
    [self setupURL:[NSURL URLWithString:@"http://www.twitter.com/eggscellent"]
      forTextField:pomodorableTwitterLink];
}

#pragma mark - IBActions: General

- (IBAction)toggleAutoLogin:(id)sender;
{
    NSMatrix *m = (NSMatrix *)sender;

    if([m selectedRow])
    {
        autoLogin = NO;
    }
    else 
    {
        autoLogin = YES;
    }
}

- (IBAction)changeTaskManagerTyper:(id)sender
{
    NSPopUpButton *popUpButton = (NSPopUpButton *)sender;
    
    NSUInteger i = [popUpButton indexOfSelectedItem];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:i] forKey:@"taskManagerType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - IBActions: Next Buttons

- (IBAction)goBackToGeneralView:(id)sender;
{
    [integrationOptionsView removeFromSuperview];
    [self.window.contentView addSubview:generalOptionsView];
}

- (IBAction)presentIntegrationView:(id)sender;
{
    [self processAutoLogin];
    [generalOptionsView removeFromSuperview];
    [self.window.contentView addSubview:integrationOptionsView];
}

- (IBAction)presentMoreInformationView:(id)sender;
{
    [integrationOptionsView removeFromSuperview];
    [self.window.contentView addSubview:moreInformationView];
}

- (IBAction)finishWelcomeExperience:(id)sender;
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"finishedFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self close];
    
    AppDelegate *appDelegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    
    [appDelegate setupTaskSyncing];
    [[appDelegate panelController] openPanel];
}

@end