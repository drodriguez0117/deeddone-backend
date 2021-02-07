# frozen_string_literal: true

desc 'get local images, rename, copy to project folder and create seed inserts'
require 'fileutils'

task :get_images do
  puts 'start...'
  input_path = '/Users/dpr/Documents/deeddone/site/category_images/'
  categories = []

  Dir.glob(input_path + '*').sort.each do |f|
    category = File.basename(f, File.extname(f)).downcase
    image = File.basename(f)

    category = category.gsub!(' ', '_') if category.include? ' '

    if category.include? 'image_'
      category = category.sub('image_', '')
      image = category + File.extname(f)
    end

    if File.basename(f) != image
      #puts 'renaming file'
      File.rename(input_path + File.basename(f), input_path + image)
    end

    #puts 'create categories'
    front = category.index('_')
    back = category[0..front]
    category = category.sub(back, '')
    categories.push([category, image])

    #puts 'copy file to project'
    #dir = 'app/assets/categories/'
    dir = 'public/images/'
    Dir.mkdir(dir) unless File.exist?(dir)
    FileUtils.cp(input_path + image, dir + image)
  end

  #puts 'create seed file'
  seed_file = File.new('db/seeds/category_seeds.rb', 'w')
  seed_file.write("Category.destroy_all\n")

  categories.each do |category|
    seed_file.write("Category.create(name: '#{category[0]}', default_image_path: '#{category[1]}', is_active: true)\n")
  end

  seed_file.close

  puts 'end'
end