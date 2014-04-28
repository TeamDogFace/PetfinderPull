#!/bin/bash ruby

require 'mysql2'
require 'petfinder'
require 'yaml'
require './sql'
require 'net/http'
require 'pp'

MAX_REQUESTS = 10
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

def insert_into_database(pets, con)
    number = 0
    while number < 100 do
        
        puts pets[number].id
        puts pets[number].age
        # url = "www.petfinder.com/petdetail/#{pets[number].id}"
        con.query("INSERT INTO dogs VALUES(0,#{pets[number].id},'www.petfinder.com//petdetail//#{pets[number].id}','#{pets[number].name}', '#{pets[number].age}','#{pets[number].sex}','#{pets[number].size}','#{pets[number].status}','blah','0000-00-00','0000-00-00','0000-00-00','2001-03-04')")
        #(sourceID, listingURL, name, age, sex, size, status, description, dateFound, dateMissing, lastUpdate, dateAdded)
        # {pets[number].description}#{pets[number].last_update} {pets[number].description}#{pets[number].last_update}
        currentPhotoNumber = 0
        Net::HTTP.start("photos.petfinder.com") do |http|
            currentPhotoNumber+=1
            
            begin
                #   @pet = client.get_random_pet({output: 'full', animal: 'dog'})
                
                next if pets[number].photos.nil?
                
                pets[number].photos.each do |p|
                    #[0]['__content__'] #.slice!("http://photos.petfinder.com")
                    
                    #      puts url[27..-1]
                    filename = "pf_#{pets[number].id}_#{currentPhotoNumber}.jpg"
                    response = http.get(p.large[27..-1])
                    open("#{filename}", "wb") do |file|
                        file.write(response.body)
                        path = Dir.pwd
                        
                        
                        #!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        # Detection needs to be implemented on the photos downloaded from petfinder before they are added to the database
                        #!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        dogidvalue = ""
                        dogid = con.query("select dogid from dogs where sourceid = #{pets[number].id}")
                        dogid.each do |row|
                            dogidvalue= row["dogid"]
                            puts row["dogid"]
                            # pretty_print(row)
                        
                        end
                        puts dogidvalue
                        con.query("INSERT INTO photos VALUES(0,'#{filename}','#{path}','jpg','#{dogidvalue}')")
                    
                    
                    
                    
                    end
                    
                    puts "Image #{currentPhotoNumber} downloaded"
                end
                rescue Exception => e
                puts e
                puts "Pet with ID #{pets[number].id} failed"
            end
            
        end
        number +=1
        
    end
end
    
    config = read_credentials
    # Create Database connection
    con = Mysql2::Client.new(host: config["db_host"], username: config["db_username"], password: config["db_password"], database: config["database"])
    
    # Create Petfinder client
    client = get_petfinder_client
    
    # Get token from Petfinder
    #client.get_token
    
    start_zip = read_last_zip_code
    puts "Starting at zip code: #{start_zip}"
    
    requests = 0
    offset = 0
    while requests < MAX_REQUESTS
        #CATCH 502 error message for offset
        
        #end
        #(start_zip.to_i..start_zip.to_i+MAX_REQUESTS).each do |zip|
        # zip = zip.to_s.rjust(5, '0')
        # Petfinder count is restricted to 100 records because of a bug...
        pets = client.find_pets('dog', 19350, {count: '100',lastOffset: offset})#, {animal: 'dog', count: '100'})
        insert_into_database(pets, con)
        puts pets.count
        offset += pets.count
        
        
          requests+=1
        
    
end
