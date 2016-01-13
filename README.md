## Table of Contents
* [Scope](#scope)
* [Vagrant](#vagrant)
* [JDA](#jda)
  * [Format](#format)
  * [Parsing](#parsing)
  * [Filtering](#filtering)
  * [Reporting](#reporting)
  * [Rake Task](#rake-task)

## Scope
The scope of this library is to provide utility funcions over the JDA stock files.

## Vagrant
The repo is based on a [vagrant](https://www.vagrantup.com/) box and provisioned by shell scripting.  
In order to have a working envirnment, be sure to be connected to the Internet and
do a `vagrant up`. 

##JDA
JDA is the file format used to represent stock data for the www.gucci.com site.

### Format
JDA file is a text files formatted by using comma separated values. The column are
the following:
| sku | store_code | store_name | on_hand | on_order | in_transit | department_code | department_name | vendor_code | style | color | size_code | description | price | markdown_flag | sale_date | target_stock_level | check_digit |

### Parsing
The standard Ruby's CSV library is used to parse the JDA files.  
Since JDA feeds are compressed in a tgz format, the Zlib and Tar libraries are used to inflate and untar the files (only the first TAR entry is taken)
The libary allows to specify multiple JDA files at once: each parsing happens inside a separated thread of execution to speed up the whole process.

Here's the main interface from `bundle console`:
```ruby
files = Dir[<where-JDA-unarchived-files-are>/*] # list all JDA files into a directory
parser = Jda::Parser::new(files: files) # create a new parser instance and start reading each file in a separate thread
```

### Filtering
The library assumes you are going to filter JDA data by one of the following:
* skus: just consider the provided list of SKUs
* store codes: filter only the specified store codes
* markdown flag: extract only the skus with markdown flag set to 'Y'

Here's the API:
```ruby
parser.filter!(skus: %w[800907768 800968214], stores: %w[21400 20102]) # extract only the specified two skus for the provided two store codes, keep in mind the parsed results are changed in place to spare memory
```

### Reporting
After you've filtered JDA results you might be interested in save them somewhere.
The report method just create a separate files into the *reports* folder for each of the parsed JDA file.

Here's how to generate report files:
```ruby
parser.report # create a report file by using threads to write to them
```

### Rake Task
In order to speed up JDA filtering and reporting a Rake task is available:
```ruby
# check JDA feeds into the /jda/finished folder, by filtering on specified skus, store IDs
rake jda:report root=/jda/finished skus=806564619,805254740 stores=20201,20401,21501
```
```ruby
# check JDA feeds into the /jda default folder, by filtering by markdown flag (if specified is considered true)
rake jda:report md_flag=Y
```
