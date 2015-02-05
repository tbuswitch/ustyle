require "sass"
require "cgi"
require "base64"
require "chunky_png"

module Sass::Script::Functions

  def ustyle_version
    ::Sass::Script::String.new ::Ustyle::VERSION
  end
  declare :ustyle_version, []

  def inline_asset(source)
    assert_type source, :String
    if Ustyle.sprockets?
      ::Sass::Script::String.new "url(#{sprockets_context.asset_data_uri(source.value)})"
    else
      path = File.join(::Ustyle.assets_path, "images", source.value)
      asset_data_uri(path)
    end
  end
  declare :inline_asset, :args => [:source]

  def base64Encode(string)
    assert_type string, :String
    Sass::Script::String.new(Base64.strict_encode64(string.value))
  end
  declare :base64Encode, :args => [:string]

  def ustyle_image_path(source)
    ustyle_asset_path source, :image
  end
  declare :ustyle_image_path, :args => [:source]

  def ustyle_asset_path(source, type)
    url = if Ustyle.sprockets? && (context = sprockets_context)
      sprockets_context.send(:"#{type}_path", source.value)
    else
      if Ustyle.production?
        Ustyle.cloudfront_url(source.value)
      else
        path = File.join("/images", Ustyle.asset_digest(source.value))
        Sass::Script::String.new(path)
      end
    end

    # sass-only
    url ||= source.value.gsub('"', '')
    Sass::Script::String.new(url, :string)
  end
  declare :ustyle_asset_path, :args => [:source, :type]

  def rgba_inline(c, px = 5)
    color = ChunkyPNG::Color.rgba(c.red, c.green, c.blue, (c.alpha * 100 * 2.55).round)
    image = ChunkyPNG::Image.new(px.to_i, px.to_i, color)
    data  = Base64.encode64(image.to_blob).gsub("\n", "")

    Sass::Script::String.new("url('data:image/png;base64,#{data}')")
  end
  declare :rgba_inline, :args => [:c, :px]

  def list_files(path)
    return Sass::Script::List.new(
        Dir.glob(path.value).map! { |x| Sass::Script::String.new(x) },
        :comma
    )
  end
  declare :list_files, :args => [:path]

  protected

  def asset_data_uri(path)
    asset = File.open(path, "rb") {|io| io.read}
    data_uri_asset = Base64.strict_encode64(asset.to_s)
    url = "data:#{Ustyle.mime_type_for(path)};base64,#{CGI::escape(data_uri_asset)}"
    ::Sass::Script::String.new "url(#{url})"
  end

  def sprockets_context
    # Modern Rails way to get context:
    if options.key?(:sprockets)
      options[:sprockets][:context]
    # Sprockets-sass context:
    elsif options.key?(:custom) && options[:custom].key?(:sprockets_context)
      options[:custom][:sprockets_context]
    # Compatibility with sprockets pre 2.10.0:
    elsif (importer = options[:importer]) && importer.respond_to?(:context)
      importer.context
    end
  end
end