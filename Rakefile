require 'rake'
require 'httparty'

def version
  File.readlines('./VERSION').first.strip
end

def latest_hub_version
  taginfo        = JSON.parse(HTTParty.get("https://hub.docker.com/v2/repositories/teknolojikpanda/craneoperator/tags/").body)['results']
  tags = []
  taginfo.each do |tag|
    tags << tag['name']
  end
  (tags - ['latest']).sort.last
end

def next_version
  @next_version ||= get_next_version
end

task :tag do
  sh "docker tag -f teknolojikpanda/craneoperator:latest teknolojikpanda/craneoperator:#{next_version}"
  sh "docker tag -f teknolojikpanda/craneoperator:latest teknolojikpanda/docker-registry-ui:latest"
  sh "docker tag -f teknolojikpanda/craneoperator:latest teknolojikpanda/docker-registry-ui:#{next_version}"
end

desc "Push to Dockerhub"
task :push => :tag do
  sh "docker push teknolojikpanda/craneoperator:#{next_version}"
  sh "docker push teknolojikpanda/craneoperator:latest"
  sh "docker push teknolojikpanda/docker-registry-ui:#{next_version}"
  sh "docker push teknolojikpanda/docker-registry-ui:latest"
end

desc "Build Container"
task :build do
  sh "docker build -t teknolojikpanda/craneoperator:latest ."
end

task :default => [:build]


private

  def get_next_version
    base           = version
    taginfo        = JSON.parse(HTTParty.get("https://hub.docker.com/v2/repositories/teknolojikpanda/craneoperator/tags/").body)['results']
    tags = []
    taginfo.each do |tag|
      tags << tag['name']
    end
    current_base   = tags.grep(/#{base}/)
    return "#{base}.0" if current_base.empty?
    build = current_base.sort.last.split('.').last.to_i + 1
    return "#{base}.#{build}"
  end
