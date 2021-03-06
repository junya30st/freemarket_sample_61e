class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit]
  before_action :set_item, only: [:edit, :update]

  def index
    if user_signed_in?
      @items = Item.where.not(user_id: current_user.id).where(process: ["selling", "selltradeing"]).with_attached_images.order("created_at DESC").limit(10)
      @anothers = Item.where.not(user_id: current_user.id).where(process: ["selling", "selltradeing"]).with_attached_images.order("RAND()").limit(10)
    else
      @items = Item.where(process: ["selling", "selltradeing"]).with_attached_images.order("created_at DESC").limit(10)
      @anothers = Item.where(process: ["selling", "selltradeing"]).with_attached_images.order("RAND()").limit(10)
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(create_params)

    if @item.save
      redirect_to myitem_path(@item), notice: '商品の出品に成功しました'
    else
      flash.now[:alert] = '出品に失敗しました。必要事項を入力してください'
      render 'items/new'
    end
  end

  def show
    @item = Item.with_attached_images.find(params[:id])
    @others = Item.where.not(id: @item.id).where(user_id: @item.user_id).where(process: "selling").order("created_at DESC").limit(6)
      if user_signed_in?
        if @item.user_id == current_user.id
          redirect_to myitem_path(@item.id)
        end
      end
    session[:item_id] = params[:id]
  end

  def edit
    # 販売手数料の初期値
    @sales_fee = (@item.price.to_i*0.1).round
    # 販売利益の初期値
    @sales_profit = (@item.price.to_i*0.9).round
  end

  def update
    if @item.update(create_params) # updateが成功した場合
          if params[:delete_images].present?
              if Rails.env.production?
                params[:delete_images].split(",").each do |id|
                  ActiveStorage::Attachment.find(id).delete
                end
              else
                params[:delete_images].split(",").each do |id|
                  ActiveStorage::Attachment.find(id).delete
                end
              end
          end
          redirect_to myitem_path(@item)
    end
  end

  def searched
    if user_signed_in?
      @searched = Item.where.not(user_id: current_user.id).where(process: ["selling"]).where('name LIKE ? OR explanation LIKE ?', "%#{params[:text]}%", "%#{params[:text]}%")
    else
      @searched = Item.where(process: ["selling"]).where('name LIKE ? OR explanation LIKE ?', "%#{params[:text]}%", "%#{params[:text]}%")
    end
  end

  private

  def create_params
    params.require(:item).permit(:name, :explanation, :size, :price, :status, :delivery_fee, :delivery_origin, :delivery_type, :schedule, :category_id, :process, :brand_id, :user_id, images:[]).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

end
