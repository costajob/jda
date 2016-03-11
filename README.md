## Table of Contents
* [Scope](#scope)
* [Vagrant](#vagrant)
* [JDA](#jda)
  * [Format](#format)
  * [Parsing](#parsing)
  * [Filtering](#filtering)
  * [Rake Task](#rake-task)
    * [Report](#report)
    * [Clean](#clean)
  * [Rewrite](#rewrite)

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
The libary accepts a path where JDA feeds are, thus allowing processing of multiple feeds at once.

### Filtering
The library assumes you are going to filter JDA data by one of the following:
* skus: just consider the provided list of SKUs
* store codes: filter only the specified store codes
* markdown flag: extract only the skus with markdown flag set to 'Y'

### Rake Task
The library uses Rake to provide a command line interface.

#### Report
Check JDA feeds into the /jda/finished folder, by filtering on specified skus, store IDs:
```ruby
bundle exec rake jda:report dir=/jda/finished skus=806564619,805254740 stores=20201,20401,21501
```
Check JDA feeds into the /jda default folder, by filtering by store ID and markdown flag:
```ruby
bundle exec rake jda:report stores=21400 md=Y
```
Check JDA feeds into the /jda default folder, by filtering by markdown flag and persisting report on the ./reports folder:
```ruby
bundle exec rake jda:report md=Y persist=Y
```
#### Clean
Clean the generated reports with the following command:
```ruby
bundle exec rake jda:clean
```

### Rewrite
I've rewritten this library after completing the [GO version](https://github.com/costajob/jda-go), since using a different programming language leads me to a better design than the original version (more on the GO version README).  
After the rewrite i also get some speed improvements, replacing threads (that in
ruby are limited by GIL) and using processes to grant parallelism.
