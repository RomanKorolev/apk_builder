require 'E:\SRC_NEW\_ruby\_common.rb'

#сделать генерацию 1.temp
#(добавлять только новые и не удалять старые)

puts "TODO: Default Target!!!"

require 'E:\SRC_NEW\_ruby\_common.rb'

class Dir
	def self.mkdir_p(dir)
		return if File::exist?(dir)
		parent_dir = File::dirname(dir)
		mkdir_p(parent_dir)
		mkdir(dir)
	end
end

=begin
Добавте при компиляции вашу либу javac -classpath objectbox-daocompat-1.0.0.jar:android.jar…
Дальше как обычно

-classpath AKA -cp ?????

lib:lib:lib
=end

$DO_CLEAR ||= true
$SDK_VERSION ||= '19.0.1' #NOT OK
#$SDK_VERSION = '23.0.1'
#$SDK_VERSION ||= '18.1.1' #BAD
#$SDK_VERSION ||= '20.0.0' #BAD
#$SDK_VERSION = 'show'
#$SDK_VERSION = '23.0.2' #NOT OK
#$SDK_VERSION ||= '19.1.0' #NOT OK
#$SDK_VERSION ||= '23.0.2' #NOT OK
#$SDK_VERSION ||= '22.0.1' #NOT OK

main_api_level = $SDK_VERSION.split(/\./)[0].to_i

if main_api_level > 19
	if main_api_level >= 23
		raise "Unsupported API Level"
	end
	puts "WARNING: Too Hi Android API Level (#{main_api_level}, but recomended 19), may be not working methods..."
end

=begin
18.0.1
18.1.0
18.1.1
19.0.0
19.0.1
19.0.2
19.0.3
19.1.0
20.0.0
21.1.2
22.0.1
23.0.1
23.0.2
=end

$ENV_KEYS = ['MAIN_CLASS', 'PACKAGE_PATH', 'PACKAGE']

$ENV_KEYS << 'JAVA_HOME'
$ENV_KEYS << 'ANDROID_HOME'
$ENV_KEYS << 'DEV_HOME'
$ENV_KEYS << 'AAPT_PATH'
$ENV_KEYS << 'DX_PATH'
$ENV_KEYS << 'ANDROID_JAR'
$ENV_KEYS << 'ADB'
$ENV_KEYS << 'SDK_VERSION'
ENV['SDK_VERSION'] = $SDK_VERSION

def subst_env_vars(s)
	s.gsub(/%([A-Z_]+)%/){
		env_var = $1
		val = ENV[env_var]
		raise "Can't FOUND ENV['#{env_var}']" if val.nil?
		val
	}
end

puts `adb start-server`

AndroidManifest = open('AndroidManifest.xml').read

main_activity = nil

activities = []
AndroidManifest.scan(%r{<activity(.*?android:name="([^"]+)".*?</activity>)}m){
	name, s = $2, $1
	is_main = false
	if s =~ /android.intent.action.MAIN/
		is_main = true  
		main_activity = name
	end
	activities << { :name => name, :is_main => is_main }
}

names = {}
AndroidManifest.scan(%r{<(activity|service|receiver).*?android:name="([^"]+)"}m){
	names[$1] = $2
}

main_activity ||= names['activity'] || names['service'] || names['receiver']

#if AndroidManifest =~ %r{<application.*?<(activity|service|receiver).*?android:name="([^"]+)"}m
if main_activity
	main_activity = main_activity[1 .. -1] if main_activity[0 .. 0] == "."
	main_activity = $1 if main_activity =~ /[.]([^.]+)$/
	ENV['MAIN_CLASS'] = main_activity
	puts "Main Activity name: '#{ENV['MAIN_CLASS']}'"
else
	raise "Can't match MAIN ACTIVITY name in manifest"
end

main_activity_java = main_activity + '.java'
puts "Main Activity JAVA filename: '#{main_activity_java}'"

puts "Search '#{main_activity_java}' in 'src/...'"

files = Dir['src/**/' + main_activity_java] + Dir['java/**/' + main_activity_java]
if files.size == 1
	puts "FOUND! in '#{files[0]}'"
else
	if files.size == 0
		raise "Can't found '#{main_activity_java}'"
	else
		puts "Found TOO MANY files:"
		files.each{ |f|
			puts f
		}
		raise "UPS!"
	end
end
main_java = files[0]
puts "main_java='#{main_java}'"

#main_java=src/com/example/mysecondapp/MainActivity.java
#на нужно      ^^^^^^^^^^^^^^^^^^^^^^^

$SRC_DIR = nil

if main_java =~ %r{^(src|java)/(.*?)/#{main_activity_java}$}i
	$SRC_DIR = $1
	$PACKAGE_PATH = $2
	ENV['PACKAGE_PATH'] = $2
	puts "PACKAGE_PATH=#{ENV['PACKAGE_PATH']}"
else
	raise "Can't match PACKAGE_PATH main activity file name '#{main_java}'"
end

if AndroidManifest =~ %r{<manifest.*?\s+package="([^"]+)"}m
	ENV['PACKAGE'] = $1
#	raise "PACKAGE name '#{ENV['PACKAGE']}' MUST be in LOWER CASE" if ENV['PACKAGE'] =~ /[^a-z0-9.]/
	puts "PACKAGE=#{ENV['PACKAGE']}"
else
	raise "Can't match PACKAGE name in manifest (attrib 'package')"
end



ENV['JAVA_HOME'] = "C:\\prog\\sdk\\jdk\\1.7"
ENV['JAVA_HOME'] = "Y:\\_WORK_SPACE\\Android\\_JDK\\jdk1.7.0_79"

ENV['ANDROID_HOME'] = "C:\\prog\\sdk\\android-studio\\sdk"

ENV['ANDROID_HOME'] = "E:\\SRC_NEW\\_Android\\_SDK"


ENV['DEV_HOME'] = Dir.getwd

ENV['AAPT_PATH'] = "%ANDROID_HOME%/build-tools/#{$SDK_VERSION}/aapt.exe"
ENV['DX_PATH'] = "%ANDROID_HOME%/build-tools/#{$SDK_VERSION}/dx.bat"
ENV['ANDROID_JAR'] = "%ANDROID_HOME%/platforms/android-#{$SDK_VERSION[0 .. 1]}/android.jar"
ENV['ADB'] = "%ANDROID_HOME%/platform-tools/adb.exe"


class File
	def self.exists(f)
		begin

puts "\7#{f}"
			open(f, 'rb'){ |h| }
puts "\7#{f}"
			return true
		rescue
		end
		return false
	end

end


if !File::exists(subst_env_vars(ENV['AAPT_PATH']))
	puts "Invalid $SDK_VERSION='#{$SDK_VERSION}'"
	puts "VALID Versions is:"
puts subst_env_vars("%ANDROID_HOME%/build-tools/*")
#	Dir[subst_env_vars("%ANDROID_HOME%/build-tools/*").gsub('\\', '/')].each{ |d|
#	Dir::scan()
#exit

	Dir[subst_env_vars("%ANDROID_HOME%/build-tools/*").gsub('\\', '/')].each{ |d|
		puts File::basename(d)
	}
	exit
end

if AndroidManifest =~ %r{<uses-sdk\s+.*?android:targetSdkVersion="([^"]+)"}m
	$targetSdkVersion = $1
else
	$targetSdkVersion = $SDK_VERSION.split(/[.]/)[0]
	puts "WARNING:\7Can't match targetSdkVersion in manifest\7 USING DEFAULT: '#{$targetSdkVersion}'"
end

ENV['targetSdkVersion'] = $targetSdkVersion
puts "AndroidManifest targetSdkVersion: #{$targetSdkVersion}"
n = $targetSdkVersion.size
if $SDK_VERSION[0 .. n - 1] != $targetSdkVersion
	raise "Invalid $SDK_VERSION (#{$SDK_VERSION}). is not matched to targetSdkVersion (#{$targetSdkVersion})"
end

raise "NOT Supported (Too high SDK API)" if $targetSdkVersion.to_i > 19


=begin
if AndroidManifest =~ %r{<uses-sdk\s+.*?android:targetSdkVersion="([^"]+)"}m
	$targetSdkVersion = $1
	ENV['targetSdkVersion'] = $targetSdkVersion
	puts "AndroidManifest targetSdkVersion: #{$targetSdkVersion}"
	n = $targetSdkVersion.size
	if $SDK_VERSION[0 .. n - 1] != $targetSdkVersion
		raise "Invalid $SDK_VERSION (#{$SDK_VERSION}). is not mathed to targetSdkVersion (#{$targetSdkVersion})"
	end
else
#	raise "Can't match targetSdkVersion in manifest"
	$SDK_VERSION ||= '19.0.1' #NOT OK
	puts "WARNING:\7Can't match targetSdkVersion in manifest\7 USING DEFAULT: '#{$SDK_VERSION}'"
end
=end


#set AAPT_PATH=%ANDROID_HOME%/build-tools/19.0.1/aapt.exe


puts "ENV variables ready"

open('set_env.bat', 'w'){ |h|
	$ENV_KEYS.each{ |k|
		puts "#{k}=#{ENV[k]}"
		h.puts "SET #{k}=#{ENV[k]}"
	}
}

def get_uts(ts = nil, format = "%03d")
	ts ||= Time.now
	ts.strftime('%H:%M:%S.') + (format % (ts.usec / 1000))
end

def abs_dt
	now = Time.now
	$started ||= now
	$prev_time ||= now
	s = sprintf("%0.3f, +%0.3f", now - $started, now - $prev_time)
	$prev_time = now
	s
end


def wrap_cmd(cmd_orig, comment = nil, called_from = nil, expected_text = nil, req_files = [])
	called_from ||= caller[0]
	cmd = subst_env_vars(cmd_orig)
	o = nil
#	begin
		s = Time.now
		$logger << "#{get_uts(s)} COMMENT: #{comment}" if comment
		$logger << "#{get_uts(s)} CMD original: '#{cmd_orig}'"
		$logger << "#{get_uts(s)} CMD: '#{cmd}', Time offset: #{abs_dt}"
		o = `#{cmd} 2>&1`
		exitstatus = $?.exitstatus
		e = Time.now
		dt = (e - s).to_f
		$logger << "#{get_uts(e)} exitstatus=#{exitstatus} DT=#{dt}sec, Time offset: #{abs_dt}"
		$logger << (("*" * 34) + " CMD OUTPUT " + (("*" * 34)))
		$logger.raw(o)
		$logger << "*" * 80
		if (exitstatus != 0)
			puts ""
			raise "Some thing wrong... exitstatus=#{exitstatus}"
			puts "\7\7\7" 
			sleep(10)
		end
		if expected_text
			if o =~ /#{expected_text}/
			else
				raise "NOT FOUND Expected Text: '#{expected_text}'"
				puts "\7\7\7" 
			end
		end
#	rescue
#	end
	req_files.each{ |f|
		if !File::exists?(f)
			$logger << "FATAL ERROR: REQUIRED FILE '#{f}' NOT EXIST"
			raise "FATAL ERROR: REQUIRED FILE '#{f}' NOT EXIST"
		else
			$logger << "REQUIRED FILE '#{f}' EXIST - OK"
		end
	}
	o
end

def create_bat(file, code)
	open(file, 'w'){ |h|
		h.puts code
	}
end

Dir::mkdir_p('logs')
log_name = Time.now.strftime('logs/BUILD_%Y-%m-%d_%H-%M-%S.log')

$logger = MyLoggerWithEcho.new(log_name)
$logger << "ENV list:"
$logger << "=" * 80
ENV.each{ |k, v|
	$logger << "#{k}=#{v}"
}
$logger << "=" * 80

#jar_libs = ([ENV['ANDROID_JAR']] + Dir['libs/*.jar']).join(';')
jar_libs = (Dir['libs/*.jar'] + [ENV['ANDROID_JAR']]).join(';')

create_bat('start.bat', "adb shell am start -n #{ENV['PACKAGE']}/#{ENV['PACKAGE']}.#{ENV['MAIN_CLASS']}")
create_bat('stop.bat', "adb shell am force-stop #{ENV['PACKAGE']}")
create_bat('logcat.bat', "adb logcat |grep #{ENV['PACKAGE']} | al")
create_bat('logcat_full.bat', "adb logcat | al")
create_bat('install.bat', %Q|@echo off
call set_env.bat
echo on
call adb install -r bin/%PACKAGE%.apk|)
create_bat('uninstall.bat', %Q|@echo off
call set_env.bat
echo on
call adb uninstall %PACKAGE%|)
create_bat('list_packages.bat', "@echo off && call set_env.bat && echo on && call adb shell pm list packages | sort")


create_bat('clear.bat', %Q|
:del *.keystore
del /s /f /q bin\\*.*
rmdir /s /q obj
rmdir /s /q bin
echo.
|)

create_bat('create_R.java.bat', %Q|@echo off && call set_env.bat && echo on
%AAPT_PATH% package -f -m -S %DEV_HOME%/res -J %DEV_HOME%/bin -M %DEV_HOME%/AndroidManifest.xml -I %ANDROID_JAR%|)
create_bat('compile_src.bat', %Q|@echo off && call set_env.bat && echo on
%JAVA_HOME%/bin/javac -Xlint:deprecation -d %DEV_HOME%/obj -cp #{jar_libs} -sourcepath %DEV_HOME%/src %DEV_HOME%/src/%PACKAGE_PATH%/*.java bin/%PACKAGE_PATH%/R.java|)
create_bat('create_apk.bat', %Q|@echo off && call set_env.bat && echo on
%AAPT_PATH% package -f -M %DEV_HOME%/AndroidManifest.xml -S %DEV_HOME%/res -I %ANDROID_JAR% -F %DEV_HOME%/bin/%PACKAGE%.unsigned.apk %DEV_HOME%/bin|)

create_bat('create_key.bat', %Q|@echo off && call set_env.bat && echo on
%JAVA_HOME%/bin/keytool -genkey -validity 10000 -dname "CN=AndroidDebug, O=Android, C=US" -keystore %DEV_HOME%/%KEY_FILE% -storepass android -keypass android -alias androiddebugkey -keyalg RSA -keysize 2048|)
create_bat('sign_apk.bat', %Q|@echo off && call set_env.bat && echo on
%JAVA_HOME%/bin/jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore %DEV_HOME%/%KEY_FILE% -storepass android -keypass android -signedjar %DEV_HOME%/bin/%PACKAGE%.apk %DEV_HOME%/bin/%PACKAGE%.unsigned.apk androiddebugkey|)

#exit

wrap_cmd('clear.bat') if $DO_CLEAR

def loadTemp(file = "_files.temp")
	return [] if !File::exist?(file)
	open(file){ |h| h.read }.split(/[\r\n]+/).uniq
end

def saveTemp(ara, file = "_files.temp")
	open(file, 'wb'){ |h|
		h.write ara.uniq.join("\r\n")
	}
end

def unix2dos(s)
	s.gsub(%r{/}, '\\')
end

files_ara = loadTemp
files_ara << unix2dos(File::join(Dir::getwd, "AndroidManifest.xml"))
files_ara << unix2dos(File::join(Dir::getwd, "_build_apk.rb"))
files_ara << unix2dos(File::join(Dir::getwd, "src", ENV['PACKAGE_PATH'], ENV['MAIN_CLASS'] + ".java"))

Dir['*.bat'].each{ |f|
	files_ara << unix2dos(File::join(Dir::getwd, f))
}

Dir[File::join(Dir::getwd, "src", ENV['PACKAGE_PATH'], "*.java")].each{ |f|
	files_ara << unix2dos(f)
}

saveTemp(files_ara)

Dir::mkdir_p('bin')
Dir::mkdir_p('obj')
Dir::mkdir_p('logs')



#wrap_cmd('%AAPT_PATH% package -f -m -S %DEV_HOME%/res -J %DEV_HOME%/src -M %DEV_HOME%/AndroidManifest.xml -I %ANDROID_JAR%', 'create R.java')
wrap_cmd('%AAPT_PATH% package -f -m -S %DEV_HOME%/res -J %DEV_HOME%/bin -M %DEV_HOME%/AndroidManifest.xml -I %ANDROID_JAR%', 'create R.java')

#wrap_cmd('%JAVA_HOME%/bin/javac -d %DEV_HOME%/obj -cp %ANDROID_JAR% -sourcepath %DEV_HOME%/src %DEV_HOME%/src/%PACKAGE_PATH%/*.java bin/%PACKAGE_PATH%/R.java', 'compile, convert class->dex and create APK')
wrap_cmd(%Q|%JAVA_HOME%/bin/javac -Xlint:deprecation -d %DEV_HOME%/obj -cp #{jar_libs} -sourcepath %DEV_HOME%/#{$SRC_DIR} %DEV_HOME%/#{$SRC_DIR}/%PACKAGE_PATH%/*.java bin/%PACKAGE_PATH%/R.java|, 'compile, convert class->dex and create APK')


wrap_cmd('%DX_PATH% --dex --output=%DEV_HOME%/bin/classes.dex %DEV_HOME%/obj', 'compile, convert class->dex and create APK', nil, nil, ['bin/classes.dex'])
#raise "FATAL ERROR: bin/classes.dex WASN'T BUILDED" if !File::exists?('bin/classes.dex')
wrap_cmd('%AAPT_PATH% package -f -M %DEV_HOME%/AndroidManifest.xml -S %DEV_HOME%/res -I %ANDROID_JAR% -F %DEV_HOME%/bin/%PACKAGE%.unsigned.apk %DEV_HOME%/bin', 'compile, convert class->dex and create APK')

ENV['KEY_FILE'] = 'AndroidTest.keystore'

wrap_cmd('%JAVA_HOME%/bin/keytool -genkey -validity 10000 -dname "CN=AndroidDebug, O=Android, C=US" -keystore %DEV_HOME%/%KEY_FILE% -storepass android -keypass android -alias androiddebugkey -keyalg RSA -keysize 2048', 'create key and signed APK') if !File::exists?(ENV['KEY_FILE'])
wrap_cmd('%JAVA_HOME%/bin/jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore %DEV_HOME%/%KEY_FILE% -storepass android -keypass android -signedjar %DEV_HOME%/bin/%PACKAGE%.apk %DEV_HOME%/bin/%PACKAGE%.unsigned.apk androiddebugkey', 'create key and signed APK')

#exit

#wrap_cmd('%ADB% uninstall %PACKAGE%', 'UNinstall APK on device')

o = `adb devices`
a = o.split(/[\r\n]+/)
a.shift
p a.size
if a.size == 0
	puts "Attach Android DEVICE!!!"
end

wrap_cmd('%ADB% devices', 'Get devices list', nil, 'EAAZB7108494\s+device')

#adb shell pm uninstall -k %PACKAGE%
#wrap_cmd('%ADB% uninstall %DEV_HOME%/bin/%PACKAGE%.apk', 'UNINSTALL APK from device')
#wrap_cmd('%ADB% uninstall %PACKAGE%', 'UNINSTALL APK from device')
#wrap_cmd('%ADB% shell pm uninstall %PACKAGE%', 'UNINSTALL APK from device')
wrap_cmd('%ADB% install -r %DEV_HOME%/bin/%PACKAGE%.apk', 'INSTALL APK on device', nil, 'Success')
wrap_cmd('%ADB% shell am start -n %PACKAGE%/%PACKAGE%.%MAIN_CLASS%', 'START APK on device')
