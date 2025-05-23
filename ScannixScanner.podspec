Pod::Spec.new do |spec|

  spec.name         = "ScannixScanner"
  spec.version      = "1.0.3"
  spec.summary      = "ScannixScanner for set up custom camera"
  spec.description  = "ScannixScanner for set up custom camera"
  spec.homepage     = "https://github.com/vishvanarola/ScannerScannix.git"

  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "Vishva Narola" => "vishvanarola02@gmail.com" }


  spec.ios.deployment_target = "15.6"

  spec.source       = { :git => "https://github.com/vishvanarola/ScannerScannix.git", :tag => spec.version }



  spec.source_files  = "ScannixScanner/**/*.{h,m}"
  spec.resource  = ['ScannixScanner/CustomCamera/*', 'ScannixScanner/SupportingFile/*', 'ScannixScanner/**/**/*.xib']

  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3']
  

  spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }



  #spec.dependency   'JSONKit', '~> 1.4'

end
