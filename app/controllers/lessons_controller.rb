class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :current_lesson, except: [:index, :create]
  before_action :correct_user, except: [:index, :create]

  def index
    @lessons = current_user.lessons
      .paginate page: params[:page], per_page: 10
  end

  def create
    category = Category.find params[:category_id]
    @lesson = category.lessons.build user: current_user
    if @lesson.save
      redirect_to @lesson
    else
      flash[:danger] = t "controllers.lessons.create.flash_danger"
      redirect_to root_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @lesson.update_attributes lesson_params
      @lesson.mark = @lesson.results.correct_answer.count
      @lesson.save
      redirect_to @lesson
    else
      render :edit
    end
  end

  private
  def current_lesson
    @lesson = Lesson.find params[:id]
  end

  def correct_user
    unless current_user == @lesson.user
      redirect_to root_path
    end
  end
  
  def lesson_params
    params.require(:lesson).permit results_attributes: [:id, :answer_id]
  end
end
