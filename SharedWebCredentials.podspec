Pod::Spec.new do |s|
  s.name             = "SharedWebCredentials"
  s.version          = "0.1.0"
  s.summary          = "A Swift wrapper for the Shared Web Credentials API"
  s.description      = <<-DESC
                       The Shared Web Credentials API is used to store credentials
                       in the iCloud keychain to be shared among and between native iOS
                       apps and web apps on Safari for iOS and MacOS.
                       DESC
  s.homepage         = "https://github.com/MrAlek/SharedWebCredentials"
  s.license          = 'MIT'
  s.author           = { "Alek Åström" => "alek@iosnomad.com" }
  s.source           = { :git => "https://github.com/MrAlek/SharedWebCredentials.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MisterAlek'

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'Source/*.swift'
  s.frameworks = 'Security'

end
