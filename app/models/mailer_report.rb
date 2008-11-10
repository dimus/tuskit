require 'date_helpers'
class MailerReport < ActionMailer::Base
  extend DateHelpers

  # Sends an email with progress report if the report is sendable
  def send_report(iteration)
    return if !iteration.project.progress_reports || iteration.report_recipients.blank?
    recipients iteration.report_recipients.map {|r| r.email}.join(",")
    subject "Progress report for '#{iteration.project.name}' (#{MailerReport.dates_interval(iteration.start_date, iteration.end_date)})"
    from CUSTOM["mailer"]["email_from"]
    body :report => iteration
  end
end
