//
//  CRSA.m
//  RSATest
//
//  Created by Yuanin on 16/5/25.
//  Copyright © 2016年 Yuanin. All rights reserved.
//

#import "CRSA.h"

#define PADDING RSA_PADDING_TYPE_PKCS1
@implementation CRSA

+ (id)shareInstance
{
    static CRSA *_crsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _crsa = [[self alloc] init];
    });
    return _crsa;
}
- (BOOL)importRSAKeyWithType:(KeyType)type
{
    FILE *file;
    NSString *keyName = type == KeyTypePublic ? @"aimilicai_public" : @"aimilicai_private";
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:keyName ofType:@"pem"];
    
    file = fopen([keyPath UTF8String], "rb");
    
    if (NULL != file)
    {
        if (type == KeyTypePublic)
        {
            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        else
        {
            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
            assert(_rsa != NULL);
        }
        
        fclose(file);
        
        return (_rsa != NULL) ? YES : NO;
    }
    
    return NO;
}

- (NSString *) encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;
    size_t length  = strlen([content UTF8String]);//(int)[content length];
    unsigned char input[length + 1];
    bzero(input, length + 1);
    int i = 0;
    for (; i < length; i++) {
        input[i] = [content UTF8String][i];// [content characterAtIndex:i];
    }
    
    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    
    char *encData = (char*)malloc(flen);
    bzero(encData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_encrypt((int)length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_encrypt((int)length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
            break;
    }
    
    if (status) {
        NSData *returnData = [NSData dataWithBytes:encData length:status];
        free(encData);
        encData = NULL;
        
        NSString *ret = [self base64Encrypt:returnData];
        return ret;
    }
    
    free(encData);
    encData = NULL;
    
    return nil;
}

- (NSString *) decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
    if (![self importRSAKeyWithType:keyType])
        return nil;
    
    int status;
    
    NSData *data = [self base64Unencrypt:content];
    int length = (int)[data length];
    
    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
    char *decData = (char*)malloc(flen);
    bzero(decData, flen);
    
    switch (keyType) {
        case KeyTypePublic:
            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
            
        default:
            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
            break;
    }
    
    if (status)
    {
        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
        free(decData);
        decData = NULL;
        
        return decryptString;
    }
    
    free(decData);
    decData = NULL;
    
    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type
{
    int len = RSA_size(_rsa);
    
    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
        len -= 11;
    }
      
    return len;
}


- (NSString *)base64Encrypt:(NSData *)data {
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSData *)base64Unencrypt:(NSString *)string {
    
    return [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
}
@end
