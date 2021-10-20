require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = doc.css("div.student-card")

    profiles = []

    students.each do |student|
      profile = {
        :name => student.css("h4.student-name").text,
        :location => student.css("p.student-location").text,
        :profile_url => student.css("a").attr("href").value
      }

      profiles << profile
    end
    profiles
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))

    social = doc.css("div.social-icon-container a")
    profile = {}
    
    social.each do |site|
      if site.attribute("href").value.include?("twitter")
        profile[:twitter] = site.attribute("href").value
      if site.attribute("href").value.include?("linkedin")
        profile[:linkedin] = site.attribute("href").value  
      if site.attribute("href").value.include?("twitter")
        profile[:github] = site.attribute("href").value
      else
        profile[:blog] = site.attribute("href").value
      end

    end

    profile[:profile_quote] = doc.css("div.profile-quote").text
    profile[:bio] = doc.css("div.description-holder p").text
    
    profile
  end

end

