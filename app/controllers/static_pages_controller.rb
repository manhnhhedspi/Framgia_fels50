class StaticPagesController < ApplicationController
  def home
    @activities = current_user.activities.paginate page: params[:page],
      per_page: 20
  end
end
