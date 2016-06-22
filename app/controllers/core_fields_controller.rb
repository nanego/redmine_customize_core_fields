class CoreFieldsController < ApplicationController

  CORE_FIELDS_ALL = Tracker::CORE_FIELDS_ALL.freeze

  layout 'admin'

  before_filter :require_admin
  before_filter :find_core_field, :only => [:edit, :update]

  def index
    respond_to do |format|
      format.html {
        @fields = CORE_FIELDS_ALL
      }
    end
  end

  def edit
  end

  def update
    if @field.update_attributes(params[:core_field])
      flash[:notice] = l(:notice_successful_update)
      redirect_back_or_default edit_core_field_path(@field.identifier)
    else
      render :action => 'edit'
    end
  end

  private

  def find_core_field
    field_identifier = CORE_FIELDS_ALL.select{ |f| f==params[:id] }.first
    render_404 unless field_identifier.present?
    @field = CoreField.find_by_identifier(field_identifier)
    @field = CoreField.create!(:identifier => field_identifier) if @field.nil? && field_identifier.present?
  end
end
