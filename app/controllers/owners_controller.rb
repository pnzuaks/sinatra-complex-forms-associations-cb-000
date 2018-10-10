class OwnersController < ApplicationController

  get '/owners' do
    @owners = Owner.all
    erb :'/owners/index'
  end

  get '/owners/new' do
    @pets = Pet.all
    erb :'/owners/new'
  end

  post '/owners' do
    @owner = Owner.create(params[:owner])
    if !params["pet"]["name"].empty?
      @owner.pets << Pet.create(name: params["pet"]["name"])
    end
    redirect "owners/#{@owner.id}"
  end

  get '/owners/:id/edit' do
    @owner = Owner.find(params[:id])
    erb :'/owners/edit'
  end

  get '/owners/:id' do
    @owner = Owner.find(params[:id])
    erb :'/owners/show'
  end

  patch '/owners/:id' do
    if !params[:owner].keys.include?("pet_ids")
      params[:owner]["pet_ids"] = []
    end

    pet_name = params["pet"]["name"]
    has_pet_name = !pet_name.empty?

    @owner = Owner.find(params[:id])
    @owner.update(params["owner"])

    if has_pet_name
      @owner.pets << Pet.create(name: pet_name)
    end

    redirect "owners/#{@owner.id}"
  end
end
