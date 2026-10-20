#!/usr/bin/env ruby
#
# Check for changed posts

require "open3"
require "pathname"

Jekyll::Hooks.register :posts, :post_init do |post|
  source = post.site.source
  path = Pathname.new(post.path).relative_path_from(Pathname.new(source)).to_s
  count, status = Open3.capture2("git", "rev-list", "--count", "HEAD", "--", path, :chdir => source)

  next unless status.success? && count.to_i > 1

  lastmod_date, status = Open3.capture2("git", "log", "-1", "--pretty=%ad", "--date=iso", "--", path, :chdir => source)
  post.data["last_modified_at"] = lastmod_date.strip if status.success?

end
