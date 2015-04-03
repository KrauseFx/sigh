require 'psst/psst'
require 'sigh/profile_analyser'

module Sigh
  class Manager
    def self.start
      psst = FastlaneCore::Psst::Client.new
      path = psst.fetch_provisioning_profile('net.sunapps.9', 'store').download

      raise "Something went wrong when downloading the provisioning profile" unless (path and File.exists?path)
      
      udid = Sigh::ProfileAnalyser.run(path)
      ENV["SIGH_UDID"] = udid if udid
      

      if Sigh.config[:filename]
        file_name = Sigh.config[:filename]
      else
        file_name = File.basename(path)
      end

      output = File.join(Sigh.config[:output_path].gsub("~", ENV["HOME"]), file_name)
      (FileUtils.mv(path, output) rescue nil) # in case it already exists

      install_profile(output) unless Sigh.config[:skip_install]

      puts output.green

      return File.expand_path(output)
    end

    def self.install_profile(profile)
      Helper.log.info "Installing provisioning profile..."
      profile_path = File.expand_path("~") + "/Library/MobileDevice/Provisioning Profiles/"
      profile_filename = ENV["SIGH_UDID"] + ".mobileprovision"
      destination = profile_path + profile_filename

      # copy to Xcode provisioning profile directory
      FileUtils.copy profile, destination

      if File.exists? destination
        Helper.log.info "Profile installed at \"#{destination}\""
      else
        raise "Failed installation of provisioning profile at location: #{destination}".red
      end
    end
  end
end