require 'sidekiq'
#require './config/environments' #database configuration
require 'sinatra/activerecord'
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