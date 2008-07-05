/* vi:set ts=8 sts=4 sw=4 ft=objc:
 *
 * VIM - Vi IMproved		by Bram Moolenaar
 *				MacVim GUI port by Bjorn Winckler
 *
 * Do ":help uganda"  in Vim to read copying and usage conditions.
 * Do ":help credits" in Vim to see a list of people who contributed.
 * See README.txt for an overview of the Vim source code.
 */


#import <Cocoa/Cocoa.h>



// NSUserDefaults keys
extern NSString *MMTabMinWidthKey;
extern NSString *MMTabMaxWidthKey;
extern NSString *MMTabOptimumWidthKey;
extern NSString *MMTextInsetLeftKey;
extern NSString *MMTextInsetRightKey;
extern NSString *MMTextInsetTopKey;
extern NSString *MMTextInsetBottomKey;
extern NSString *MMTerminateAfterLastWindowClosedKey;
extern NSString *MMTypesetterKey;
extern NSString *MMCellWidthMultiplierKey;
extern NSString *MMBaselineOffsetKey;
extern NSString *MMTranslateCtrlClickKey;
extern NSString *MMTopLeftPointKey;
extern NSString *MMOpenFilesInTabsKey;
extern NSString *MMNoFontSubstitutionKey;
extern NSString *MMLoginShellKey;
extern NSString *MMAtsuiRendererKey;
extern NSString *MMUntitledWindowKey;
extern NSString *MMTexturedWindowKey;
extern NSString *MMZoomBothKey;
extern NSString *MMCurrentPreferencePaneKey;
extern NSString *MMLoginShellCommandKey;
extern NSString *MMLoginShellArgumentKey;
extern NSString *MMDialogsTrackPwdKey;

// Enum for MMUntitledWindowKey
enum {
    MMUntitledWindowNever = 0,
    MMUntitledWindowOnOpen = 1,
    MMUntitledWindowOnReopen = 2,
    MMUntitledWindowAlways = 3
};




@interface NSIndexSet (MMExtras)
+ (id)indexSetWithVimList:(NSString *)list;
@end


@interface NSDocumentController (MMExtras)
- (void)noteNewRecentFilePath:(NSString *)path;
@end


@interface NSOpenPanel (MMExtras)
- (void)hiddenFilesButtonToggled:(id)sender;
- (void)setShowsHiddenFiles:(BOOL)show;
@end


@interface NSMenu (MMExtras)
- (int)indexOfItemWithAction:(SEL)action;
- (NSMenuItem *)itemWithAction:(SEL)action;
- (NSMenu *)findMenuContainingItemWithAction:(SEL)action;
- (NSMenu *)findWindowsMenu;
- (NSMenu *)findApplicationMenu;
- (NSMenu *)findServicesMenu;
- (NSMenu *)findFileMenu;
@end


@interface NSToolbar (MMExtras)
- (int)indexOfItemWithItemIdentifier:(NSString *)identifier;
- (NSToolbarItem *)itemAtIndex:(int)idx;
- (NSToolbarItem *)itemWithItemIdentifier:(NSString *)identifier;
@end


@interface NSTabView (MMExtras)
- (void)removeAllTabViewItems;
@end


@interface NSNumber (MMExtras)
- (int)tag;
@end



// Create a view to be used as accessory for open panel.  This function assumes
// ownership of the view so do not release it.
NSView *openPanelAccessoryView();

// Functions to create command strings that can be sent to Vim as input.
NSString *buildTabDropCommand(NSArray *filenames);
NSString *buildSelectRangeCommand(NSRange range);
NSString *buildSearchTextCommand(NSString *searchText);
