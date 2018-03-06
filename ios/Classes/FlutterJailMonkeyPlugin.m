#import "FlutterJailMonkeyPlugin.h"

@implementation FlutterJailMonkeyPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
            methodChannelWithName:@"flutter_jail_monkey"
                  binaryMessenger:[registrar messenger]];
    FlutterJailMonkeyPlugin *instance = [[FlutterJailMonkeyPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"isJailBroken" isEqualToString:call.method]) {
        result(self.isJailBroken);
    } else if ([@"canMockLocation" isEqualToString:call.method]) {
        result(self.isJailBroken);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (BOOL)canViolateSandbox {
    NSError *error;
    NSString *stringToBeWritten = @"This is an anti-spoofing test.";
    [stringToBeWritten writeToFile:@"/private/jailbreak.txt" atomically:YES
                          encoding:NSUTF8StringEncoding error:&error];
    if (error == nil) {
        return YES;
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/jailbreak.txt" error:nil];
        return NO;
    }
}

- (id)isJailBroken {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]) {
        return @YES;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]) {
        return @YES;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]) {
        return @YES;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/sbin/sshd"]) {
        return @YES;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/etc/apt"]) {
        return @YES;
    } else if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt"]) {
        return @YES;
    } else if (self.canViolateSandbox) {
        return @YES;
    } else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
        return @YES;
    }

    return @NO;
}

@end
