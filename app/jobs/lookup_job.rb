# frozen_string_literal: true

class LookupJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Monument.all.each do |monument|
      search = '"' + monument.wlmid + '"'
      retimes = 0
      begin
        count = HTTParty.get("https://commons.wikimedia.org/w/api.php?action=query&list=search&srsearch=#{search}&srwhat=text&srnamespace=6&srlimit=1&format=json",
                             headers: { 'User-Agent' => 'WikiLovesMonumentsItaly MonumentsFinder/1.4 (https://github.com/ferdi2005/wikilovesmonuments; ferdi.traversa@gmail.com) using HTTParty Ruby Gem' },
                             uri_adapter: Addressable::URI).to_h
      rescue => e
        retimes += 1
        if retimes < 4
          puts "Retrying for ID: #{monument.id} - WLMID: #{monument.wlmid} - error: #{e}"
          retry
        else
          puts "Skipping ID: #{monument.id} - WLMID: #{monument.wlmid} - error: #{e}"
          next
        end
      end      
      totalhits = count.try(:[], 'query').try(:[], 'searchinfo').try(:[], 'totalhits')
      
      next if totalhits.nil?

      if totalhits > 0
        monument.update!(with_photos: true, photos_count: totalhits)
      elsif !monument.image.nil?
        monument.update!(with_photos: true, photos_count: totalhits)
      elsif !monument.commons.nil?
        begin
          count = HTTParty.get("https://commons.wikimedia.org/w/api.php", query: { action: :query, prop: :categoryinfo, titles: "Category:" + monument.commons ,format: :json },
                               headers: { 'User-Agent' => 'WikiLovesMonumentsItaly MonumentsFinder/1.4 (https://github.com/ferdi2005/wikilovesmonuments; ferdi.traversa@gmail.com) using HTTParty Ruby Gem' },
                               uri_adapter: Addressable::URI).to_h["query"]["pages"].values[0]["categoryinfo"]["files"]

          count > 0 ? with_photos = true : with_photos = false
          monument.update!(with_photos: with_photos, photos_count: totalhits)
        rescue => e
          monument.update!(with_photos: false, photos_count: totalhits)
        end  
      else
        monument.update!(with_photos: false, photos_count: totalhits)
      end
    end

    unless Nophoto.where(created_at: Date.today.to_datetime..DateTime.now).any?
      nophoto = Monument.where(with_photos: false).count

      Nophoto.create(count: nophoto, monuments: Monument.count, with_commons: Monument.where.not(commons: nil).count,
                     with_image: Monument.where.not(image: nil).count, nowlm: Monument.where(with_photos: true, photos_count: 0).count, cities: Monument.where(tree: false).pluck(:city).uniq.count, cities_with_trees: Monument.distinct.pluck(:city).count)

      regioni = ['Abruzzo',
                 'Basilicata',
                 'Calabria',
                 'Campania',
                 'Emilia-Romagna',
                 'Friuli-Venezia Giulia',
                 'Lazio',
                 'Liguria',
                 'Lombardia',
                 'Marche',
                 'Molise',
                 'Piemonte',
                 'Puglia',
                 'Sardegna',
                 'Sicilia',
                 'Toscana',
                 'Trentino-Alto Adige',
                 'Umbria',
                 "Valle d'Aosta",
                 'Veneto']

      regioni.each do |reg|
        nophoto = Monument.where(with_photos: false, regione: reg).count
        Nophoto.create(regione: reg, count: nophoto, monuments: Monument.where(regione: reg).count,
                       with_commons: Monument.where(regione: reg).where.not(commons: nil).count, with_image: Monument.where(regione: reg).where.not(image: nil).count, nowlm: Monument.where(regione: reg, with_photos: true, photos_count: 0).count, cities: Monument.where(regione: reg, tree: false).pluck(:city).uniq.count, cities_with_trees: Monument.where(regione: reg).pluck(:city).uniq.count)
      end
    end
  end
end