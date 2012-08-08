//
//  UDPClient.m
//  Shelby-tv
//
//  Created by Arthur Ariel Sabintsev on 8/8/12.
//  Copyright (c) 2012 Shelby.tv. All rights reserved.
//

#import "UDPClient.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>

@interface UDPClient ()

+ (void)sendMessageData:(NSData*)messageData;

@end

@implementation UDPClient

+ (void)incrementGraphiteForStatistic:(NSString *)statistic
{
    
    NSString *device;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        device = @"iphone";
    } else {
        device = @"ipad";
    }

    NSString *message = [NSString stringWithFormat:@"ios.%@.%@", device, statistic];
    
    [UDPClient sendMessageData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    
}

+ (void)sendMessageData:(NSData *)messageData
{
    
    // Create Socket
    CFSocketRef socket = CFSocketCreate(NULL, PF_INET, SOCK_DGRAM, IPPROTO_UDP, kCFSocketNoCallBack, NULL, NULL);
    
    if (!socket) {
        NSLog(@"CfSocketCreate Failed");
    }
    
    // Create socket address struct
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = PF_INET;
    addr.sin_addr.s_addr = inet_addr("10.181.128.15");
//    addr.sin_addr.s_addr = inet_addr("184.106.80.31");
    addr.sin_port = htons(8125);
    CFDataRef cfAddressData = CFDataCreate(NULL, (unsigned char*)&addr, sizeof(addr));
    
    int connect = CFSocketConnectToAddress(socket, cfAddressData, 10);
    NSLog(@"connect: %d", connect); // Should be 0
    
    CFDataRef cfMessageData = CFDataCreate(NULL, [messageData bytes], [messageData length]);
    int sent = CFSocketSendData (socket, NULL, cfMessageData, 10);
    NSLog(@"sent: %d", sent); // Should be 0
}

@end
