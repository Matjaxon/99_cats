class CatRentalRequestsController < ApplicationController

  def new
    @cat_rental_request = CatRentalRequest.new
    @cats = Cat.all
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_rental_request_url(@cat_rental_request)
    else
      @cats = Cats.all
      render :new
    end
  end

  def show
    @cat_rental_request = CatRentalRequest.find_by_id(params[:id])
  end

  def approve
    @cat_rental_request = CatRentalRequest.find_by_id(params[:id])
    @cat_rental_request.approve!
    @cat = @cat_rental_request.cat
    redirect_to cat_url(@cat)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find_by_id(params[:id])
    @cat_rental_request.deny!
    @cat = @cat_rental_request.cat
    redirect_to cat_url(@cat)
  end

  private

  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

end
