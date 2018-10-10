class PetsController < ApplicationController

  get '/pets' do
    @pets = Pet.all
    erb :'/pets/index'
  end

  get '/pets/new' do
    @owners = Owner.all
    erb :'/pets/new'
  end

  post '/pets' do
    @pet = Pet.create(params[:pet])
    puts params
    puts @pet.class
    if !params["owner"]["name"].empty?
      @pet.owner = Owner.create(name: params["owner"]["name"])
      @pet.save
    else
      params["owner"]["name"] = Owner.find_by(id: params["pet"]["owner_id"][0]).name
      @pet.owner = Owner.find_by(id: params["pet"]["owner_id"][0])
      @pet.save
    end
    redirect to "pets/#{@pet.id}"
  end

  get '/pets/:id/edit' do
    @pet = Pet.find(params[:id])
    erb :'/pets/edit'
  end

  get '/pets/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/show'
  end

  post '/pets/:id' do
    owner_name = params["owner"]["name"]
    has_owner_name = !owner_name.empty?

    @pet = Pet.find(params[:id])
    @pet.update(params["pet"])

    puts params

      if owner_name.empty?
    # if !params[:pet].keys.include?("owner_id")
      # params["owner"]["owner_id"] = []
      # owner_name = Owner.find_by(id: params["owner"]["owner_id"]).name
      params["owner"]["name"] = Owner.find_by(id: params["pet"]["owner_id"][0]).name
      @pet.owner = Owner.find_by(id: params["owner"]["owner_id"])
      @pet.save

      elsif has_owner_name
        @pet.owner = Owner.create(name: owner_name)
        @pet.save
      end
      puts owner_name
    puts params
    redirect to "pets/#{@pet.id}"
  end
end
