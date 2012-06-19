require 'rubygems'
require 'mechanize'

def make_tweetbuzz_url(url)
	"<a href=\"http://tweetbuzz.jp/redirect?url=" + url + "\"><img src=\"http://tools.tweetbuzz.jp/imgcount?url=" + url + "\" /></a>"
end

def make_hatebu_url(url)
	"<a href=\"http://b.hatena.ne.jp/entry/" + url + "\"><img src=\"http://b.hatena.ne.jp/entry/image/" + url + "\" /></a>"
end

BlogTitle = "最近, 気になったこと...:"
QueryString = "http://www.google.co.jp/search?q=inposttitle:Check+site:azur256.blogspot.com&tbs=qdr:w1,sbd:1"

relation  = "<span style=\"font-weight:bold\">関連するエントリ</span>\n"
relation += "<br />\n\n"
relation += "<div id=\"feed\">\n"

agent = Mechanize.new { |a|
	a.user_agent_alias = 'Mac Safari'
}

agent.get(QueryString) do |page|
	agent.page.links_with(:href => /\Ahttp:\/\/azur256.blogspot(.*)/).each do |link|
		link.click
		title = agent.page.at('title').inner_text
		url   = agent.page.uri.to_s

		# titleの加工
		# String#deleteだと文字化けするのでString#gsubを使う
		title = title.gsub(BlogTitle, "").strip
		
		# link.clickだと blogger.jp に飛ばされるので blogger.com に置換
		url   = url.sub("blogspot.jp", "blogspot.com")

		relation += "<div id=\"feed_item\">"
		relation += "<a href=\"" + url + "\" target=\"_blank\">"
		relation += title + "</a></div>\n"
		relation += "<div id=\"feed_img\"> "
		relation += make_tweetbuzz_url(url) + " "
		relation += make_hatebu_url(url)
		relation += "<br /></div>\n\n"
	end
end
relation += "</div>\n"

puts relation
