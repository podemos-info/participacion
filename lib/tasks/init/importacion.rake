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

#def tag_code (tag, fichero, f_locale)
def tag_code (tag, fichero)
  #f_locale= f_locale? f_locale : "programa"
  #fichero = fichero["es"][f_locale]
  fichero = fichero["es"]["programa"]
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
          t.tag_list = [ tag_code(r[3], programa), tag_code(r[4], programa) ]
        end .save!(:validate => false)
        puts "ID: #{r[0].to_i} \t\t tag_list: '#{tag_code(r[3], programa)}', '#{tag_code(r[4], programa)}'"
      end
    end
  end
end

def tag_code2 (tag, fichero)
  #f_locale= f_locale? f_locale : "programa"
  fichero = fichero["es"]["ley"]
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
    f_locale="ley"
    fichero = YAML.load_file("config/locales/#{f_locale}.es.yml")
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

namespace :aportaciones do
  desc "[init] Cargar datos de aportaciones"
  task :importacion => :environment do
    Enquiry.delete_all(["id_enquiry_set = ?",4]) #dejo 4 por que es el id que se ha dado a la importación de aportaciones,
    #importantisimo asegurarse del ID correcto antes de ejecutar la orden de borrado
    xlsx = Roo::Spreadsheet.open("lib/tasks/init/aportaciones.xlsx")
    sheet = xlsx.sheet(0)
    headers = { ID: "ID", titulo: "titulo", descripcion: "resumen", tematica: "tematica", email: "email", persona1: "persona1",
      persona2: "persona2", persona3: "persona3", persona4: "persona4", persona5: "persona5", persona6: "persona6", persona7: "persona7",
      persona8: "persona18", persona9: "persona9", persona10: "persona10", persona11: "persona11", persona12: "persona12", persona13: "persona13",
      persona14: "persona14", persona15: "persona15", persona16: "persona16", persona17: "persona17", persona18: "persona18", persona19: "persona19"
      }
    #programa = YAML.load_file('config/locales/programa.es.yml')
    sheet.each(headers) do |r|
      if r[:ID].to_i > 0 && !r[:titulo].nil?
        Enquiry.new do |t|
          t.id = r[:ID].to_i
          t.title = r[:titulo][0..79]
          t.description = r[:descripcion].gsub("\n","<br>\n")
          t.summary = r[:descripcion].gsub("\n","<br>\n")
          t.author_id = 2
          t.tag_list = [ r[:tematica] ]
          t.id_enquiry_set =Rails.application.secrets.id_enquiry_set
        end .save!(:validate => false)
        puts "ID: #{r[:id].to_i} \t\t tag_list: '#{r[:tematica]}'"
      end
    end
  end
end
