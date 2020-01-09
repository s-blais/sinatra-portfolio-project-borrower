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
        erb :"/items/index"
    end

    get '/items/:id' do
        @item = Item.find_by_id(params[:id])
        @borrower = User.find_by_id(@item.borrower_id)
        erb :"/items/show"
    end

    get '/items/:id/edit' do
        # protect me
        @item = Item.find_by_id(params[:id])
        erb :"/items/edit"
    end

    patch '/items/:id' do
        if logged_in? # see users patch path for comment
            @item = Item.find_by_id(params[:id])
            if @item.user_id == current_user.id
                if @item.update(params.except(:_method))
                    redirect "/items/#{params[:id]}" #displays successful update(s) on show page
                else
                    redirect "/items/#{params[:id]}/edit" #reloads edit if unable to update
                end
            else
                redirect "/items/#{params[:id]}"
            end
        else
            redirect "/login"
        end
    end

    delete '/items/:id' do
        if logged_in?
            item = Item.find_by_id(params[:id])
            if item.user_id == current_user.id
                item.destroy
                redirect "/users/#{current_user.id}"
            else
                redirect "/items/#{item.id}"
            end
        else
            redirect "/login"
        end
    end


end
