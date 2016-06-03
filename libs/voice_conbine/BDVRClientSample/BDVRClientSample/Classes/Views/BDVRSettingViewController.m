//
//  VRSettingViewController.m
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25.
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import "BDVRSettingViewController.h"
#import "BDVRSConfig.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRViewController.h"
#import "BDVRPickerTableViewCell.h"

// 类实现
@implementation BDVRSettingViewController
{
    NSDictionary *_propertyDic;
    NSMutableArray *_themeArray;
    NSArray *_languageArray;
}
@synthesize clientSampleViewController;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style
{
	// Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
	self = [super initWithStyle:style];
	if (self)
	{
        _propertyDic = [@{ @10060 : @"地图",
                           @10001 : @"音乐",
                           @10002 : @"视频",
                           @10003 : @"应用",
                           @10004 : @"web",
                           @10005 : @"热词",
                           @10006 : @"电商购物",
                           @10007 : @"健康母婴",
                           @10008 : @"打电话",
                           @20000 : @"输入法",
                           @100014 : @"联系人指令",
                           @100016 : @"手机设置",
                           @100018 : @"电视指令",
                           @100019 : @"播放器指令",
                           @100020 : @"收音机"} retain];
        _themeArray = [[NSMutableArray alloc] init];

        if ([BDTheme lightBlueTheme])
        {
            [_themeArray addObject:[BDTheme lightBlueTheme]];
        }
        if ([BDTheme lightGreenTheme])
        {
            [_themeArray addObject:[BDTheme lightGreenTheme]];
        }
        if ([BDTheme lightOrangeTheme])
        {
            [_themeArray addObject:[BDTheme lightOrangeTheme]];
        }
        if ([BDTheme lightRedTheme])
        {
            [_themeArray addObject:[BDTheme lightRedTheme]];
        }
        if ([BDTheme darkBlueTheme])
        {
            [_themeArray addObject:[BDTheme darkBlueTheme]];
        }
        if ([BDTheme darkGreenTheme])
        {
            [_themeArray addObject:[BDTheme darkGreenTheme]];
        }
        if ([BDTheme darkOrangeTheme])
        {
            [_themeArray addObject:[BDTheme darkOrangeTheme]];
        }
        if ([BDTheme darkRedTheme])
        {
            [_themeArray addObject:[BDTheme darkRedTheme]];
        }
        if ([BDTheme defaultFullScreenTheme])
        {
            [_themeArray addObject:[BDTheme defaultFullScreenTheme]];
        }
        _languageArray = [@[@"普通话", @"粤语", @"English", @"四川话"] retain];
		// Custom initialization.
	}
	return self;
}



#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.tableView.scrollEnabled = YES;
	self.title = NSLocalizedString(@"StringVRSetting", nil);

	UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"StringFinishSetting", nil) style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
	self.navigationItem.leftBarButtonItem = backBarButtonItem;
	[backBarButtonItem release];
}

- (void)backAction:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// Return the number of sections.
	return 4;
}

- (void)setNeedNLU:(UISwitch *)sender
{
    [BDVRSConfig sharedInstance].isNeedNLU = sender.on;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 3;
    }
    else if (section == 2)
    {
        return 3;
    }
    else
    {
        return 1;
    }
}

- (void)resultContinuousShowSwitch:(UISwitch *)sender
{
	[BDVRSConfig sharedInstance].resultContinuousShow = sender.on;
}

- (void)uiHintMusicSwitch:(UISwitch *)sender
{
	[BDVRSConfig sharedInstance].uiHintMusicSwitch = sender.on;
}

- (void)playStartMusicSwitch:(UISwitch *)sender
{
	[BDVRSConfig sharedInstance].playStartMusicSwitch = sender.on;
	if (sender.on)
	{
		[[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:YES];
	}
	else 
	{
		[[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecStart isPlay:NO];
	}
}

- (void)playEndMusicSwitch:(UISwitch *)sender
{
	[BDVRSConfig sharedInstance].playEndMusicSwitch = sender.on;
	if (sender.on)
	{
		[[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:YES];
	}
	else 
	{
		[[BDVoiceRecognitionClient sharedInstance] setPlayTone:EVoiceRecognitionPlayTonesRecEnd isPlay:NO];
	}
}

- (void)voiceLevelMeterSwitch:(UISwitch *)sender
{
	[BDVRSConfig sharedInstance].voiceLevelMeter = sender.on;
	if (sender.on)
	{
		[[BDVoiceRecognitionClient sharedInstance] listenCurrentDBLevelMeter];
	}
	else
	{
		[[BDVoiceRecognitionClient sharedInstance] cancelListenCurrentDBLevelMeter];
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

	int row = [indexPath row];
    int section = [indexPath section];

    static NSString *CellIdentifier = @"Cell";
    static NSString *PickerCellIdentifier = @"PickerCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:(indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 1) ?
                                                                         PickerCellIdentifier : CellIdentifier];

    if (cell == nil)
    {
        if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 1))
        {
            cell = [[[BDVRPickerTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:PickerCellIdentifier] autorelease];
            ((BDVRPickerTableViewCell *)cell).pickerView.delegate = self;
            ((BDVRPickerTableViewCell *)cell).pickerView.tag = section * 10 + row;
        }
        else
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
    } else {
        if ((indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 0 && indexPath.row == 2) || (indexPath.section == 2 && indexPath.row == 1))
        {
            ((BDVRPickerTableViewCell *)cell).pickerView.delegate = self;
            ((BDVRPickerTableViewCell *)cell).pickerView.tag = section * 10 + row;
        }
    }


	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	cell.textLabel.textColor = [UIColor blackColor];

    if (section == 0)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"StringRecoginitonMode", nil);
            
            UILabel *propertyLable = [[UILabel alloc] initWithFrame:CGRectZero];
            propertyLable.frame = CGRectMake(-40, 0, 66, 40);
            propertyLable.textAlignment = UITextAlignmentCenter;
            propertyLable.font = [UIFont boldSystemFontOfSize:14.0];
            propertyLable.textColor = [UIColor blackColor];
            propertyLable.backgroundColor = [UIColor clearColor];
            NSNumber *key = [BDVRSConfig sharedInstance].recognitionProperty;
            propertyLable.text = [_propertyDic objectForKey:key];
            cell.accessoryView = propertyLable;
            [propertyLable release];
        }
        else if (row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"StringRecoginitonNLU", nil);
            UISwitch *tmpSwitch = [[UISwitch alloc] init];
            tmpSwitch.on = NO;
            tmpSwitch.on = [BDVRSConfig sharedInstance].isNeedNLU;
            
            [tmpSwitch addTarget:self action:@selector(setNeedNLU:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tmpSwitch;
            [tmpSwitch release];
        }
        else if (row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"StringLanguage", nil);
            
            UILabel *sampleRateLable = [[UILabel alloc] initWithFrame:CGRectZero];
            sampleRateLable.frame = CGRectMake(-40, 0, 66, 40);
            sampleRateLable.textAlignment = UITextAlignmentCenter;
            sampleRateLable.font = [UIFont boldSystemFontOfSize:14.0];
            sampleRateLable.textColor = [UIColor blackColor];
            sampleRateLable.backgroundColor = [UIColor clearColor];
            sampleRateLable.text = [_languageArray objectAtIndex:[BDVRSConfig sharedInstance].recognitionLanguage];
            cell.accessoryView = sampleRateLable;
            [sampleRateLable release];
        }
    }
    else if (section == 1)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"StringPlayStartMusic", nil);
            UISwitch *tmpSwitch = [[UISwitch alloc] init];
            tmpSwitch.on = [BDVRSConfig sharedInstance].playStartMusicSwitch;
            [tmpSwitch addTarget:self action:@selector(playStartMusicSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tmpSwitch;
            [tmpSwitch release];
        }
        else if (row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"StringPlayEndMusic", nil);
            UISwitch *tmpSwitch = [[UISwitch alloc] init];
            tmpSwitch.on = [BDVRSConfig sharedInstance].playEndMusicSwitch;
            [tmpSwitch addTarget:self action:@selector(playEndMusicSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tmpSwitch;
            [tmpSwitch release];
        }
        else if (row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"StringSaveVoiceLevelMeter", nil);
            UISwitch *tmpSwitch = [[UISwitch alloc] init];
            tmpSwitch.on = [BDVRSConfig sharedInstance].voiceLevelMeter;
            [tmpSwitch addTarget:self action:@selector(voiceLevelMeterSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tmpSwitch;
            [tmpSwitch release];
        }
    }
    else if (section == 2)
    {
        if (row == 0)
        {
            cell.textLabel.text = NSLocalizedString(@"StringRecoginitonResultContinuousShow", nil);
            UISwitch *tmpSwitch = [[UISwitch alloc] init];
            tmpSwitch.on = [BDVRSConfig sharedInstance].resultContinuousShow;
            [tmpSwitch addTarget:self action:@selector(resultContinuousShowSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tmpSwitch;
            [tmpSwitch release];
        }
        else if (row == 1)
        {
            cell.textLabel.text = NSLocalizedString(@"StringTheme", nil);
            
            UILabel *sampleRateLable = [[UILabel alloc] initWithFrame:CGRectZero];
            sampleRateLable.frame = CGRectMake(-40, 0, 44, 40);
            sampleRateLable.textAlignment = UITextAlignmentCenter;
            sampleRateLable.font = [UIFont boldSystemFontOfSize:14.0];
            sampleRateLable.textColor = [UIColor blackColor];
            sampleRateLable.backgroundColor = [UIColor clearColor];
            sampleRateLable.text = [BDVRSConfig sharedInstance].theme.name;
            cell.accessoryView = sampleRateLable;
            [sampleRateLable release];
        }
        else if (row == 2)
        {
            cell.textLabel.text = NSLocalizedString(@"StringClosedUIHintMusic", nil);
            UISwitch *tmpSwitch = [[UISwitch alloc] init];
            tmpSwitch.on = [BDVRSConfig sharedInstance].uiHintMusicSwitch;
            [tmpSwitch addTarget:self action:@selector(uiHintMusicSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = tmpSwitch;
            [tmpSwitch release];
        }
    }
    else
    {
        if (row == 0)
        {
            cell.accessoryView = nil;
            cell.textLabel.text = NSLocalizedString(@"StringLibVersion", nil);
            cell.textLabel.text = [cell.textLabel.text stringByAppendingString:[BDVRSConfig sharedInstance].libVersion];
        }
    }
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *titleString = nil;
    if (section == 0)
    {
        titleString = NSLocalizedString(@"StringSectionTitleCommon", nil);
    }
    else if (section == 1)
    {
        titleString = NSLocalizedString(@"StringSectionTitleNoUI", nil);
    }
    else if (section == 2)
    {
        titleString = NSLocalizedString(@"StringSectionTitleUI", nil);
    }
    else
    {
        titleString = NSLocalizedString(@"StringSectionTitleVersion", nil);
    }
    
    return titleString;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case 0:
            [BDVRSConfig sharedInstance].recognitionProperty = [[_propertyDic allKeys] objectAtIndex:row];
            break;
        case 2:
            [BDVRSConfig sharedInstance].recognitionLanguage = row;
            break;
        case 21:
            [BDVRSConfig sharedInstance].theme = [_themeArray objectAtIndex:row];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *name = @"";
    switch (pickerView.tag) {
        case 0:
            name = [_propertyDic objectForKey:[[_propertyDic allKeys] objectAtIndex:row]];
            break;
        case 2:
            name = [_languageArray objectAtIndex:row];
            break;
        case 21:
            name = [[_themeArray objectAtIndex:row] name];
            break;
        default:
            break;
    }
    return name;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = 320.0;

    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRows = 0;
    switch (pickerView.tag) {
        case 0:
            numberOfRows = [[_propertyDic allKeys] count];
            break;
        case 2:
            numberOfRows = [_languageArray count];
            break;
        case 21:
            numberOfRows = [_themeArray count];
            break;
        default:
            break;
    }
	return numberOfRows;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];

	// Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
	// Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	// For example: self.myOutlet = nil;
}


- (void)dealloc
{
    [_themeArray release];
    [_languageArray release];
    [super dealloc];
}


@end // VRSettingViewController

