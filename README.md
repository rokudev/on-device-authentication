# On-device-authentication

## Overview

This channel demonstrates how to implement on-device signups and sign-ins and grant customers access to content.  It shows how to use the [**ChannelStore node**](https://developer.roku.com/docs/references/scenegraph/control-nodes/channelstore.md) and [**Roku Web Service API**](https://developer.roku.com/docs/developer-program/roku-pay/roku-web-service.md) to check for an active Roku subscription, and how to use the [**roRegistrySection()**](https://developer.roku.com/docs/references/brightscript/components/roregistrysection) object and [**ChannelStore node**](https://developer.roku.com/docs/references/scenegraph/control-nodes/channelstore.md) to check for access tokens in the device registry and Roku Cloud, respectively. If the customer does not have an active subscription or their subscription cannot be validated (because it was purchased on a different platform), the sample shows how to use the Roku Pay [Request for Information (RFI) screen](https://developer.roku.com/docs/references/scenegraph/control-nodes/channelstore.md#getuserdata) to sign customers up for a new Roku subscription and sign them in to their existing subscription.

> You must incorporate this sample with the [products](https://developer.roku.com/docs/developer-program/roku-pay/quickstart/in-channel-products.md) and [test users](https://developer.roku.com/docs/developer-program/roku-pay/quickstart/test-users.md) linked to your channel to observe its entire functionality. Your channel must also be enabled for [billing testing](https://developer.roku.com/docs/developer-program/roku-pay/testing/billing-testing.md).

## Components

### MainScene

The **MainScene** component validates whether the Roku account linked to the device has a purchased a subscription for the sample channel. If a customer does not have a subscription or their subscription cannot be validated, it displays a landing screen page where customers can sign up for a subscription or sign in to their existing one. It monitors the **Sign Up** and **Sign In** buttons on the landing page to determine which RFI screen context ("signup" or "signin") to display when a button is pressed. For sign-ups, it creates a new subscriptions through Roku Pay; for sign-ins, it verifies the credentials and then grants access to content. The logic used in this component follows the [On-Device Authentication](https://developer.roku.com/docs/developer-program/authentication/on-device-authentication.md#overview) document to verify access to content and create new Roku subscriptions.

> This sample uses hardcoded values for the access token and email validation flag instead of calls to authentication and entitlement server endpoints. You can replace these hardcoded values with calls to your endpoints to test your services with this sample channel.<br/><br/>In this case, you must change the **bs_const=sampleHardCodedValues** flag in the channel manifest to false, replace the sample API key ("devAPIKey") in the **MainScene.brs** file with your [developer API key](https://developer.roku.com/api/settings), and provide the URLs of your endpoints in the commented out **makeRequest()** methods (these include a field with a placeholder value such as "PUBLISHER...LINK GOES HERE").

### SignUpScreen and SignInScreen

The **SignUpScreen** component is used to handle customers that click **Cancel** on the RFI screen when signing up for a subscription because they do not want to share their Roku customer account information with the channel. This component enables customers to manually enter their email address in a [StandardKeyboardDialog](https://developer.roku.com/docs/references/scenegraph/standard-dialog-framework-nodes/standard-keyboard-dialog.md); the entered email address is then displayed in a [TextEditBox](https://developer.roku.com/docs/references/scenegraph/widget-nodes/texteditbox.md). When the customer clicks **Sign Up**, the component returns the customer to the **MainScene** component to purchase a subscription. 

The **SignInScreen** component is used to collect the customer's email address and password after they click **Sign In** on the landing page. If the customer elects to share the email address associated with their Roku customer account information in the RFI screen, it pre-populates a [TextEditBox](https://developer.roku.com/docs/references/scenegraph/widget-nodes/texteditbox.md) with the customer's email address, and then displays a StandardKeyboardDialog for them to enter their password. The obfuscated password is displayed in a TextEditBox. If the customer clicks **Use different email** in the RFI screen, it displays a [StandardKeyboardDialog](https://developer.roku.com/docs/references/scenegraph/standard-dialog-framework-nodes/standard-keyboard-dialog.md) for them to enter their email address. When the customer clicks **Sign In**, the channel validates the credentials, and then displays the **ContentScreen** component, which displays video content that can be played. 

### ChannelStoreProduct

The **ChannelStoreProduct** component provides the user interface for this sample channel.  It includes **LayoutGroup** nodes for displaying the names, codes, and prices for the mock products, and it includes a **Poster** node for marking products as "purchased" when they are bought.   

### RegTask

The **RegTask** component provides methods for reading, writing, and deleting this sample channel's registry section on a Roku device.

### UriFetcher

The **UriFetcher** component provides a simple, non-blocking implementation of a basic download manager which is capable of multiple asynchronous URL requests implemented through a long-lived data task. This can be used in on-device authentication to make asynchronous calls to authentication and entitlement services, for example.

### Feed Parser

The **FeedParser** component retrieves the video content items used in this sample from an XML feed and then indexes and transforms them into ContentNodes so they can be displayed in BrightScript components. This process is useful if you do not have a web service for pulling content IDs from your feed (for example, your feed is maintained in an Amazon S3 bucket).

Specifically, the **FeedParser** component stores the stream URLs and other meta data for each content item in the feed in an array of associative arrays. The captured meta data includes a thumbnail image (used for the channel's poster and background images), description, and title. Importantly, it stores the items' GUIDs as content IDs and links them to the metadata. This enables you to pass the GUIDs in ECP cURL commands and deep link into the associated content. To display the content items on the screen, it formats the items into ContentNodes and then populates them in a RowItem.

### ContentScreen

The **ContentScreen** component displays and plays video content once a customer's subscription purchase is validated.

## Installation

To run this sample, follow these steps:

1. Download and then extract the sample.

2. Expand the extracted **On-Device-Authentication-Sample** folder, and then compress the contents in to a ZIP file.

3.  Follow the steps in [Loading and Running Your Application](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md#step-1-set-up-your-roku-device-to-enable-developer-settings) to enable developer mode on your device and sideload the ZIP file containing the sample onto it.  Optionally, you can launch the sample channel via the device UI. The sample channel is named **On Device Authentication Sample (dev)**.

4.  Upon launching the channel, click **Sign Up**. In the RFI screen, click **Continue** to grant the sample channel access to your Roku customer account information (or click **Cancel** to manually enter your information). 

5.  Click a product in the sample channel UI. Complete the transaction for the product. The product will be marked as "Purchased" when you open the sample channel again.

    > This sample requires that you to use the [in-channel products](https://developer.roku.com/products) linked to your development channel.

    > Your device must be running Roku OS 9.2 or greater to ensure that the sample channel runs properly after cancelling mock purchases in the Roku Pay screen.

6.  Access is granted to the channel's video catalog.

7.  To re-purchase products, replace the Api Key (devAPIKey) in the **MainScene.brs** file with your developer API key.  Press the Option (*) button on the Roku remote control to delete the sample channel's registry, and then go to the [Test Users](https://developer.roku.com/users) page in the Developer Dashboard to void the product transactions associated with a test user linked to your channel.  

8.  To test the sign-in flow upon launching the channel, click **Sign In**. In the RFI screen, click **Continue** to grant the sample channel access to the email address associated with your Roku customer account (or click **Use different email** to manually enter it). Enter a password, and then click **Sign In**.

