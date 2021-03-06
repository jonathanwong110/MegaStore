class ProductsController < ApplicationController
  before_action :require_login
  
  def index
    if params[:q]
      @products = Product.where('title LIKE ?', "%" + params[:q] + "%")
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.find(params[:id])
    @cart = current_user.cart
    @review = Review.new
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    @product.user = current_user
    if @product.save
      current_user.products << @product
      redirect_to @product
      flash[:notice] = "*Product was created successfully!*"
    else
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
    redirect_if_not_owner
  end

  def update
    @product = Product.find(params[:id])
    redirect_if_not_owner
    if @product.update(product_params)
      redirect_to @product
      flash[:notice] = "*Product was updated successfully!*"
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    redirect_if_not_owner
    @product.destroy
    flash[:notice] = "*Product was deleted successfully!*"
    redirect_to products_path
  end

  def reviewed
    @products = Product.reviewed.all.uniq
  end

  private

  def product_params
    params.require(:product).permit(:title, :price, :description, :image, :category, :user_id, :q)
  end

  def redirect_if_not_owner
    if @product.user_id != current_user.id
      redirect_back(fallback_location: root_path)
    end
  end

end
