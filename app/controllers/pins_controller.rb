class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy, :upvote]
	before_action :authenticate_user!, except: [:index, :show]

	def index
		@pins = Pin.all.order("created_at DESC")
	end

	def new
		@pin = current_user.pins.build
	end 

	def show
		@comments = Comment.where(pin_id: @pin).order("created_at DESC")
	end

	def create
		@pin = current_user.pins.build(pin_params)

		if @pin.save
			redirect_to @pin, notice: "Successfully createed new Pin"
		else 
			render 'new'
		end
	end

	def edit
	  @pin = current_user.pins.find(params[:id])
		rescue ActiveRecord::RecordNotFound
    redirect_to pin_path, notice: "You cannot edit this pin."
	end

	def upvote 
		@pin.upvote_by current_user
		redirect_to pin_path
	end

	def update
		if @pin.update(pin_params)
			redirect_to @pin, notice: "Pin was Successfully updated!"
		else
			render 'edit'
		end
	end

	def destroy
		@pin.destroy
		redirect_to root_path, notice: "Pin was Successfully deleted!"
	end

	private

	def pin_params
		params.require(:pin).permit(:title, :description, :image)
	end

	def find_pin
		@pin = Pin.find(params[:id])
		rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: "Can't find Pin"
	end
end
