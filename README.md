# spawn_root

TrollStore 以 root 权限 执行 cli    </br>
https://github.com/opa334/TrollStore/blob/main/Shared/TSUtil.m#L79

## Root Helpers

When your app is not sandboxed, you can spawn other binaries using posix_spawn, you can also spawn binaries as root with the following entitlement:
<key>com.apple.private.persona-mgmt</key>
<true/>
