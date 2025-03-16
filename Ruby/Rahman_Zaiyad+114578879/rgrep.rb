filename = nil
pattern = nil
options = []
invalid_options = []

ARGV.each do |arg|
  if arg =~ /^-[pwvcm]$/
    options << arg
  elsif arg =~ /^-[^0-9pwvcm]$/
    invalid_options << arg
  end
end

non_option_args = ARGV.reject { |arg| arg.start_with? '-' }
filename = non_option_args[0] if non_option_args.length > 0
pattern = non_option_args[1] if non_option_args.length > 1

if !invalid_options.empty?
  puts("Invalid option")

elsif filename.nil? || pattern.nil?
  puts("Missing required arguments")
  exit
else
  options = ["-p"] if options.empty?
end

options = options.uniq

has_p = options.include?("-p")
has_w = options.include?("-w")
has_c = options.include?("-c")
has_m = options.include?("-m")
has_v = options.include?("-v")

incompatible = [has_p, has_w, has_v].count(true)

if incompatible > 1
  puts("Invalid combination of options")
elsif has_c && has_m
  puts("Invalid combination of options")
elsif has_m && has_v
  puts("Invalid combination of options")
else
  begin
    file_stuff = File.readlines(filename)

    if has_w
      regex = /\b#{Regexp.escape(pattern)}\b/
      matching = file_stuff.select {|line| line =~ regex}

      if has_c
        puts matching.length
      elsif has_m
        matching.each do |line|
          line.scan(regex) { |match| puts match }
        end
    else
      puts matching
    end

    elsif has_v
      regex = /#{pattern}/
      unmatched = file_stuff.reject {|line| line =~ regex}

      if has_c
        puts unmatched.length
    else
      puts unmatched
      end

  else
    regex = /#{pattern}/
    matching = file_stuff.select {|line| line =~ regex}
    if has_c
      puts matching.length
    elsif has_m
      matching.each do |line|
        line.scan(regex) { |match| puts match }
      end
    else
      puts matching
    end
    end
  rescue Errno::ENOENT
    puts("File not found : #{filename}")
  rescue RegexpError
    puts("Invalid regular expression: #{pattern}")
  end
end
