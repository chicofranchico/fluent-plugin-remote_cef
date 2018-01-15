# fluent-plugin-remote_cef_output

This code is based off of reproio's implementation of remote_syslog_output:
https://github.com/reproio/fluent-plugin-remote_syslog/

[![Build Status](https://travis-ci.org/chicofranchico/fluent-plugin-remote_cef.svg?branch=master)](https://travis-ci.org/chicofranchico/fluent-plugin-remote_cef)

[Fluentd](http://fluentd.org) plugin for outputing CEF (Common Event Format) towards an ArcSight appliance

## Requirements

| fluent-plugin-remote_cef | fluentd    | ruby   |
| -------------------      | ---------  | ------ |
| >= 1.0.0                 | >= v0.14.0 | >= 2.3 |

## Installation (not yet released)

```bash
 fluent-gem install fluent-plugin-remote_cef
```

## Usage

```
<match foo.bar>
  @type remote_cef
  host arcsight.acme.com
  port 514

  hostname fluentd.example.com # overrides the hostname on the log entries

  cef_version "CEF:0"
  device_vendor "Acme Inc."
  device_product "Linux"
  device_version 1.0
  signature_id 1000005
</match>
```

## CEF event output

This plugin uses the [CEF library](https://github.com/chicofranchico/cef) under the hood. For more details about the Common Event Format see [this link](https://kc.mcafee.com/resources/sites/MCAFEE/content/live/CORP_KNOWLEDGEBASE/78000/KB78712/en_US/CEF_White_Paper_20100722.pdf).

The definition of a CEF event is given as follows:

```
Version: CEF:0
Device vendor: Acme Inc.
Device product: Blue Print
Device version: 1.0
Signature id: Acme's determined numerical value (e.g., 1000005)
Name: The main part of the log (the message payload)
Severity: 0-10, with 10 being most severe. Map from available severity levels (e.g., TRACE, DEBUG, WARN, ERROR)
Extension: optional (depending on application)
```
