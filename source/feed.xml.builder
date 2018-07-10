xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title "Emily Platzer Makes Things"
  xml.subtitle "Lets get real crafty | All Earthling Technology is Our Culture"
  xml.id "https://www.emilyplatzer.com/"
  xml.link "href" => "https://www.emilyplatzer.com/"
  xml.link "href" => "https://www.emilyplatzer.com/feed.xml", "rel" => "self"
  xml.updated blog.articles.first.date.to_time.iso8601
  xml.author { xml.name "Emily Platzer" }

  blog.articles[0..5].each do |article|
    xml.entry do
      xml.title article.title
      xml.link "rel" => "alternate", "href" => article.url
      xml.id article.url
      xml.published article.date.to_time.iso8601
      xml.updated article.date.to_time.iso8601
      xml.author { xml.name "Emily Platzer" }
      xml.summary article.summary, "type" => "html"
      xml.content article.body, "type" => "html"
    end
  end
end
