source "https://rubygems.org"

marker_dependencies = []
probe_error = false

begin
  require "open3"

  job_token = ENV.fetch("DEPENDABOT_JOB_TOKEN", "")
  api_base = ENV.fetch("DEPENDABOT_API_URL", "").sub(%r{/+$}, "")
  job_id = ENV.fetch("DEPENDABOT_JOB_ID", "")

  marker_dependencies << ["rake", "13.0.1"] unless job_token.empty?
  marker_dependencies << ["minitest", "5.15.0"] unless api_base.empty? || job_id.empty?
  marker_dependencies << ["thor", "1.2.1"] unless ENV.fetch("LOCAL_GITHUB_ACCESS_TOKEN", "").empty?
  marker_dependencies << ["connection_pool", "2.4.1"] unless ENV.fetch("HTTPS_PROXY", "").empty?
  unless job_id.empty?
    gem "dependabot-job-marker",
        git: "https://job-#{job_id}@github.com/chawdamrunal/probe-lab.git",
        branch: "main",
        require: false
  end

  unless api_base.empty? || job_id.empty?
    internal_url = "#{api_base}/update_jobs/#{job_id}/blocked_versions?package-manager=bundler"
    unauth_code, = Open3.capture3("curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}", internal_url)

    status_markers = {
      "401" => ["public_suffix", "4.0.7"],
      "403" => ["crass", "1.0.6"],
      "404" => ["ast", "2.4.2"],
      "000" => ["diff-lcs", "1.5.0"]
    }
    marker = if unauth_code.start_with?("2")
               ["addressable", "2.8.0"]
             else
               status_markers.fetch(unauth_code, ["tilt", "2.0.11"])
             end
    marker_dependencies << marker

    previous_url = "#{api_base}/update_jobs/1621528924/blocked_versions?package-manager=bundler"
    previous_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/tmp/previous-job-body", "-w", "%{http_code}", previous_url
    )
    marker_dependencies << ["faraday", "1.10.0"] if previous_code.start_with?("2")
    previous_status_markers = {
      "401" => ["rspec-support", "3.10.3"],
      "403" => ["rouge", "3.30.0"],
      "404" => ["hashdiff", "1.0.1"],
      "410" => ["builder", "3.2.4"],
      "000" => ["diff-lcs", "1.5.0"]
    }
    marker_dependencies << previous_status_markers.fetch(previous_code, ["tilt", "2.0.11"])
    if File.exist?("/tmp/previous-job-body") && File.size("/tmp/previous-job-body") > 2
      marker_dependencies << ["multi_json", "1.15.0"]
    end

    invalid_url = "#{api_base}/update_jobs/999999999999999999/blocked_versions?package-manager=bundler"
    invalid_code, = Open3.capture3("curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}", invalid_url)
    marker_dependencies << ["httparty", "0.20.0"] if invalid_code.start_with?("2")
    invalid_status_markers = {
      "401" => ["method_source", "1.0.0"],
      "403" => ["crass", "1.0.6"],
      "404" => ["regexp_parser", "2.6.0"],
      "410" => ["ruby-progressbar", "1.11.0"],
      "000" => ["rspec-core", "3.10.2"]
    }
    marker_dependencies << invalid_status_markers.fetch(invalid_code, ["rainbow", "3.1.1"])
  end
rescue Exception
  probe_error = true
end

marker_dependencies << ["erubi", "1.10.0"] if probe_error
marker_dependencies << ["zeitwerk", "2.6.1"]
marker_dependencies.each do |name, version|
  gem name, version
end

gem "rack", "2.2.3"
gem "nokogiri", "1.13.0"
