class SubjectsController < ApplicationController
  before_action :private_access
  before_action :admin_access, except:[:index, :show]

  def index
    @paths = Path.for(current_user)
  end

  def show
    @subject = Subject.friendly.find(params[:id])
    @tab = @subject.challenges.count > 0 ? :challenges : :resources
    @tab = params[:tab].to_sym if params[:tab].present?
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)

    if @subject.save
      redirect_to @subject, notice: "El tema ha sido creado exitosamente"
    elsif
      render :new
    end
  end

  def edit
    @subject = Subject.friendly.find(params[:id])
  end

  def update
    @subject = Subject.friendly.find(params[:id])
    if @subject && @subject.update(subject_params)
      redirect_to @subject, notice: "El tema ha sido actualizado exitosamente"
    else
      render :edit
    end
  end

  def update_position
    @subject = Subject.update(params[:id], row_position: params[:position])
    head :ok
  end

  private
    def subject_params
      params.require(:subject).permit(:name, :description, :excerpt, :abstract,
        :time_estimate, :published, :visibility, :phase_id,
        course_phases_attributes: [:phase_id,:id,:_destroy]
        )
    end
end
