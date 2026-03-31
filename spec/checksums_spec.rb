require 'spec_helper'

describe "Checksums" do
  def assert_checksum(expected, filename)
    filepath = Rails.root.join(filename)
    checksum = Digest::MD5.hexdigest(File.read(filepath))
    assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
  end

  it "checks core file new.js.erb checksum" do
    # This file is overridden by the plugin (app/views/issues/new.js.erb)
    # and must be kept in sync with the core version.
    # version 6.1.2 is OK
    assert_checksum %w"01e29fb257e5700dff94051420a4440a", "app/views/issues/new.js.erb"
  end
end
