//
//  ViewController.m
//  spawnRoot
//
//  Created by zd on 2/8/2024.
//

#import "ViewController.h"
#import <mach-o/dyld.h>
#import "TSUtil.h"
#import "XNUCLI.h"

static char *target_matho_file = "/private/var/containers/Bundle/Application/9E42742D-3468-4A87-8D12-C480DFCF1FE5/WeChat.app/Frameworks/App.framework/App";
static char *macho_exec_path = "/var/containers/Bundle/Application/9E42742D-3468-4A87-8D12-C480DFCF1FE5/WeChat.app/WeChat";
static char *handle_macho_path = "/var/mobile/Documents/App";

static NSString *cmd_dir_oc = nil;

@interface ViewController ()
{
    NSString *docDir;
    NSString *bundlePath;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self show_all_image_info];
    
    //    docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    //    NSLog(@"docDir:\n%@",docDir);
    bundlePath = [[NSBundle mainBundle] bundlePath];
    NSLog(@"bundlePath:\n%@",bundlePath);
    
    cmd_dir_oc = bundlePath;
    init_cli_dir((char *)[cmd_dir_oc UTF8String]);
}

//-(void)show_all_image_info {
//    uint32_t count = _dyld_image_count();
//    for (uint32_t i = 0 ; i < count; ++i) {
//        const char *image_name = _dyld_get_image_name(i);
//        //        printf("%s\n",name);
//        NSString *image_name2 = [NSString stringWithUTF8String:image_name];
//        NSLog(@"log ---> image_name:%@",image_name2);
//    }
//}

- (IBAction)chmod_btn_act:(UIButton *)sender {
    
}

- (IBAction)spawn_btn_action:(UIButton *)sender {
    delete_file(target_matho_file);
}

- (IBAction)my_c_code_5:(UIButton *)sender {
    copy_file(target_matho_file, handle_macho_path);
}

- (IBAction)spawn2_btn_action:(UIButton *)sender {
    
}

- (IBAction)btn3_act:(UIButton *)sender {
    ldid_sign(handle_macho_path);
}

- (IBAction)btn4_act:(UIButton *)sender {
    ct_bypass(handle_macho_path, macho_exec_path);
}

- (IBAction)o_test_chmod_act:(UIButton *)sender {
    // extern int spawnRoot(NSString* path, NSArray* args, NSString** stdOut, NSString** stdErr);
    NSString *path = [NSString stringWithFormat:@"%@/cp",cmd_dir_oc];
    
    NSMutableArray *args = [NSMutableArray new];
    NSString *tmp = [NSString stringWithUTF8String:target_matho_file];
    [args addObject:tmp];
    tmp = [NSString stringWithUTF8String:handle_macho_path];
    [args addObject:tmp];
    
    NSString *stdOut; NSString *stdErr;
    
    int ret = spawnRoot(path, args, &stdOut, &stdErr);
    NSLog(@"log ---> %s:%d ret:%d",__FUNCTION__, __LINE__,ret);
    NSLog(@"log ---> %s:%d stdOut:%@",__FUNCTION__, __LINE__,stdOut);
    NSLog(@"log ---> %s:%d stdErr:%@",__FUNCTION__, __LINE__,stdErr);
}

- (IBAction)o_inject_btn_act:(UIButton *)sender {
    // inject --mpath /var/mobile/Documents/App --dpath @rpath/libzdLog.dylib --cmd LC_LOAD_WEAK_DYLIB
    // insert_dylib --weak --inplace --no-strip-codesig @rpath/libzdLog.dylib /var/mobile/Documents/App
    NSString *path = [NSString stringWithFormat:@"%@/insert_dylib",cmd_dir_oc];
    
    NSString *tmp = [NSString stringWithUTF8String:handle_macho_path];
    NSArray *args = [NSArray arrayWithObjects:@"--weak",
                     @"--inplace",
                     @"--no-strip-codesig",
                     @"@rpath/libSwiftCore.dylib",
                     tmp,
                     nil];
    
    NSString *stdOut; NSString *stdErr;
    
    int ret = spawnRoot(path, args, &stdOut, &stdErr);
    NSLog(@"log ---> %s:%d ret:%d",__FUNCTION__, __LINE__,ret);
    NSLog(@"log ---> %s:%d stdOut:%@",__FUNCTION__, __LINE__,stdOut);
    NSLog(@"log ---> %s:%d stdErr:%@",__FUNCTION__, __LINE__,stdErr);
}

- (IBAction)o_ldid:(UIButton *)sender {
    NSString *path = [NSString stringWithFormat:@"%@/ldid",cmd_dir_oc];
    
    NSArray *args = [NSArray arrayWithObjects:@"-S",
                     @"/var/mobile/Documents/App",
                     nil];
    
    NSString *stdOut; NSString *stdErr;
    
    int ret = spawnRoot(path, args, &stdOut, &stdErr);
    NSLog(@"log ---> %s:%d ret:%d",__FUNCTION__, __LINE__,ret);
    NSLog(@"log ---> %s:%d stdOut:%@",__FUNCTION__, __LINE__,stdOut);
    NSLog(@"log ---> %s:%d stdErr:%@",__FUNCTION__, __LINE__,stdErr);
}

- (IBAction)o_ctpass:(UIButton *)sender {
    NSString *path = [NSString stringWithFormat:@"%@/ct_bypass",cmd_dir_oc];
    
    NSArray *args = [NSArray arrayWithObjects:@"-r",
                     @"-i",
                     @"/var/mobile/Documents/App",
                     @"-t",
                     @"88L2Q4487U",
                     nil];
    
    NSString *stdOut; NSString *stdErr;
    
    int ret = spawnRoot(path, args, &stdOut, &stdErr);
    NSLog(@"log ---> %s:%d ret:%d",__FUNCTION__, __LINE__,ret);
    NSLog(@"log ---> %s:%d stdOut:%@",__FUNCTION__, __LINE__,stdOut);
    NSLog(@"log ---> %s:%d stdErr:%@",__FUNCTION__, __LINE__,stdErr);
}

@end
