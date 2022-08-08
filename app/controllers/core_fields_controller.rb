class CoreFieldsController < ApplicationController

  CORE_FIELDS_ALL = Tracker::CORE_FIELDS_ALL + %w(status_id).freeze

  layout 'admin'

  before_action :require_admin
  before_action :find_core_field, :only => [:edit, :update]

  def index
    respond_to do |format|
      format.html {
        CORE_FIELDS_ALL.each_with_index do |field_identifier, index|
          field = CoreField.find_or_create_by!(:identifier => field_identifier)
          if field.position.blank?
            field.position = index + 1
            field.save
          end
        end
        @fields = CoreField.sorted
      }
    end
  end

  def edit
  end

  def update
    @field.safe_attributes = params[:core_field]
    if @field.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default edit_core_field_path(@field)
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
        format.js { head 422 }
      end
    end
  end

  private

  def find_core_field
    if params[:id].to_i.to_s == params[:id]
      @field = CoreField.find_by_id(params[:id])
      render_404 unless @field.present?
    else
      field_identifier = CORE_FIELDS_ALL.select { |f| f == params[:id] }.first
      render_404 unless field_identifier.present?
      @field = CoreField.find_by_identifier(field_identifier) if field_identifier.present?
      @field = CoreField.create!(:identifier => field_identifier) if @field.nil? && field_identifier.present?
    end
  end
end
