require 'roo'
require 'yaml'

class String
  def to_slug
    #strip the string
    ret = I18n.transliterate self.strip.downcase
    #blow away apostrophes
    ret.gsub! /['`]/,""
    ret.gsub! "/","-"
    #replace all non alphanumeric, underscore or periods with underscore
    ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, ''
    #convert double underscores to single
    ret.gsub! /_+/,"_"
    #strip off leading/trailing underscore
    ret.gsub! /\A[_\.]+|[_\.]+\z/,""
    ret.downcase
  end
end

def tag_code (tag, fichero, f_locale)
  #f_locale= f_locale? f_locale : "programa"
  fichero = fichero["es"][f_locale]
  fichero.each do |clave, valor|
    tag = clave if valor == tag
  end
  tag
end


namespace :init do
  desc "[init] Cargar datos de medidas"
  task :importacion => :environment do
    Medida.delete_all
    xlsx = Roo::Spreadsheet.open("lib/tasks/init/Programa.xlsx")
    sheet = xlsx.sheet(0)
    headers = { ID: "ID", titulo: "Titulo de la medida", descripcion: "Literal", bloque: "Bloque", epigrafe: "Epígrafe", oficial: "oficial" }
    programa = YAML.load_file('config/locales/programa.es.yml')
    sheet.each do |r|
      if r[0].to_i > 0 && !r[1].nil?
        Medida.new do |t|
          t.id = r[0].to_i
          t.title = r[1]
          t.description = r[2].gsub("\n","<br>\n")
          t.author_id = 2
          t.tag_list = [ tag_code(r[3], programa,"programa"), tag_code(r[4], programa,"programa") ]
        end .save!(:validate => false)
        puts "ID: #{r[0].to_i} \t\t tag_list: '#{tag_code(r[3], programa,"programa")}', '#{tag_code(r[4], programa,"programa")}'"
      end
    end
  end
end

def tag_code2 (tag, fichero)
  #f_locale= f_locale? f_locale : "programa"
  fichero = fichero["es"]["ley_de_participacion"]
  fichero.each do |clave, valor|
    tag = clave if valor == tag
  end
  tag
end

namespace :ley do
  desc "[ley] Cargar datos de artículos de la Ley de participación"
  task :importacion => :environment do
    Law.delete_all
    xlsx = Roo::Spreadsheet.open("lib/tasks/init/Ley.xlsx")
    sheet = xlsx.sheet(0)
    headers = { ID: "ID", titulo: "Título del Artículo", descripcion: "Literal", bloque: "Bloque", epigrafe: "Epígrafe", oficial: "Oficial" }
    f_locale="ley_de_participacion"
    fichero = YAML.load_file("config/locales/${f_locale}.es.yml")
    sheet.each do |r|
      if r[0].to_i > 0 && !r[1].nil?
        Law.new do |t|
          t.id = r[0].to_i
          t.title = r[1]
          t.description = r[2].gsub("\n","<br>\n")
          t.author_id = 2
          #t.tag_list = [ tag_code(r[3], fichero,f_locale), tag_code(r[4], fichero,f_locale) ]
          t.tag_list = [ tag_code2(r[3], fichero), tag_code2(r[4], fichero) ]
        end .save!(:validate => false)
        #puts "ID: #{r[0].to_i} \t\t tag_list: '#{tag_code(r[3], fichero,f_locale)}', '#{tag_code(r[4], fichero,f_locale)}'"
        puts "ID: #{r[0].to_i} \t\t tag_list: '#{tag_code2(r[3], fichero)}', '#{tag_code2(r[4], fichero)}'"
      end
    end
  end
end
