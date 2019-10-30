# On-device authentication

## Overview

This sample demonstrates how to authenticate customers and validate their access to content when they sign in to a channel from their Roku devices, without requiring them to visit an external webpage. It shows how to use the [**ChannelStore node**](https://developer.roku.com/docs/references/scenegraph/control-nodes/channelstore.md) and [**Roku Web Service API**](https://developer.roku.com/docs/developer-program/roku-pay/roku-web-service.md) to check for an active Roku subscription, and how to use the [**roRegistrySection()**](https://developer.roku.com/docs/references/brightscript/components/roregistrysection) object and **ChannelStore node** to check for access tokens in the device registry and Roku Cloud, respectively. It then shows how to use the  [**ChannelStore node**](https://developer.roku.com/docs/references/scenegraph/control-nodes/channelstore.md) to create new Roku subscriptions. 

> You must incorporate this sample with the [products](https://developer.roku.com/docs/developer-program/roku-pay/monetization-in-developer-dashboard.md#adding-an-in-channel-product) and test users linked to your channel to observe its entire functionality. Your channel must also be enabled for [billing testing](https://developer.roku.com/docs/developer-program/roku-pay/testing-in-channel-purchasing.md).

## Components

### MainScene

The **MainScene** component validates whether the Roku account linked to the device has access to the sample channel's products, and it creates subscriptions through Roku pay for new purchases. The logic used in this component to verify access to content and create new Roku subscriptions follows the [On-Device Authentication](https://developer.roku.com/docs/developer-program/authentication/on-device-authentication.md#overview) document.  

> This sample uses hardcoded values for the access token and email validation flag instead of calls to authentication and entitlement server endpoints. You can replace these hardcoded values with calls to your endpoints to test your services with this sample channel.<br/><br/>In this case, you must change the **bs_const=sampleHardCodedValues** flag in the channel manifest to false, replace the sample API key ("devAPIKey") in the **MainScene.brs** file with your [developer API key](https://developer.roku.com/api/settings), and provide the URLs of your endpoints in the commented out **makeRequest()** methods (these include a field with a placeholder value such as "PUBLISHER...LINK GOES HERE").
  

### ChannelStoreProduct

The **ChannelStoreProduct** component provides the user interface for this sample channel.  It includes **LayoutGroup** nodes for displaying the names, codes, and prices for the mock products, and it includes a **Poster** node for marking products as "purchased" when they are bought.   

### RegTask

The **RegTask** component provides methods for reading, writing, and deleting this sample channel's registry section on a Roku device. 

### UriFetcher

The **UriFetcher** component provides a simple, non-blocking implementation of a basic download manager which is capable of multiple asynchronous URL requests implemented through a long-lived data task. This can be used in on-device authentication to make asynchronous calls to authentication and entitlement services, for example. 

## Installation

To run this sample, follow these steps:

1. Download and then extract the sample.

2. Expand the extracted **On-Device-Authentication-Sample** folder, and then compress the contents in to a ZIP file.

3.  Follow the steps in [Loading and Running Your Application](https://developer.roku.com/en-gb/docs/developer-program/getting-started/developer-setup.md#step-1-set-up-your-roku-device-to-enable-developer-settings) to enable developer mode on your device and sideload the ZIP file containing the sample onto it.  Optionally, you can launch the sample channel via the device UI. The sample channel is named **On Device Authentication Sample (dev)**.

4.  Click a product in the sample channel UI. If your Roku account does not have access to the selected product, the sample channel gets the email address of the Roku account linked to the device and signs you in. Complete the transaction for the product. The product will be marked as "Purchased" when you open the sample channel again.

    > This sample requires that you to use the [products](https://developer.roku.com/docs/developer-program/roku-pay/monetization-in-developer-dashboard.md#adding-an-in-channel-product) linked to your development channel.

    > Your device must be running Roku OS 9.2 or greater to ensure that the sample channel runs properly after cancelling mock purchases in the Roku Pay screen.

5.  To re-purchase products, replace the Api Key (devAPIKey) in the **MainScene.brs** file with your developer API key.  Press the Option (*) button on the Roku remote control to delete the sample channel's registry, and then go to the [Developer Dashboard](https://developer.roku.com/users) to void the product transactions associated with a test user linked to your channel.  


