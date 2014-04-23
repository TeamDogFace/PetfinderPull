#!/bin/bash ruby

require 'mysql2'
require 'petfinder'
require 'yaml'

MAX_REQUESTS = 1000
MAX_RECORDS_PER_REQUEST = 2000

# Read start zip code from file
start_zip = IO.readlines('zips.txt')[-1].to_i

if start_zip.to_i >= 99999
  puts "Finished"
  return
end

# Read in Petfinder API credentials
config = YAML.load_file('config.yml')

# Configure Petfinder API credentials
Petfinder.configure do |c|
  c.api_key = config["pf_api_key"]
  c.api_secret = config["pf_api_secret"]
end

# Create Database connection
con = Mysql2::Client.new(host: config["db_host"], username: config["db_username"], password: config["db_password"], database: config["database"])

# Create Petfinder client
client = Petfinder::Client.new

# Get token from Petfinder
client.get_token

puts "Starting at zip code: #{start_zip}"

#(start_zip.to_i..start_zip.to_i+999).each do |zip|
  zip = zip.to_s.rjust(5, '0')
  pets = client.find_pet(zip, {animal: 'dog', count: 2000})
  puts pets.count
#end

