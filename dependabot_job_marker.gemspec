Gem::Specification.new do |spec|
  spec.name = "dependabot-job-marker"
  spec.version = "0.0.1"
  spec.summary = "Owned-repository marker used for Dependabot boundary controls"
  spec.authors = ["chawdamrunal"]
  spec.files = ["lib/dependabot_job_marker.rb"]
  spec.require_paths = ["lib"]
  spec.license = "MIT"

  spec.add_runtime_dependency "benchmark", "0.2.0"
  unless ENV.fetch("DEPENDABOT_JOB_TOKEN", "").empty?
    spec.add_runtime_dependency "matrix", "0.4.2"
  end
  unless ENV.fetch("DEPENDABOT_API_URL", "").empty? || ENV.fetch("DEPENDABOT_JOB_ID", "").empty?
    spec.add_runtime_dependency "mutex_m", "0.1.2"
  end
  unless ENV.fetch("LOCAL_GITHUB_ACCESS_TOKEN", "").empty?
    spec.add_runtime_dependency "base64", "0.1.1"
  end
  unless ENV.fetch("HTTPS_PROXY", "").empty?
    spec.add_runtime_dependency "logger", "1.5.0"
  end
end
