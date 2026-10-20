# frozen_string_literal: true

module CategoryGroups
  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      groups = {}
      site.posts.docs.each do |post|
        paths = post.data["category_paths"] || [post.data["categories"] || []]
        paths.each do |parent, child, *_rest|
          next unless parent

          groups[parent] ||= []
          groups[parent] << child if child
        end
      end
      groups.transform_values! { |children| children.uniq.sort }
      site.data["category_groups"] = groups
      site.data["category_group_posts"] = {}
      pairs = groups.flat_map { |parent, children| children.map { |child| [parent, child] } }

      pairs.each do |parent, child|
        posts = site.posts.docs.select do |post|
          paths = post.data["category_paths"] || [post.data["categories"] || []]
          paths.any? { |path| path.first(2) == [parent, child] }
        end.sort.reverse
        site.data["category_group_posts"][parent] ||= {}
        site.data["category_group_posts"][parent][child] = posts
        path = ["categories", parent, child].map { |part| Jekyll::Utils.slugify(part) }.join("/")
        page = Jekyll::PageWithoutAFile.new(site, site.source, path, "index.html")
        page.data.merge!("layout" => "category", "title" => child, "category_parent" => parent, "posts" => posts)
        site.pages << page
      end
    end
  end
end
