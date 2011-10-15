# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }


end


# guard 'rspec', :cli => cli_opts,
#                
#                :all_after_pass => false do
# 
#   watch('spec/spec_helper.rb')                       { 'spec' }
#   watch('app/controllers/application_controller.rb') { 'spec/controllers' }
# 
#   watch(%r{^spec/.+_spec\.rb})
#   watch(%r{^app/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
#   watch(%r{^lib/(.+)\.rb}) { |m| "spec/lib/#{m[1]}_spec.rb" }
# end
# 
