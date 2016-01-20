require 'sinatra'
require 'sinatra/activerecord'
require './config/environments' #database configuration
require './models/item'

get '/' do
	@items = Item.all.order(:name)
	erb :index
end

post '/items/new' do
	@item = Item.new(params[:item])
	if @item.save
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end

get '/add_item' do
	erb :add_item
end

get '/items/delete/:id' do
  Item.find(params[:id]).delete
  redirect '/'
end

get '/items/update/:id' do
  @item = Item.find(params[:id])
  erb :update_item
end

post '/items/update' do
	@item = Item.find(params[:id])
	@item.name = params[:name]
	@item.price = params[:price]
	@item.description = params[:description]
	if @item.save
		redirect '/'
	else
		"Sorry, there was an error!"
	end
end