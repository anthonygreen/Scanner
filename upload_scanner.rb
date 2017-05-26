require 'aws-sdk'
s3 = Aws::S3::Resource.new
s3.bucket('scanner.tools.bbc.co.uk').object('index.html').upload_file('index.html')
s3.bucket('scanner.tools.bbc.co.uk').object('index.html').acl.put({ acl: "public-read" })

puts "Scanner has been uploaded to - http://scanner.tools.bbc.co.uk"
puts "Enjoy! ^__^ "
