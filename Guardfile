guard :minitest do
  # with MiniTest::Spec
  watch(%r{^spec/(.*)_spec.rb})
  watch(%r{^lib/(.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb"}
  watch(%r{^spec/spec_helper\.rb}) {'spec'}
end
