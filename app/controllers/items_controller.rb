class ItemsController < ApplicationController

    get '/items/new' do
        erb :"/items/new"
    end

    post '/items' do
        item = Item.new(params)
        if item.save
            redirect "/items/#{item.id}"
        else
            redirect '/items/new'
        end
    end

    get '/items' do
        "erb :/items/index"
    end

    get '/items/:id' do
        @item = Item.find_by_id(params[:id])
        @borrower = User.find_by_id(@item.borrower_id)
        erb :"/items/show"
    end

    get '/items/:id/edit' do
        "erb :/items/edit, item # #{params[:id]}"
    end

    patch '/items/:id' do
        "processes update to item # #{params[:id]}"
    end


end
