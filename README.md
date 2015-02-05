Berksshelf S3 API
==================
Use S3 as a bookshelf

## Configure S3
* Create a bucket with an FQDN-compatable name
* Configure DNS for your bucket
* Enable Static Website Hosting on your bucket
* Add a policy to your bucket to allow artifacts to be fetched by everyone:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::<YOUR.BUCKET.COM>/<PREFIX>/*"
    }
  ]
}
```

## TODO
* Proxy artifacts from S3. Allow bucket to be secured via IAM roles.
* Mirror [https://supermarket.chef.io/universe]

The MIT License (MIT)
=====================
_Copyright (C) 2015 John Manero <john.manero@gmail.com>_

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
