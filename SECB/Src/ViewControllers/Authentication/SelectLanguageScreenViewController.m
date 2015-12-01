//
//  SelectLanguageScreenViewController.m
//  SECB
//
//  Created by Peter Mosaad on 10/23/15.
//  Copyright (c) 2015 Peter Mosaad. All rights reserved.
//

#import "SelectLanguageScreenViewController.h"
#import "SignInViewController.h"

@interface SelectLanguageScreenViewController ()

@end

@implementation SelectLanguageScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didSelectLanguageBefore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)englishLanguagePressed:(id)sender
{
    SetAppLanguage(UILanguageEnglish);
    [self.navigationController setViewControllers:[NSArray arrayWithObject:[SignInViewController new]] animated:YES];

}
- (IBAction)arabicLanguagePressed:(id)sender
{
    SetAppLanguage(UILanguageArabic);
    [self.navigationController setViewControllers:[NSArray arrayWithObject:[SignInViewController new]] animated:YES];

}
@end
