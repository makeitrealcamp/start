class ChallengesController < ApplicationController
  before_action :private_access

  def new
    course = Course.find(params[:course_id])
    @challenge = course.challenges.new
  end

  def create
    @challenge = Challenge.create(challenge_params)
    redirect_to course_path(@challenge.course), notice: "El reto <strong>#{@challenge.name}</strong> ha sido creado"
  end

  def edit
    @challenge = Challenge.find(params[:id])
  end

  def update
    @challenge = Challenge.update(params[:id], challenge_params)
    redirect_to course_path(@challenge.course), notice: "El reto <strong>#{@challenge.name}</strong> ha sido actualizado"
  end

  def show
    @challenge = Challenge.find(params[:id])
    @solution = find_or_create_solution
  end

  private
    def find_or_create_solution
      find_solution || create_solution
    end

    def find_solution
      current_user.solutions.where(challenge_id: @challenge.id).take
    end

    def create_solution
      current_user.solutions.create(challenge: @challenge)
    end

    def challenge_params
      params.require(:challenge).permit(:course_id, :name, :instructions, :published, :evaluation, documents_attributes: [:id, :name, :content, :_destroy])
    end
end
