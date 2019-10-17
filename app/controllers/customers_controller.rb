class CustomersController < ApplicationController
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
  end

  private

  def customer_params
    params.require(:customer).permit(:username, :email, :password_digest)
  end

end
