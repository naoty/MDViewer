require "rake/clean"

# Application info
APP_NAME      = "MDViewer"
SDK           = "iphoneos6.1"
WORKSPACE_DIR = File.expand_path("#{APP_NAME}.xcworkspace")
SCHEME        = "MDViewer"
CONFIGURATION = "Release"

# Build paths
BUILD_DIR     = File.expand_path("#{APP_NAME}.build")
APP_FILE      = File.expand_path("#{BUILD_DIR}/#{CONFIGURATION}-iphoneos/#{APP_NAME}.app")
DSYM_FILE     = File.expand_path("#{BUILD_DIR}/#{CONFIGURATION}-iphoneos/#{APP_NAME}.app.dSYM")
IPA_FILE      = File.expand_path("#{BUILD_DIR}/#{APP_NAME}.ipa")
DSYM_ZIP_FILE = File.expand_path("#{BUILD_DIR}/#{APP_NAME}.app.dSYM.zip")

# TestFlight info
API_TOKEN          = "ca8e23fd6c2ab05c729362941d0ee133_Nzc3NTA4MjAxMi0xMi0wOSAwOTozODoyNy40MjUzMjM"
TEAM_TOKEN         = "59840afb5ae1a641e1f3c246c27dbd3c_MTY0NDAyMjAxMi0xMi0wOSAwOTo0MTo0NC4zMzUzMDk"
NOTES              = "from rake task"
DISTRIBUTION_LISTS = "me"

CLEAN.include(BUILD_DIR)
CLOBBER.include(BUILD_DIR)

task :default => [:build]

desc "Build application"
task :build do |t|
  options = {
    sdk: SDK,
    workspace: WORKSPACE_DIR,
    scheme: SCHEME,
    configuration: CONFIGURATION
  }
  options = join_option(options: options, prefix: "-", seperator: " ")
  sh "xcodebuild #{options} OBJROOT=#{BUILD_DIR} SYMROOT=#{BUILD_DIR} clean build"
end

file IPA_FILE => [:build] do |t|
  options = {
    v: APP_FILE,
    o: IPA_FILE
  }
  options = join_option(options: options, prefix: "-", seperator: " ")
  sh "export CODESIGN_ALLOCATE=/usr/bin/codesign_allocate"
  sh "xcrun -sdk #{SDK} PackageApplication #{options}"
end

file DSYM_ZIP_FILE => [:build] do |t|
  sh "zip -ry #{DSYM_ZIP_FILE} #{DSYM_FILE}"
end

desc "Upload IPA file and dSYM file to TestFlight and notify testers"
task :testflight => [IPA_FILE, DSYM_ZIP_FILE] do |t|
  fields = {
    file: "@#{IPA_FILE}",
    dsym: "@#{DSYM_ZIP_FILE}",
    api_token: API_TOKEN,
    team_token: TEAM_TOKEN,
    notes: NOTES,
    notify: true,
    distribution_lists: DISTRIBUTION_LISTS
  }
  fields = join_option(options: fields, prefix: "-F ", seperator: "=")
  sh "curl http://testflightapp.com/api/builds.json #{fields}"
end

def join_option(options: {}, prefix: "", seperator: "")
  _options = options.map { |k, v| %(#{prefix}#{k}#{seperator}"#{v}") }
  _options = _options.join(" ")
end

