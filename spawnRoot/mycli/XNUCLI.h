//
//  XNUCLI.h
//  MyAssistant
//
//  Created by zd on 2/8/2024.
//

#ifndef XNUCLI_h
#define XNUCLI_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <spawn.h>

static char cli_dir[0x100] = {0};
int init_cli_dir(char *path);

int exec_cmd(char **cmd);

int move_file(char *src, char *dst);
int copy_file(char *src, char *dst);
int delete_file(char *file_path);
int chmod_file(char *file_path);

int inject_macho(char *file_path, char *dylib_search_path);
int ldid_sign(char *file_path);
int ct_bypass(char *target_file_path,char *src_file_path);
int ct_bypass_by_teamid(char *target_file_path,char *teamid);

#endif /* XNUCLI_h */
