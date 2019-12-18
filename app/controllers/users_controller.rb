class UsersController < ApplicationController

    get '/users/new' do
        erb :"/users/new"
    end

    post '/users' do
        user = User.new(params)
        if user.save
            session[:user_id] = user.id
            redirect '/'
        else
            redirect '/'
        end
    end

    get '/login' do
        "erb :/users/login"
    end

    get '/users' do
        "erb :/users/index"
    end

    get '/users/:id' do
        "erb :/users/show, user # #{params[:id]}"
    end

    get '/users/:id/edit' do
        "erb :/users/edit, user # #{params[:id]}"
    end

    patch '/users/:id' do
        "processes update to user # #{params[:id]}"
    end


end
