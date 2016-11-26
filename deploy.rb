#!/usr/bin/env ruby

s3_bucket = ARGV[0]

delete_successful = system("aws s3 rm s3://#{s3_bucket} --recursive --region us-west-2 --profile colin")
unless delete_successful
  abort "couldn't remove files from bucket"
end

html_files = Dir.glob("_site/**/*.html").select { |fn| File.file?(fn) }
html_files.each do |html_file|
  if html_file.eql? "_site/index.html"
    trimmed_path = "index.html"
  else
    trimmed_path = html_file.gsub("_site/", "").gsub(/\.html$/, "")
  end

  upload_successful = system("aws s3 cp #{html_file} s3://#{s3_bucket}/#{trimmed_path} --content-type text/html --profile colin --region us-west-2 --cache-control max-age=3600")
  unless upload_successful
    abort "couldn't upload #{html_file}"
  end
end

non_html_files = Dir.glob("_site/**/*").select { |fn| File.file?(fn) } - html_files
non_html_files.each do |non_html_file|
  trimmed_path = non_html_file.gsub("_site/", "")
  upload_successful = system("aws s3 cp #{non_html_file} s3://#{s3_bucket}/#{trimmed_path} --profile colin --region us-west-2 --cache-control max-age=3600")
  unless upload_successful
    abort "couldn't upload #{non_html_file}"
  end
end