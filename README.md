## Table of Contents
* [Scope](#scope)
* [Vagrant](#vagrant)
* [JDA](#jda)
  * [Format](#format)
  * [Parsing](#parsing)
  * [Filtering](#filtering)

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


