//
//  RSAViewController.m
//  Note
//
//  Created by SL on 10/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "RSAViewController.h"
#import "RSAEncryptor.h"

static NSString * const PUBLIC_KEY = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDVF76tE3Yi56CJfUDdPvKp3jH+"
"jqmTtqOwR3JoPayvlNLFp3Pa9C+7SL17OhcP8wKogSoMrqt2x678WhglQTDu46fU"
"afjBDQpMIohIGZX/gEWAeTYtW6+m7NBRxJxxZeSoAA1Qy8Gh0Yut41ua8YpX79Yo"
"0ZxlSlA/sxeSus6myQIDAQAB";

static NSString * const PRIVATE_KEY = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBANUXvq0TdiLnoIl9"
"QN0+8qneMf6OqZO2o7BHcmg9rK+U0sWnc9r0L7tIvXs6Fw/zAqiBKgyuq3bHrvxa"
"GCVBMO7jp9Rp+MENCkwiiEgZlf+ARYB5Ni1br6bs0FHEnHFl5KgADVDLwaHRi63j"
"W5rxilfv1ijRnGVKUD+zF5K6zqbJAgMBAAECgYEAiI8p++Kf76h+wf2J5v9jJacm"
"ZNrqI6aE6gAvekwj8XWvSUmRvnyEZkIsY98LToZOaswztWLusTUwl7npBV7sys6Z"
"hJv8vyJTZe7HovcQf6skifwV+iTb1+otU/GnXxpHyNvmz5MNYemw46LmkJdKzkoE"
"BbLFKIdytyT5ctpnKr0CQQD+VwagcPwCr5O11zy2zggqOe4QXjcr/rFWhELROvhP"
"jd2QYE6r2QjNr/Y9r9eYlYjkI8yfEQrQ/X+u/6a7vTlTAkEA1nvMpoENRTIqjz4q"
"lXet7O3Wfb0ibXZBjcGIszNWqaQH1kHMv4p0aW7VY0dgDfftEphEfmb6/fzeXFa6"
"0Ekv8wJASxg61qhFYC2i+S+ht3/BnWYZSi/nLlA24AqRB+HXavXCE1y8HbUpCkIH"
"/FKs31pXXrTLN7P6c5ZFWtAU1J2cDQJBAK5RT7LDkBV9ADoLPHDeI+08H+dxoFl2"
"kzCy6nc6cmTNe9EXCWFjFdnaynM1v0ubBILoXkKdT8C9k7tYgdxmnyECQQDDCsAV"
"E6e7h0EENZhMDpw2c0G+qYUrfQKkn3AjR+DZwXsWt5B+wNM+Ml5ljKYR5ciNlWvh"
"ilHOTr8V5xhGBymq";


@interface RSAViewController ()

@end

@implementation RSAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn01 showPlaceHolder];
    btn01.backgroundColor = [UIColor orangeColor];
    [btn01 addTarget:self action:@selector(rsaByDerFile) forControlEvents:UIControlEventTouchUpInside];
    [btn01 setTitle:@"Der文件加密" forState:UIControlStateNormal];
    [self.view addSubview:btn01];
    
    UIButton *btn02 = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn02 showPlaceHolder];
    btn02.backgroundColor = [UIColor orangeColor];
    [btn02 addTarget:self action:@selector(rsaByStringKey) forControlEvents:UIControlEventTouchUpInside];
    [btn02 setTitle:@"key字符串加密" forState:UIControlStateNormal];
    [self.view addSubview:btn02];

    
    [btn01 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        //make.size.mas_equalTo(CGSizeMake(120, 44));
        make.bottom.equalTo(self.view.mas_centerY).with.offset(-10);
//        make.bottom.equalTo(btn02.mas_bottom).with.offset(-10);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@120);
        
    }];
    
    [btn02 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_centerY).with.offset(+10);
//        make.top.equalTo(btn01.mas_bottom).with.offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@120);
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Methods
- (void)rsaByDerFile {
    
    //原始数据
    
    NSString *originalString = @"这是一段将要使用'.der'文件加密的字符串!";
    
    //使用.der和.p12中的公钥私钥加密解密
    
    NSString *public_key_path = [[NSBundle mainBundle] pathForResource:@"public_key.der" ofType:nil];
    //
    NSString *private_key_path = [[NSBundle mainBundle] pathForResource:@"private_key.p12" ofType:nil];
    
    
    RSAEncryptor *rsaHandle = [RSAEncryptor sharedInstance];
    [rsaHandle loadPublicKeyFromFile:public_key_path];
    [rsaHandle loadPrivateKeyFromFile:private_key_path password:@"123456"];
    
    NSString *encryptStr = [rsaHandle rsaEncryptString:originalString];
    
    NSLog(@"加密前:%@", originalString);
    
    NSLog(@"加密后:%@", encryptStr);
    
    NSString *deEncryptStr = [rsaHandle rsaDecryptString:encryptStr];
    
    NSLog(@"解密后:%@", deEncryptStr);
}

- (void)rsaByStringKey {
    NSString *originalString = @"这是一段将要使用'PUBLIC_KEY'字符串加密的字符串!";
    
    NSLog(@"加密前:%@", originalString);

    NSString *encryptStr = [RSAEncryptor encryptString:originalString publicKey:PUBLIC_KEY];
    
    NSLog(@"加密后:%@", encryptStr);
    
    NSString *deEncryptStr = [RSAEncryptor decryptString:encryptStr privateKey:PRIVATE_KEY];
    
    NSLog(@"解密后:%@", deEncryptStr);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
