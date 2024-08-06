//
//  XNUCLI.c
//  MyAssistant
//
//  Created by zd on 2/8/2024.
//

#include "XNUCLI.h"
#import <Foundation/Foundation.h>

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
extern int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
extern int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
extern int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);

int exec_cmd(char **cmd)
{
    posix_spawnattr_t attr;
    posix_spawnattr_init(&attr);
    
    posix_spawnattr_set_persona_np(&attr, 99, POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE);
    posix_spawnattr_set_persona_uid_np(&attr, 0);
    posix_spawnattr_set_persona_gid_np(&attr, 0);
    
    posix_spawn_file_actions_t action;
    posix_spawn_file_actions_init(&action);
    
    pid_t pid;
    pid_t child_pid;
    int status;
    
    NSMutableString *mutStr = [NSMutableString new];
    for (size_t i = 0; cmd[i] != NULL; i++)
    {
        [mutStr appendString:[NSString stringWithUTF8String:cmd[i]]];
        [mutStr appendString:@" "];
    }
    NSLog(@"log ---> %s:%d cli:%@",__FUNCTION__, __LINE__,[mutStr copy]);
    
    // 这里注意 cmd 也要包含在 argv[0]中传入
    posix_spawn(&pid, cmd[0], &action, &attr, cmd, NULL);
    child_pid = waitpid(pid, &status, WUNTRACED);
    if (child_pid < 0)
    {
        fprintf(stderr, "%s:%d error: %s\n", __FILE__, __LINE__, strerror(errno));
        NSLog(@"log ---> %s:%d error:%@",__FUNCTION__, __LINE__,[NSString stringWithUTF8String:strerror(errno)]);
        return -1;
    }
    printf("child_pid:%d\n", child_pid);
    int exit_state = WIFEXITED(status);
    if (exit_state == 0)
    {
        printf("The child process was terminated abnormally.signal %d\n", WTERMSIG(status));
        NSLog(@"log ---> %s:%d The child process was terminated abnormally.signal:%d",__FUNCTION__, __LINE__, WTERMSIG(status));
    }
    else
    {
        int exitno = WEXITSTATUS(status);
        printf("child process exit number : %d\n", exitno);
        NSLog(@"log ---> %s:%d child process exit number:%d",__FUNCTION__, __LINE__,exitno);
    }
    printf("status:%d\n", status);
    NSLog(@"log ---> %s:%d status:%d",__FUNCTION__, __LINE__,status);
    return status;
}

int init_cli_dir(char *path) {
    memcpy(cli_dir, path, strlen(path));
    return 0;
}

int move_file(char *src, char *dst) {
    //    cli_dir = cmd_line_dir;
    //    memcpy(cli_dir, cmd_line_dir, strlen(cmd_line_dir));
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/mv", cli_dir);
    char *command[] = {
        cli_path,
        src,
        dst,
        NULL};
    exec_cmd(command);
    
    return 0;
}

int copy_file(char *src, char *dst) {
    //    cli_dir = cmd_line_dir;
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/cp", cli_dir);
    char *command[] = {
        cli_path,
        src,
        dst,
        NULL};
    exec_cmd(command);
    return 0;
}

int delete_file(char *file_path) {
    //    cli_dir = cmd_line_dir;
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/rm", cli_dir);
    char *command[] = {
        cli_path,
        "-rf",
        file_path,
        NULL};
    exec_cmd(command);
    return 0;
}

int chmod_file(char *file_path) {
    //    cli_dir = cmd_line_dir;
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/chmod", cli_dir);
    char *command[] = {
        cli_path,
        "-R",
        "777",
        file_path,
        NULL};
    exec_cmd(command);
    return 0;
}

int inject_macho(char *file_path, char *dylib_search_path) {
    // --mpath /var/mobile/Documents/App --dpath @rpath/libzdLog.dylib --cmd LC_LOAD_WEAK_DYLIB
    //insert_dylib --weak --inplace --no-strip-codesig @rpath/libzdLog.dylib /var/mobile/Documents/App
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/insert_dylib", cli_dir);
    char *command[] = {
        cli_path,
        "--weak",
        "--inplace",
        "--no-strip-codesig",
        dylib_search_path,
        file_path,
        NULL};
    exec_cmd(command);
    return 0;
}

int ldid_sign(char *file_path) {
    //    cli_dir = cmd_line_dir;
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/ldid", cli_dir);
    char *command[] = {
        cli_path,
        "-S",
        file_path,
        NULL};
    exec_cmd(command);
    return 0;
}

int ct_bypass(char *target_file_path,char *src_file_path){
    //    cli_dir = cmd_line_dir;
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/ct_bypass", cli_dir);
    char *command2[] = {
        cli_path,
        "-r",
        "-i",
        target_file_path,
        "-A",
        src_file_path,
        NULL};
    exec_cmd(command2);
    return 0;
}

int ct_bypass_by_teamid(char *target_file_path,char *teamid) {
    char cli_path[0x100] = {0};
    sprintf(cli_path, "%s/ct_bypass", cli_dir);
    char *command2[] = {
        cli_path,
        "-r",
        "-i",
        target_file_path,
        "-t",
        teamid,
        NULL};
    exec_cmd(command2);
    return 0;
}
