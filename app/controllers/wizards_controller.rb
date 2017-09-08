class WizardsController < ApplicationController
  before_action :load_user_wizard, except: %i[validate_step edit]

  def validate_step
    current_step = params[:current_step]

    @user_wizard = wizard_user_for_step(current_step)
    @user_wizard.user.attributes = user_wizard_params
    session[:user_attributes] = @user_wizard.user.attributes

    if @user_wizard.valid?
      next_step = wizard_user_next_step(current_step)
      unless next_step
        if @user_wizard.user.id.present?
          update && return
        else
          create && return
        end
      end
      redirect_to action: next_step
    else
      render current_step
    end
  end

  def create
    if @user_wizard.user.save
      session[:user_attributes] = nil
      redirect_to root_path, notice: 'User succesfully CREATED!'
    else
      redirect_to({ action: Wizard::User::STEPS.first }, alert: 'There were a problem when CREATING the user.')
    end
  end

  def update
    user = User.find @user_wizard.user.id
    user.update_attributes(@user_wizard.user.attributes)
    if user.save
      session[:user_attributes] = nil
      redirect_to root_path, notice: 'User succesfully UPDATED!'
    else
      redirect_to({ action: Wizard::User::STEPS.first }, alert: 'There were a problem when UPDATING the user.')
    end
  end

  def edit
    @user = User.find params[:id]
    session[:user_attributes] = @user.attributes
    # @user_wizard = Wizard::User::Base.new()
    redirect_to action: Wizard::User::STEPS.first
  end

  private

  def load_user_wizard
    @user_wizard = wizard_user_for_step(action_name)
  end

  def wizard_user_next_step(step)
    Wizard::User::STEPS[Wizard::User::STEPS.index(step) + 1]
  end

  def wizard_user_for_step(step)
    raise InvalidStep unless step.in?(Wizard::User::STEPS)

    "Wizard::User::#{step.camelize}".constantize.new(session[:user_attributes])
  end

  def user_wizard_params
    params.require(:user_wizard).permit(:email, :first_name, :last_name, :address_1, :address_2, :zip_code, :city, :country, :phone_number)
  end

  class InvalidStep < StandardError; end
end
