# Actions relating to products
class ProductsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @products = current_user.products
  end

  def show
    @product = current_user.products.find(params[:id])
  end

  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      redirect_to products_path, :notice => 'Produkt er opprettet!'
    else
      render 'new'
    end
  end

  def edit
    @product = current_user.products.find(params[:id])
  end

  def update
    @product = current_user.products.find(params[:id])
    if @product.update(product_params)
      redirect_to products_path, :notice => 'Produkt Oppdatert'
    else
      render 'edit'
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    begin
      product.destroy
      flash[:notice] = 'Produkt slettet'
    rescue
      flash[:alert] = 'Kunne ikke slette produkt'
    end
    redirect_to product
  end

  def product_json
    product = current_user.products.find(params[:id])
    render :json => product
  end

  private

  def product_params
    params.require(:product).permit(:product_number, :description,
                                    :unit, :price, :vat)
  end
end
