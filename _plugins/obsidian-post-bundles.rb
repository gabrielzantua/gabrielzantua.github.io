# frozen_string_literal: true

require "open3"
require "pathname"
require "time"
require "uri"

module ObsidianPostBundles
  IMAGE_EXTENSIONS = %w[.avif .bmp .gif .jpeg .jpg .png .svg .webp].freeze
  PROPERTY_LINE = /^\*\*(Title|Tags|Topics|Links):\*\*\s*(.*?)\s*$/i
  WIKI_LINK = /(?<!!)\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/

  class Asset < Jekyll::StaticFile
    def initialize(site, source, destination)
      super(site, File.dirname(source), "", File.basename(source))
      @relative_path = destination
    end
  end

  def self.install(site)
    root = site.in_source_dir("_posts")
    return unless File.directory?(root)

    bundles = Dir.children(root).map { |name| File.join(root, name) }
      .select { |path| File.directory?(path) && !File.symlink?(path) }
    return if bundles.empty?

    in_bundle = ->(path) { bundles.any? { |bundle| beneath?(path, bundle) } }
    site.static_files.reject! { |file| in_bundle.call(file.path) }
    site.posts.files.reject! { |file| in_bundle.call(file.path) }

    entries = []
    bundles.each do |bundle|
      markdown_files(bundle).each do |path|
        post = site.posts.docs.find { |doc| File.expand_path(doc.path) == path }
        unless post
          post = Jekyll::Document.new(path, :site => site, :collection => site.posts)
          post.read
          next unless site.unpublished || post.published?

          site.posts.docs << post
        end

        post.content, properties = strip_properties(post.content)
        source = File.read(path)
        front_matter = source.match(Jekyll::Document::YAML_FRONT_MATTER_REGEXP)&.[](1)
        has_front_matter_title = front_matter&.match?(/^title\s*:/)
        heading = first_heading(post.content)
        unless has_front_matter_title
          post.data["title"] = properties["Title"] || heading || post.data["title"]
        end
        post.content = strip_title_heading(post.content, heading) if heading && heading == post.data["title"]
        post.data["tags"] ||= property_tags(properties)
        has_front_matter_date = front_matter&.match?(/^date\s*:/)
        has_filename_date = Jekyll::Document::DATE_FILENAME_MATCHER.match?(post.relative_path)
        post.data["date"] = post_date(path, bundle, site) unless has_front_matter_date || has_filename_date
        post.data["media_subpath"] ||= media_subpath(bundle, path)
        post.data["bundle"] = File.basename(bundle)
        post.data["collection_index"] = File.dirname(path) == bundle && File.basename(path, File.extname(path)) == File.basename(bundle)
        post.content = convert_image_embeds(post.content, path, bundle)
        entries << [post, path, bundle]
      end

      image_files(bundle).each do |path|
        relative = Pathname.new(path).relative_path_from(Pathname.new(bundle)).to_s
        target = File.join("assets", "img", "obsidian", Jekyll::Utils.slugify(File.basename(bundle)), relative)
        site.static_files << Asset.new(site, path, target)
      end
    end

    link_index = wiki_link_index(entries)
    entries.each { |post, _path, _bundle| post.content = convert_wiki_links(post.content, link_index) }
    entries.each do |post, _path, bundle|
      next unless post.data["collection_index"]

      children = entries.select { |child, _child_path, child_bundle| child_bundle == bundle && !child.data["collection_index"] }
        .map(&:first).sort_by { |child| child.data["title"].to_s.downcase }
      post.content = "Explore #{post.data['title']}.\n\n" + children.map do |child|
        "- [#{child.data['title']}]({{site.baseurl}}#{child.url})"
      end.join("\n")
      post.data["note_count"] = children.length
    end
    site.posts.docs.uniq! { |post| post.path }
    site.posts.docs.sort!
  end

  def self.beneath?(path, root)
    File.expand_path(path).start_with?("#{File.expand_path(root)}#{File::SEPARATOR}")
  end
  private_class_method :beneath?

  def self.markdown_files(bundle)
    Dir.glob(File.join(bundle, "**", "*.{md,markdown}")).select do |path|
      File.file?(path) && !File.symlink?(path) && !File.basename(path).include?(".sync-conflict-") && beneath?(path, bundle)
    end.sort
  end
  private_class_method :markdown_files

  def self.image_files(bundle)
    Dir.glob(File.join(bundle, "**", "*")).select do |path|
      File.file?(path) && !File.symlink?(path) && IMAGE_EXTENSIONS.include?(File.extname(path).downcase)
    end.sort
  end
  private_class_method :image_files

  def self.strip_properties(content)
    lines = content.lines
    properties = {}
    index = 0
    while index < lines.length
      if lines[index].strip.empty?
        index += 1
      elsif match = lines[index].match(PROPERTY_LINE)
        properties[match[1]] = match[2]
        index += 1
      else
        break
      end
    end
    return [content, {}] if properties.empty? || lines[index]&.strip != "---"

    [lines[(index + 1)..].join, properties]
  end
  private_class_method :strip_properties

  def self.first_heading(content)
    content.match(/^#\s+(.+?)\s*#*\s*$/)&.[](1)&.strip
  end
  private_class_method :first_heading

  def self.strip_title_heading(content, heading)
    content.sub(/^#[ \t]+#{Regexp.escape(heading)}[ \t]*#*[ \t]*(?:\r?\n|\z)/, "")
  end
  private_class_method :strip_title_heading

  def self.property_tags(properties)
    values = [properties["Tags"], properties["Topics"]].compact.join(" ")
    tags = values.scan(/#([\p{Alnum}_-]+)/u).flatten
    tags.concat(values.scan(/\[\[([^\]|#]+)(?:\|[^\]]+)?\]\]/).flatten)
    tags.uniq
  end
  private_class_method :property_tags

  def self.post_date(path, bundle, site)
    folder_date = File.basename(bundle).match(/\A(\d{4}-\d{2}-\d{2})(?:-|\z)/)&.[](1)
    return Time.parse(folder_date) if folder_date

    relative_path = Pathname.new(path).relative_path_from(Pathname.new(site.source)).to_s
    output, status = Open3.capture2("git", "log", "--follow", "--format=%cI", "--reverse", "--", relative_path, :chdir => site.source)
    first_commit = output.lines.first&.strip
    return Time.iso8601(first_commit) if status.success? && first_commit && !first_commit.empty?

    File.mtime(path)
  rescue ArgumentError, Errno::ENOENT
    File.mtime(path)
  end
  private_class_method :post_date

  def self.media_subpath(bundle, path)
    relative_dir = Pathname.new(File.dirname(path)).relative_path_from(Pathname.new(bundle)).to_s
    parts = ["", "assets", "img", "obsidian", Jekyll::Utils.slugify(File.basename(bundle))]
    parts.concat(relative_dir.split(File::SEPARATOR)) unless relative_dir == "."
    parts.map { |part| URI::DEFAULT_PARSER.escape(part, /[^A-Za-z0-9\-._~]/) }.join("/")
  end
  private_class_method :media_subpath

  def self.convert_image_embeds(content, path, bundle)
    fenced = false
    content.each_line.map do |line|
      fenced = !fenced if line.match?(/^\s*(```|~~~)/)
      next line if fenced

      line.gsub(/!\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/) do |embed|
        name, alt = Regexp.last_match(1).strip, Regexp.last_match(2)&.strip
        image = resolve_image(name, path, bundle)
        next embed unless image

        relative = Pathname.new(image).relative_path_from(Pathname.new(File.dirname(path))).to_s
        encoded = relative.split(File::SEPARATOR).map { |part| URI::DEFAULT_PARSER.escape(part, /[^A-Za-z0-9\-._~]/) }.join("/")
        "![#{alt || File.basename(name)}](#{encoded})"
      end
    end.join
  end
  private_class_method :convert_image_embeds

  def self.resolve_image(name, path, bundle)
    decoded = URI::DEFAULT_PARSER.unescape(name)
    candidates = [File.expand_path(decoded, File.dirname(path)), File.expand_path(decoded, File.join(File.dirname(path), "images")), File.expand_path(decoded, File.join(bundle, "images"))]
    candidates.each { |candidate| return candidate if File.file?(candidate) && !File.symlink?(candidate) && beneath?(candidate, bundle) }

    matches = image_files(bundle).select { |candidate| File.basename(candidate) == File.basename(decoded) }
    matches.one? ? matches.first : nil
  end
  private_class_method :resolve_image

  def self.wiki_link_index(entries)
    candidates = Hash.new { |hash, key| hash[key] = [] }
    entries.each do |post, path, _bundle|
      [File.basename(path, ".md"), post.data["title"]].compact.each do |name|
        candidates[normalize_link(name)] << post
      end
    end
    candidates.transform_values { |posts| posts.uniq.one? ? posts.uniq.first : nil }
  end
  private_class_method :wiki_link_index

  def self.normalize_link(name)
    name.to_s.sub(/\.md\z/i, "").tr("\\", "/").downcase
  end
  private_class_method :normalize_link

  def self.convert_wiki_links(content, index)
    fenced = false
    content.each_line.map do |line|
      fenced = !fenced if line.match?(/^\s*(```|~~~)/)
      next line if fenced

      line.gsub(WIKI_LINK) do
        target, alias_text = Regexp.last_match(1).strip, Regexp.last_match(2)&.strip
        name, heading = target.split("#", 2)
        label = alias_text || heading || name.split("/").last
        post = index[normalize_link(name)] || index[normalize_link(File.basename(name))]
        next label unless post

        url = "{{site.baseurl}}#{post.url}"
        url += "##{Jekyll::Utils.slugify(heading)}" if heading
        "[#{label}](#{url})"
      end
    end.join
  end
  private_class_method :convert_wiki_links
end

Jekyll::Hooks.register :site, :post_read do |site|
  ObsidianPostBundles.install(site)
end
