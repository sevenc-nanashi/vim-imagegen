# frozen_string_literal: true

require "rainbow"

def cache(key, &block)
  cache_path = File.join(Dir.home, ".cache", "vim-imagegen", "#{key}.cache")
  if File.exist?(cache_path)
    status = File.stat(cache_path)
    if Time.now - status.mtime < 60 * 60 * 24
      return Marshal.load(File.read(cache_path))
    end
  end

  result = block.call
  FileUtils.mkdir_p(File.dirname(cache_path))
  File.write(cache_path, Marshal.dump(result))

  result
end

def highlight_dockerfile(dockerfile)
  dockerfile
    .split("\n")
    .map do |line|
      case line
      when /\A#/
        Rainbow(line).gray
      when /\A[A-Z_]+/
        words = line.partition(" ")
        "#{Rainbow(words[0]).green}#{words[1]}#{words[2]}"
      else
        line
      end
    end
    .join("\n")
end

def fetch_tags(repo)
  name = repo.gsub("/", "--")
  path = File.join(Dir.home, ".cache", "vim-imagegen", name)

  unless File.exist?(path)
    system("git init #{path}", out: File::NULL)
    system(
      "git -C #{path} remote add origin https://github.com/#{repo}",
      out: File::NULL
    )
  end
  ls_remote = nil
  Dir.chdir(path) { ls_remote = `git ls-remote --tags origin` }
  ls_remote
    .lines
    .map { |line| line.split("\t").last.strip }
    .filter_map do |tag|
      tag.include?("^{}") ? nil : tag.delete_prefix("refs/tags/")
    end
end

def sort_by_version(tags)
  tags.sort_by { |tag| tag.delete_prefix("v").split(".").map(&:to_i) }.reverse
end

def resolve_version(tags, version, name)
  version = version.to_s
  tags =
    tags.filter do |tag|
      tag &&
        (
          tag.start_with?("v") || tag.match?(/\A\d+\.\d+\.\d+/) ||
            tag == "nightly"
        )
    end
  tags =
    tags.filter do |tag|
      unprefixed = tag.delete_prefix("v")
      unprefixed.start_with?(version) || unprefixed == version
    end if version

  tags.first ||
    raise("No version found for #{name} #{version || "(unspecified)"}")
end

def indent(string, prefix)
  string.gsub(/^/, prefix)
end
