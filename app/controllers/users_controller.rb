class UsersController < ApplicationController

    get '/users/new' do
        erb :"/users/new"
    end

    post '/users' do
        user = User.new(params)
        if user.save
            session[:user_id] = user.id
            redirect "/users/#{current_user.id}"
        else
            redirect '/'
        end
    end

    get '/login' do
        if logged_in?
            redirect "/users/#{current_user.id}"
        else
            erb :"/users/login"
        end
    end

    post '/login' do
        user = User.find_by(:username => params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect "/users/#{user.id}"
        else
            redirect '/login'
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
        end
        redirect '/login'
    end

    get '/users' do
        erb :"/users/index"
    end

    get '/users/:id' do
        if logged_in?
            @user = User.find_by_id(params[:id])
            erb :'/users/show'
        else
            redirect '/login'
        end
    end

    get '/users/:id/edit' do
        if logged_in?
            @user = User.find_by_id(params[:id])
            if @user.id == current_user.id
                erb :'/users/edit'
            else
                redirect "/users/#{params[:id]}"
            end
        else
            redirect '/login'
        end
    end

    patch '/users/:id' do
        if logged_in?
            @user = User.find_by_id(params[:id])
            if @user.id == current_user.id
                if @user.update(params.except(:_method))
                    redirect "/users/#{params[:id]}" #displays successful update(s) on show page
                else
                    redirect "/users/#{params[:id]}/edit" #reloads edit if unable to update
                end
            else
                redirect "/users/#{params[:id]}"
            end
        else
            redirect "/login"
        end
    end


end
