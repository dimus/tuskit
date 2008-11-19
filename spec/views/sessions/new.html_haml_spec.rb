require File.dirname(__FILE__) + '/../../spec_helper'

describe "/sessions/new" do

  it "should render new session template" do
    render "/sessions/new.html.haml"
    response.should be_success
  end

end
