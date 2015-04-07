require 'plist'

module Sigh
  class Manager
    def run(options, args)
      Helper.log.info "Profiles"
      list_profiles
    end

    def self.start
      path = Sigh::DeveloperCenter.new.run

      return nil unless path

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

    def list_profiles
      profiles_path = File.expand_path("~") + "/Library/MobileDevice/Provisioning Profiles/"
      profiles = Dir[profiles_path + "*.mobileprovision"]
      now = DateTime.now
      profiles.each do |profile_path|
        profile_plist = Plist::parse_xml(`security cms -D -i '#{profile_path}'`)
        if now < profile_plist["ExpirationDate"]
          Helper.log.info(profile_plist["Name"].green)
        else
          Helper.log.info(profile_plist["Name"].red)
        end
      end
    end

  end
end