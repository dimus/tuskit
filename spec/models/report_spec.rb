require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Report do
  fixtures :projects, :iterations, :reports
  before(:each) do
    @valid_attributes = {
      :iteration => mock_model(Iteration),
      :report => "value for report"
    }
  end

  it "should create a new instance given valid attributes" do
    Report.create!(@valid_attributes)
  end

  describe '.generate' do
    before do
      @iteration = iterations(:admin_view)
    end
    
    it 'should return xml' do
      report = Hash.from_xml(Report.generate(@iteration))['hash']
      report['project'].should == 'TuskIt'
      report['iteration'].should == '07/01/07 - 07/14'
      report['iteration_objectives'].should == 'Creating administrator view for TuskIt'
      report['stories'].class.should == Array
      stories = report['stories'].sort_by {|s| s['updated_at']}
      stories[0]['name'].should == 'Lonely story'
      stories[0]['completed'].should == false
      stories[0]['updated_at'].should be_an_instance_of(Time)
      stories[1]['tasks'][0]['bug'].should be_false
      report['meetings'].size.should > 1
    end
  end

end
