Pod::Spec.new do |s|
  s.name          = 'FKSecureStore'
  s.version       = '1.0'
  s.platform      = :ios, '9.0'
  s.license       = { :type => 'MIT' }
  s.homepage      = 'https://github.com/idevelopers-in/FKSecureStore'
  s.authors       = { 'Firoz Khan' => 'f90khan@gmail.com' }
  s.summary       = 'A helper for keeping data secured in the keychain'
  s.source        = { :git => 'https://github.com/idevelopers-in/FKSecureStore.git', :tag => s.version }
  s.source_files  = 'FKSecureStore/*.{swift}'
  s.frameworks    = 'Security'
  s.requires_arc  = true
end
