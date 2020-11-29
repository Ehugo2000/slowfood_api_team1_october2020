class Api::OrdersController < ApplicationController
  before_action :authenticate_user!
  def create
    product = Product.find_by(id: params[:product_id])
    order = current_user.orders.create
    order.items.create(product: product)
    if order.persisted?

      render json: { message: 'Product was successfully added to your order',
                     order: order_as_json(order) }, status: 201
    else
      render json: { message: 'Something went wrong...' }, status: 422
    end
  end

  def update
    order = Order.find(params[:id])
    product = Product.find(params[:product_id])
    if new_item = order.items.create(product: product)
      render json: { message: 'Product was successfully added to your order',
                     order: order_as_json(order) }, status: 201
    else
      render json: { message: 'Something went wrong...' }, status: 422
    end
  end

  private

  def order_as_json(order)
    order_as_json = order.as_json
    order_as_json['items'] = order.product.as_json
    order_as_json
  end
end
