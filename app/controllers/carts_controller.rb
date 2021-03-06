class CartsController < ApplicationController
  before_action :require_login

  def show
    @cart = Cart.find_by(user_id: current_user.id)
    @product = Product.find_by(user_id: current_user.id)
  end

  def add_to_cart
    carthash = params[:cart]
    product_id = carthash[:product_id]
    @product = Product.find(product_id)
    @cart = Cart.find(params[:id])
    @cart.products << @product
    if @cart.update(cart_params)
      @cart.save
      flash[:notice] = "The product was added successfully to the cart!"
    end
    redirect_to user_product_path(@product.user, @product)
  end

  def destroy
    @cart = Cart.find_by(user_id: current_user.id)
    @cart.products.destroy_all
    redirect_to carts_path
    flash[:notice] = "The cart was successfully cleared!"
  end

  private

  def cart_params
    params.require(:cart).permit(:user_id)
  end

end
