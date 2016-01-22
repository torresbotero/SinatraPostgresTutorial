require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/item'
require './models/group'
require './workers/hard_worker'
require 'sidekiq'
require 'sidekiq/api'
require 'redis'

#$redis = Redis.new

get '/' do
=begin
	stats = Sidekiq::Stats.new
    @failed = stats.failed
    @processed = stats.processed
    @messages = $redis.lrange('sinkiq-example-messages', 0, -1)
=end
	@items = Item.all.order(:name)
	erb :index
end

post '/items/new' do
	@item = Item.new(params[:item])
	@group = Group.find(params[:group_id])
	@item.group = @group
	if @item.save
		CreateWorker.perform_async(@item.attributes)
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end

post '/groups/new' do
	@group = Group.new(params[:group])
	if @group.save
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end

get '/add_item' do
	@groups = Group.all
	erb :add_item
end

get '/add_group' do
	erb :add_group
end

get '/items/delete/:id' do
  @item = Item.find(params[:id])
  @item.delete
  DeleteWorker.perform_async(@item.attributes)
  redirect '/'
end

get '/items/update/:id' do
  @item = Item.find(params[:id])
  @groups = Group.all
  erb :update_item
end

post '/items/update' do
	@item = Item.find(params[:id])
	@item.name = params[:name]
	@item.price = params[:price]
	@item.description = params[:description]
	@group = Group.find(params[:group_id])
	@item.group = @group
	if @item.save
		UpdateWorker.perform_async(@item.attributes)
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end

get '/groups/:id' do
	@group = Group.find(params[:id])
	@items = @group.items
	erb :show_group
end