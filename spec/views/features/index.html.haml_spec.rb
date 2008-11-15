require File.dirname(__FILE__) + '/../../spec_helper'

describe "/features" do

  describe "with features" do

    before(:each) do
      @milestone = mock_model(Milestone, :deadline => Date.today , :name => 'name', :description => 'descr', :current? => true)
      @features = 4.times.map do |i| 
        mock_model(Feature, 
          :milestone => @milestone, 
          :name => 'name' + i.to_s, 
          :description => 'descr' + i.to_s, 
          :completion_date => (i.days.ago if i != 0), 
          :stories => [
            mock_model(Story, 
              :completed => [true,false].shuffle[0], 
              :completion_date => [1.days.ago,nil].shuffle[0], 
              :name => 'story', 
              :work_units_est => rand(9), 
              :active? => [true,false].shuffle[0],
              :iteration => mock_model(Iteration))
              ], 
          :last_story_date => i.days.ago)
      end
      @milestone.should_receive(:features_prepared).and_return(@features)
      @features.each do |f|
        f.should_receive(:stories_prepared).and_return f.stories
        #cheating a little, implementations is not repeating but called several times
        f.stories.each {|s| s.stub!(:implementations).and_return mock_model(Implementation, :size => 2)}
      end
      assigns[:milestone] = @milestone
      assigns[:features] = @features
    end

    it "should render" do
      render "/features/index.html.haml"
      response.should be_success
    end

  end

end

