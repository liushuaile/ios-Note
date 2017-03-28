//
// Handle SSL certificate settings
//

if([[[[self url] scheme] lowercaseString] isEqualToString:@"https"]) {
    
    NSDictionary *sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"kCFStreamSocketSecurityLevelTLSv1_2SSLv3", (NSString *)kCFStreamSSLLevel,
                                   nil];
    
    CFReadStreamSetProperty((CFReadStreamRef)[self readStream],
                            kCFStreamPropertySSLSettings,
                            (CFTypeRef)sslProperties);
    
    // Tell CFNetwork not to validate SSL certificates
    if (![self validatesSecureCertificate]) {
        // see: http://iphonedevelopment.blogspot.com/2010/05/nsstream-tcp-and-ssl.html
        
        NSDictionary *sslProperties = [[NSDictionary alloc] initWithObjectsAndKeys:
                                       [NSNumber numberWithBool:YES], kCFStreamSSLAllowsExpiredCertificates,
                                       [NSNumber numberWithBool:YES], kCFStreamSSLAllowsAnyRoot,
                                       [NSNumber numberWithBool:NO],  kCFStreamSSLValidatesCertificateChain,
                                       kCFNull,kCFStreamSSLPeerName,
                                       @"kCFStreamSocketSecurityLevelTLSv1_2SSLv3", (NSString *)kCFStreamSSLLevel,
                                       nil];
        
        CFReadStreamSetProperty((CFReadStreamRef)[self readStream],
                                kCFStreamPropertySSLSettings,
                                (CFTypeRef)sslProperties);
    }
    
    // Tell CFNetwork to use a client certificate
    if (clientCertificateIdentity) {
        NSMutableDictionary *sslProperties = [NSMutableDictionary dictionaryWithCapacity:2];
        
        NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[clientCertificates count]+1];
        
        // The first object in the array is our SecIdentityRef
        [certificates addObject:(id)clientCertificateIdentity];
        
        // If we've added any additional certificates, add them too
        for (id cert in clientCertificates) {
            [certificates addObject:cert];
        }
        
        [sslProperties setObject:certificates forKey:(NSString *)kCFStreamSSLCertificates];
        [sslProperties setObject:@"kCFStreamSocketSecurityLevelTLSv1_2SSLv3" forKey:(NSString *)kCFStreamSSLLevel];
        
        CFReadStreamSetProperty((CFReadStreamRef)[self readStream], kCFStreamPropertySSLSettings, sslProperties);
    }
    
}
