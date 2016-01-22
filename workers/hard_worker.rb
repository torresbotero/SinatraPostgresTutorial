require 'sidekiq'
require 'sidekiq-cron'
#require './config/environments' #database configuration
require 'sinatra/activerecord'
require './models/item'
require './models/group'
require './models/item_copy'
require "pg"

class CreateWorker
  include Sidekiq::Worker
  def perform(item)
  	@item_copy = ItemCopy.new
  	@item_copy.id = item["id"]
  	@item_copy.name = item["name"]
  	@item_copy.price = item["price"]
  	@item_copy.description = item["description"]
    if @item_copy.save
		"Item copied"
  	else
  		"Sorry, there was an error!"
  	end
  end
end

class UpdateWorker
  include Sidekiq::Worker
  def perform(item)
  	@item_copy = ItemCopy.find(item["id"])
  	@item_copy.name = item["name"]
  	@item_copy.price = item["price"]
  	@item_copy.description = item["description"]
    if @item_copy.save
		"Item copy updated"
  	else
  		"Sorry, there was an error!"
  	end
  end
end

class DeleteWorker
  include Sidekiq::Worker
  def perform(item)
  	@item_copy = ItemCopy.find(item["id"])
    if @item_copy.delete
		"Item copy deleted too"
	else
		"Sorry, there was an error!"
	end
  end
end

class CronWorker
  include Sidekiq::Worker
  def perform(*args)
    puts "Hola me estoy ejecutando"
    puts "Creando archivo"
    aFile = File.new("dump/" + Time.now.strftime("%Y-%m-%d-%H-%M-%S") + ".txt", "w+")
    if aFile
      @items = Item.where(:created_at => (Time.now - 120)..(Time.now))
      @groups = Group.where(:created_at => (Time.now - 120)..(Time.now))
      aFile.puts "Items:"
      aFile.puts @items.to_json
      aFile.puts "Groups:"
      aFile.puts @groups.to_json
  else
     puts "Unable to open file!"
  end
    aFile.close
  end
end

#Sidekiq::Cron::Job.create(name: 'Cron worker - every odd hour every even minute', cron: '0-59/2 1-23/2 * * *', class: 'CronWorker')

job = Sidekiq::Cron::Job.new(name: 'Cron worker - every odd hour every even minute', cron: '0-59/2 1-23/2 * * *', class: 'CronWorker')

if job.valid?
  job.save
else
  puts job.errors
end