require 'rack-flash'

class UsersController < ApplicationController
    use Rack::Flash

    get '/users/new' do
        if logged_in?
            flash[:message] = "You must log out before you can create a new Borrower user!<br>Use the log out button, below in the footer."
            redirect "/users/#{current_user.id}"
        else
            erb :"/users/new"
        end
    end

    post '/users' do
        if User.all.collect{|u| u.username}.include?(params[:username])
            flash[:message] = "Sorry, username #{params[:username]} is already in use, try again"
            redirect "/users/new"
        else
            # add password != "" test since requiring it in user.rb prevents any updates
            user = User.new(params)
            if user.save
                session[:user_id] = user.id
                flash[:message] = "Welcome to Borrower!<br>Add more profile info by clicking the 'edit #{current_user.username}' button below.<br>Add items that you'd like to make available to the Borrower community by clicking the 'add item' button."
                redirect "/users/#{current_user.id}"
            else
                redirect '/'
            end
        end
    end

    get '/login' do
        if logged_in?
            flash[:message] = "You are already logged in as #{current_user.username}.<br>To log in as a different user, first log out using the button below, in the footer."
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
        if logged_in?
            erb :"/users/index"
        else
            redirect '/login'
        end
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
        if logged_in? #is this even necessary? Is this test needed for anything post or patch? The subsequent "if" statement seems like it would bounce a non-logged-in patch attempt to the login page, because the else/redirect would fail that path's logged_in test, right?
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
