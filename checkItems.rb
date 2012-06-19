require 'rubygems'
require 'mechanize'

QueryString = "http://www.google.co.jp/search?q=inposttitle:Check+site:azur256.blogspot.com&tbs=qdr:w1,sbd:1"

agent = Mechanize.new { |a|
	a.user_agent_alias = 'Mac Safari'
}

agent.get(QueryString) do |page|
	agent.page.links_with(:href => /\Ahttp:\/\/azur256.blogspot(.*)/).each do |link|
		link.click
		puts agent.page.at('title').inner_text, agent.page.uri
	end
end
