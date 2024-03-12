
Dir[File.join(File.dirname(__FILE__), '*.rb')].each { |file| file }

File.dirname(__FILE__)

Dir[File.join(File.dirname(__FILE__), 'app/**','*rb')].each{ |file| p file }