# Scanner

[Scanner](http://scanner.tools.bbc.co.uk/) is a tool to help find vpids with certain properties to be played on SMP.

It reads in multiple JSON feeds ([Trevor](https://confluence.dev.bbc.co.uk/display/~jamie.pitts@bbc.co.uk/Trevor+Example+Endpoints) and [IBL](https://inspector.ibl.api.bbci.co.uk/)) from across the BBC, takes the necessary info and prints to a pretty HTML file.

It's run daily providing fresh vpids for testing and development.

Once completed, Scanner is hosted on an S3 Bucket (which I [wrote a guide on how to do it.](https://confluence.dev.bbc.co.uk/display/podtest/How+to+host+a+static+website+in+S3+using+Cosmos))

## What do I need to view the results?

To see the results simply view it through your browser!

## What do I need to work on it?

To run it, you need Ruby installed on your local machine.

## What version of ruby?

```
ruby 2.3.1p112 (2016-04-26 revision 54768) [x86_64-darwin14]
```

## How do I run it?

First clone your own copy from this GitHub repo.

Once you've done that, simply run this command from your terminal -

```
ruby run_scanner.rb
```

Once that's finished you should see this file has been generated!

```
index.html
```

## How do I upload Scanner?

You need to be a member of the Media Playout team and have access to our S3 buckets on AWS.

Once you have permissions, you can simply copy **index.html** into the bucket **scanner.tools.bbc.co.uk**

When that's done, make sure **index.html** has public permissions (Right-click the file!) so people can view it!

## Is there a quicker way to upload!?

Yes there is!

If you have the AWS CLI installed with the following version

```
aws --version
aws-cli/1.11.90 Python/2.7.13 Darwin/14.5.0 botocore/1.5.53
```

And a valid aws config (that has permissions to the Media Playout buckets)

NOTE : This is just an example of what you'd need to configure, this is not a valid config!

```
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: ENTER
```

Then you can simply run the script **upload_scanner.rb**

```
ruby upload_scanner.rb
```

## Author

william.daly@bbc.co.uk with significant contributions from aimee.rivers@bbc.co.uk
