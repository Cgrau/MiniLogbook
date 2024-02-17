# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'MiniLogbook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SwiftLint', '0.54.0'
  pod 'RxSwift', '5.1.3'
  pod 'RxCocoa', '5.1.3'
  pod 'SnapKit', '5.6.0'

  # Pods for MiniLogbook

  target 'MiniLogbookTests' do
    inherit! :search_paths
    use_frameworks!
    pod 'SnapshotTesting', '1.9.0'
  end

  target 'MiniLogbookUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
end
