//
//  ios-Note.h
//  ios-Note
//
//  Created by SL on 12/04/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#ifndef ios_Note_h
#define ios_Note_h

/*
 
 ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
 
 1、测量启动时间
 #MARK: Environment Variable
 Xcode -> Edit scheme -> Run -> Auguments 将环境变量 DYLD_PRINT_STATISTICS设为1
 
 ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
 
 2、代码静态分析
 #MARK: Static Analyzer - Analysis Policy
 Xcode -> Build Settings -> Analyzer During 'Build' 设定为YES
 
 ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
 
 3、僵尸指针追踪
 #MARK: Memory Management
 Xcode -> Edit scheme -> Run -> Diagnostics 勾选Zombie Objects
 
 ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～

 4、 openssl 生成公钥私钥。
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

 ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～

 5、clang（LLVM编译器）转换源码
 
 -rewrite-obj
 
 ～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～
 
6、OO(Object Oriented,面向对象)术语
 1 OOD：
 面向对象设计（Object-Oriented Design，OOD）方法是OO方法中一个中间过渡环节。其主要作用是对OOA分析的结果作进一步的规范化整理，以便能够被OOP直接接受。
 2 OOP：
 面向对象编程（Object Oriented Programming，OOP，面向对象程序设计）是一种计算机编程架构。OOP 的一条基本原则是计算机程序是由单个能够起到子程序作用的单元或对象组合而成。
 
 
 
 
 */

#endif /* ios_Note_h */
