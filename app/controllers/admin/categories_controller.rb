module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: [:edit, :update, :destroy]

    def index
      @categories = Category
        .left_joins(:items)
        .select("categories.*, COUNT(items.id) AS items_count")
        .group("categories.id")
        .order(:name)
    end

    def new
      @category = Category.new(active: true)
    end

    def create
      @category = Category.new(category_params)

      if @category.save
        redirect_to admin_categories_path,
                    notice: "Category created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path,
                    notice: "Category updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path,
                    notice: "Category deleted."
      else
        redirect_to admin_categories_path,
                    alert: "Cannot delete a category that has items."
      end
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(
        :name,
        :slug,
        :description,
        :active
      )
    end
  end
end