

// http://www.cnblogs.com/makemelike/articles/3802518.html



#import <Foundation/Foundation.h>

@interface RSAEncryptor : NSObject

#pragma mark - Instance Methods
- (void) loadPublicKeyFromFile: (NSString*) derFilePath;
- (void) loadPublicKeyFromData: (NSData*) derData;

- (void) loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password;
- (void) loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password;

- (NSString*) rsaEncryptString:(NSString*)string;
- (NSData*) rsaEncryptData:(NSData*)data ;

- (NSString*) rsaDecryptString:(NSString*)string;
- (NSData*) rsaDecryptData:(NSData*)data;

#pragma mark - Class Methods
+ (void) setSharedInstance: (RSAEncryptor*)instance;
+ (RSAEncryptor*) sharedInstance;


#pragma mark- 
/*These APIs uesd to encrypt/decrypt data/string by pulick/private string.
 Sometimes we need to encrypt issue with string keys which wo get from web sercives.
 The goverment doesn't provide api which is able to encrypt/decrypt issue without certificate.
 
 The APIs fudges certificates use the pramaters 'str'.
 
 下面的api直接使用公私钥的字符串进行RSA加密。由于官方没有直接提供对应的api，所以这里使用公私钥字符串来伪造证书进行加密。
 */
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;

@end

/*
 openssl 生成公钥私钥。
 
 1）打开终端，在终端中cd到你想保存公钥私钥的文件夹
 
 2）生成模长为1024bit的私钥文件private_key.pem
 
 openssl genrsa -out private_key.pem 1024
 
 3）生成证书请求文件rsaCertReq.csr
 
 openssl req -new -key private_key.pem -out rsaCerReq.csr
 
 PS：这一步会提示输入国家、省份、mail等信息，可以根据实际情况填写，或者全部不用填写，直接全部敲回车.
 
 4) 生成证书rsaCert.crt，并设置有效时间为1年
 
 openssl x509 -req -days 3650 -in rsaCerReq.csr -signkey private_key.pem -out rsaCert.crt
 
 5）生成供iOS使用的公钥文件public_key.der
 
 openssl x509 -outform der -in rsaCert.crt -out public_key.der
 
 6）生成供iOS使用的私钥文件private_key.p12
 
 openssl pkcs12 -export -out private_key.p12 -inkey private_key.pem -in rsaCert.crt
 
 注意：这一步会提示给私钥文件设置密码，直接输入想要设置密码即可，然后敲回车，然后再验证刚才设置的密码，再次输入密码，然后敲回车，完毕！
 
 在解密时，private_key.p12文件需要和这里设置的密码配合使用，因此需要牢记此密码.
 
 PS:正常来说公钥是加密使用，私钥是解密使用，我们做数据加密可以跟后台要公钥，然后将数据加密后给后台，让后台利用私钥解密，因为现在没有后台，此时我们自己生成公钥私钥
 */
