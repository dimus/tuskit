require File.dirname(__FILE__) + '/../../spec_helper'

describe "/features" do
  
  before(:each) do
    @feature = mock_model(Feature, :name => 'name', :description => 'description')
    @milestone = mock_model(Milestone)
    assigns[:feature] = @feature
    assigns[:milestone] = @milestone
  end

  it "should render features" do
    render "/features/new.html.haml"
    response.should be_success
  end
  
  it "should have form" do
    render "/features/new.html.haml"
    response.should have_tag("form[action=?][method=post]", feature_path(@feature)) do
      with_tag('input#feature_name[name=?]', "feature[name]")
      with_tag('input[type=?]', "submit")
    end
  end
  
  
end

