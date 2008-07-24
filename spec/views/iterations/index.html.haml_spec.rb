require File.dirname(__FILE__) + '/../../spec_helper'

describe "/iterations" do
  fixtures :projects, :iterations, :users
  before(:each) do
    @project = projects(:tuskit)
    assigns[:project] = @project 
    assigns[:iterations] = @project.iterations
  end

  it "should render" do
    render "/iterations/index.html.haml"
    response.should be_success
  end

end
