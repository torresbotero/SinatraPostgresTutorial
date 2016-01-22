require 'sidekiq'
require 'sidekiq-cron'
#require './config/environments' #database configuration
require 'sinatra/activerecord'
require './models/item'
require './models/group'
require "pg"


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