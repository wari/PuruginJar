#  -Purugin-Jar
#  -GNU LESSER GENERAL PUBLIC LICENSE- (No warranty included )

require 'net/http'
require 'open-uri'
require 'fileutils'
require 'zip/zip'
$now_time = Time.now

class PuruginJar

  def unzip_file (file, destination) 
  Zip::ZipFile.open(file) { |zip_file|
   zip_file.map { |f|
     f_path=File.join(destination, f.name)
     FileUtils.mkdir_p(File.dirname(f_path))
     zip_file.extract(f, f_path) unless File.exist?(f_path)
    }
   }
  end

  def dl_purugin
    Net::HTTP.start('nodeload.github.com')  {|site|
    resp = site.get('/enebo/Purugin/zipball/master')
    open("purugin.zip", "wb") { |file| file.write(resp.body) }}
    
    unzip_file "purugin.zip", "purugin"
    Dir.chdir("purugin")
    purugin = Dir.glob("*")
    Dir.chdir(purugin[0])
    system("mvn clean package")
		Dir.chdir("target")
		jarfiles = File.join("**", "*.jar")
		p = Dir.glob(jarfiles)[1]
		File.rename(p, "Purugin.jar")
		FileUtils.cp("Purugin.jar", "C:\\Github\\PuruginJar")
		Dir.chdir("..")
		Dir.chdir("..")
		Dir.chdir("..")
		FileUtils.rm_rf("purugin")
		File.delete("purugin.zip")
  end
    

  def check_for_updates
    file = File.open("body.txt")
    Net::HTTP.start("github.com") { |site|
    resp = site.get("/enebo/purugin")
    file.puts(resp.body)
    while Time.now == $now_time + 3600
      if  resp.body != file.readlines
        puts "========"
        puts "Update found. downloading."
        puts "========"
        File.delete("Purugin.jar") if File.exists? "Purugin.jar"
        dl_purugin
        system("git commit -m 'Updated Purugin.jar'")
        system("git push origin master")
        $now_time = Time.now
        file.puts(resp.body)
      else
        puts "========"
        puts "No update found."
        puts "========"
      end
    end
  end
  
  def init
	  puts "Script started.   Will begin checking for Purugin updates."
	  check_for_updates
	end
end
