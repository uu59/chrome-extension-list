# -- coding: utf-8

require "rubygems"
require "json"
require "erb"
require "ostruct"

unless ARGV.first
  puts "Usage: #{$0} ~/.config/chromium > result.html"
  exit
end

chromium_dir = ARGV.first

EXT_ICON_DEFAULT = <<ICON
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
YLJ8ypwAAAAASUVORK5CYII=
ICON

pref = File.join(chromium_dir, "/Default/Preferences")

items = []
json = JSON.parse(File.read(pref))
json["extensions"]["settings"].each{|id, content|
  icon = begin
    iconname = content["manifest"]["icons"].to_a.first.last
    icon = Dir.glob("#{chromium_dir}/Default/Extensions/#{content["path"]}/#{iconname}").first
    [File.read(icon)].pack('m')
  rescue
    EXT_ICON_DEFAULT
  end

  begin
    tmp = content["manifest"]["update_url"]
    if tmp && tmp.match(/google\.com/)
      link = "https://chrome.google.com/webstore/detail/#{id}"
    end
  rescue
  end

  begin
  items << OpenStruct.new({
    :name => content["manifest"]["name"],
    :desc => content["manifest"]["description"] || "",
    :icon => "data:image/png;base64," + icon.gsub(/\n/, ""),
    :link => link,
    :enable => content["state"] == 1,
  })
  rescue => ex
    ex
  end
}

items = items.sort_by{|ext| ext.name}
stats = {
  :all => items.length,
  :enabled => items.find_all{|ext| ext.enable }.length,
}

print ERB.new(DATA.read).result(binding)


__END__
<!DOCTYPE html>
<html i18n-values="dir:textdirection;" dir="ltr"><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta charset="utf-8">
<title i18n-content="title">Extensions</title>
<style>
html,body {
  font-size: small;
}
ul,li,dd,dl,dt,h2,p {
  margin:0;
  padding:0;
  list-style:none;
}

li {
  padding: 1ex;
}
p {
  padding: 1ex 0;
}
dt {
  display: block;
  text-align: center;
  float: left;
  width: 40px;
}
dd {
  float:left;
}
dd h2 {
  font-size:small;
}
dl:after {
  content: " ";
  height:0;
  clear:both;
  overflow:hidden;
  display:block;
}

.disabled {
  background-color: #e0e0e0;
}
.disabled h2:after {
  content: "(disabled)";
}
</style>
</head>
<body>
<h1>chrome extension list</h1>
<div id="stats">
<%=stats[:all]%> installed, <%=stats[:enabled]%> enabled.
</div>
<ul id="exts">
<% items.each{|ext| %>
<li class="<%=ext.enable ? '' : 'disabled'%>">
  <dl>
  <dt>
  <img src="<%=ext.icon%>" width="32" height="32" />
  </dt>
  <dd>
  <h2>
    <% if ext.link %>
      <a href="<%=ext.link%>"><%=ext.name%></a>
    <% else %>
      <%=ext.name%>
    <% end %>
  </h2>
  <p><%=ext.desc%></p>
  </dd>
</li>
<% } %>
</ul>
</body></html>
