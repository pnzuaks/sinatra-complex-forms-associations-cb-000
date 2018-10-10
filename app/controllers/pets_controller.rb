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
    @p = UpdatePetParams.new(params)

    owner_name = @p.owner_name
    should_create_owner = @p.should_create_owner?

    @pet = Pet.find(params[:id])
    @pet.update(params["pet"])

    if owner_name.empty?
      owner_name = Owner.find_by(id: @p.owner_id).name
      @pet.owner = Owner.find_by(id: @p.owner_id)

    elsif should_create_owner
        @pet.owner = Owner.create(name: owner_name)
    end

    @pet.save
    redirect to "pets/#{@pet.id}"
  end
end


class UpdatePetParams
  # attr_accessor :params

  def initialize(params)
    if params["pet"].nil?
      raise "Expected Pet to be defined"
    end
    if params["pet"]["name"].nil?
      raise "Expected Pet to have a name"
    end
    if params["owner"]["owner_id"].empty? && params["owner"]["name"].nil?
      raise "Expected Owner to have name and/or ID"
    end
    @params = params
  end

  def pet_name
    @params["pet"]["name"]
  end

  def owner_name
    @params["owner"]["name"]
  end

  def owner_id
    @params["owner"]["owner_id"].first
  end

  def should_create_owner?
    !@params["owner"]["name"].empty?
  end
end
