class ReportMailer < ActionMailer::Base

def create(user, report)
  recipients user.email
  subject "Progress report for '#{report['project']}' project (#{report['iteration']})"
  from REPLY_EMAIL 
  body :recipient => user, :report => report
end

end
