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
    should_create_owner = !owner_name.empty?

    @pet = Pet.find(params[:id])
    @pet.update(params["pet"])

    if owner_name.empty?
      owner_name = Owner.find_by(id: params["owner"]["owner_id"]).name
      @pet.owner = Owner.find_by(id: params["owner"]["owner_id"])

    elsif should_create_owner
        @pet.owner = Owner.create(name: owner_name)
    end

    @pet.save
    redirect to "pets/#{@pet.id}"
  end
end
