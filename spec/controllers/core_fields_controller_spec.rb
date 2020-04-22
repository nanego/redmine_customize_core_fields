require "spec_helper"

describe CoreFieldsController, :type => :controller do

  fixtures :roles, :users

  before do
    @request.session[:user_id] = 1 # Admin
    User.current = User.find(1)
    Setting.default_language = 'en'
    @field = CoreField.find_or_create_by!(identifier: 'description', visible: true)
  end

  it "should update core_fields params" do
    expect(@field.visible).to be true
    expect(@field.roles).to be_empty

    put :update, params: {id: @field.identifier, core_field: {visible: '0', role_ids: ["1", "2"]}}
    expect(response).to redirect_to edit_core_field_path(@field)

    expect(@field.reload.visible).to be false
    expect(@field.roles.size).to be 2
  end

end
