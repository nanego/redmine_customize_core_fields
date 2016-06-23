require 'spec_helper'

describe CoreFieldsHelper, type: :helper do

  it "should convert core field identifier to human friendly name" do
    field_name = core_field_title("done_ratio")
    expect(field_name).to eq "% Done"
  end

end
