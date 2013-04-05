# RDVKeychainAccess

`NSUserDefaults` - like keychain wrapper for iOS.

## Setup

Add `Security.framework` and drop the `RDVKeychainWrapper.h` and `RDVKeychainWrapper.m` into your project. If you don't have ARC
enabled, you will need to set a `-fobjc-arc` compiler flag on the `.m` source file.

## Example Usage

Add object to the keychain:

``` objective-c
[[RDVKeychainWrapper sharedKeychainWrapper] setObject:@"someString" forKey:@"someKey"];
```

Get an object from the keychain:

``` objective-c
[[RDVKeychainWrapper sharedKeychainWrapper] objectForKey:@"someKey"]
```

Remove an object from the keychain:

```objective-c
[[RDVKeychainWrapper sharedKeychainWrapper] removeObjectForKey:@"someKey"];
```

## Requirements

* ARC
* iOS 5.0 or later

## Contact

[Robert Dimitrov](http://github.com/robbdimitrov)  
[@robbdimitrov](https://twitter.com/robbdimitrov)

## License

RDVKeychainAccess is available under the MIT license. See the LICENSE file for more info.
