require 'rubygems'
      require 'zip'
Zip.continue_on_exists_proc = true
Zip.unicode_names = true
Zip.setup do |c|
    c.on_exists_proc = true
    c.continue_on_exists_proc = true
    c.unicode_names = true
  end