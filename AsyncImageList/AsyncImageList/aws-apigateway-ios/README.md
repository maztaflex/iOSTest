# Prerequisites

The generated SDK depends on the AWS Mobile SDK for iOS. There are two ways to import it into your project:

* CocoaPods
* Frameworks

You should use one of these two ways to import the AWS Mobile SDK but not both. Importing both ways loads two copies of the SDK into the project and causes compiler errors.

## With CocoaPods

1. The AWS Mobile SDK for iOS is available through [CocoaPods](https://cocoapods.org/). If you have not installed CocoaPods, install it by running the command:

        $ sudo gem install cocoapods

1. Move the generated `Podfile` to the same directory as your Xcode project file. If your project already has `Podfile`, you can add the following line to the existing `Podfile`.

        pod 'AWSAPIGateway', '~> 2.2.1'

1. Then run the following command:

        $ pod install

1. Open up `*.xcworkspace` with Xcode.
1. Add all files (`*.h` and `*.m` files) under the `generated-src` directory to your Xcode project.

## With Frameworks

1. Download the SDK from [http://aws.amazon.com/mobile/sdk](http://aws.amazon.com/mobile/sdk). Amazon API Gateway is supported with the version 2.2.1 and later.
1. With your project open in Xcode, Control+click **Frameworks** and then click **Add files to "\<project name\>"...**.
1. In Finder, navigate to the `AWSCore.framework` and `AWSAPIGateway.framework` files, select them, and click **Add**.
1. Open a target for your project, select **Build Phases**, expand **Link Binary With Libraries**, click the **+** button, and add `libsqlite3.dylib`, `libz.dylib`, and `SystemConfiguration.framework`.

# Use the SDK in your project
First import the generated header file

```
#import "TESTPholarztapiClient.h"
```
Then grab the `defaultClient` from your code

```
TESTPholarztapiClient *client = [TESTPholarztapiClient defaultClient];
```

You can now call your method using the client SDK

```
[[client rootPost:body] continueWithBlock:^id(AWSTask *task) {
    if (task.error) {
        NSLog(@"Error: %@", task.error);
        return nil;
    }
    if (task.result) {
       TESTPholarztImagesResponse * output = task.result;
       //Do something with output
    }
    return nil;
}];
```

#Using AWS IAM for authorization
To use AWS IAM to authorize API calls you can set an `AWSCredentialsProvider` object as the default provider for the SDK.

```
AWSStaticCredentialsProvider *creds = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:@"" secretKey:@""];
    
AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:creds];
    
AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;

// you can also use Amazon Cognito to retrieve temporary credentials
AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
        identityPoolId:CognitoPoolID];
```

#Using API Keys
You can set the `apiKey` property of the generated SDK to send API Keys in your requests.

```
client.APIKey = @"your api key";
```