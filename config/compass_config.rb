require 'lemonade' 
sass_dir = "app/stylesheets"
project_type = :stand_alone
images_dir = "public/images"    
http_images_path = "#{http_path}/images"
css_dir = "public/css" 
output_style = :compressed     
relative_assets  = false     
asset_host do |asset|
  "http://assets%d-notebook.designbreakdown.com" % (asset.hash % 4)
end