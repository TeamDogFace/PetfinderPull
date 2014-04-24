#!/bin/bash ruby

require 'mysql2'
require 'petfinder'
require 'yaml'
require './sql'

MAX_REQUESTS = 1000
MAX_RECORDS_PER_REQUEST = 2000


def read_last_zip_code
  IO.readlines('zips.txt')[-1].to_i
end

def read_credentials
  YAML.load_file('config.yml')
end

def get_petfinder_client
  creds = read_credentials
  Petfinder.configure do |c|
    c.api_key = creds["pf_api_key"]
    c.api_secret = creds["pf_api_secret"]
  end
  Petfinder::Client.new
end

config = read_credentials
# Create Database connection
con = Mysql2::Client.new(host: config["db_host"], username: config["db_username"], password: config["db_password"], database: config["database"])

# Create Petfinder client
#client = get_petfinder_client 

# Get token from Petfinder
#client.get_token

start_zip = read_last_zip_code
puts "Starting at zip code: #{start_zip}"

requests = 0
while requests < MAX_REQUESTS
  
end
#(start_zip.to_i..start_zip.to_i+MAX_REQUESTS).each do |zip|
 # zip = zip.to_s.rjust(5, '0')
  # Petfinder count is restricted to 100 records because of a bug...
 # pets = client.find_pet(zip, {animal: 'dog', count: '100'})
 # puts pets.count
#end

