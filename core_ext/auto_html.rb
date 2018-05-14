# https://github.com/dejan/auto_html/issues/176
# Compare to: https://github.com/dejan/auto_html/blob/0306203b91de28477f7459b3dfd50673621fb42e/lib/auto_html/filters/youtube.rb
#
# This allows listening to the play event.
#
module AutoHtml
  AutoHtml.add_filter(:youtube_with_js).with(:width => 420, :height => 315, :frameborder => 0, :wmode => nil, :autoplay => false, :hide_related => false) do |text, options|
    regex = /https?:\/\/(www.)?(youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/watch\?feature=player_embedded&v=)([A-Za-z0-9_-]*)(\&\S+)?(\?\S+)?/
    text.gsub(regex) do
      youtube_id = $3
      width = options[:width]
      height = options[:height]
      frameborder = options[:frameborder]
      wmode = options[:wmode]
      autoplay = options[:autoplay]
      hide_related = options[:hide_related]
      src = "//www.youtube.com/embed/#{youtube_id}"
      params = []
      params << "wmode=#{wmode}" if wmode
      params << "autoplay=1" if autoplay
      params << "rel=0" if hide_related
      src += "?#{params.join '&'}" unless params.empty?
      %{<div class="video youtube"><iframe width="#{width}" height="#{height}" src="#{src}?&enablejsapi=1" name="allowscriptaccess" value="always" frameborder="#{frameborder}" allowfullscreen></iframe></div>}
    end
  end
end