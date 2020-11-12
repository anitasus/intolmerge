require 'open3'
require 'pry'
require 'tmpdir'
require 'tempfile'

##
# Parses the source file into the new format, in which the indentation and the rest of a line are stored on separate lines, saves the result in the destination file.
# Params:
# +source_path+:: expanded path to the source file
# +destination_path+:: expanded path to the destination file
def text_to_intolmerge(source_path, destination_path)
	File.open(destination_path, 'w+') do |destination_file|
		previous_tabs_count = 0
		
		File.readlines(source_path).each do |line|
			divided_line        = line.match(/\A(\t*)([^\t].*)\Z/)
			tabs                = divided_line[1]
			tabs_count          = tabs.length                                    
			delta_tabs_count    = tabs_count-previous_tabs_count
			prefix              = "t: #{delta_tabs_count}"
			suffix              = "c: #{divided_line[2]}"        
			previous_tabs_count = tabs_count
			
			destination_file.puts prefix
			destination_file.puts suffix
		end
	end
end

##
# Parses the source file into the original format and saves the result in the destination file.
# Params:
# +source_path+:: expanded path to the source file
# +destination_path+:: expanded path to the destination file
def intolmerge_to_text(source_path, destination_path)
	File.open(destination_path, 'w+') do |destination_file|
		previous_tabs_count = 0
		
		File.readlines(source_path).each_slice(2) do |prefix_line, suffix_line|
			if prefix_info = prefix_line.match(/\At: (\-?[0-9]+)\Z/)
				delta_tabs_count = prefix_info[1].to_i
				tabs_count       = previous_tabs_count+delta_tabs_count
				prefix           = "\t"*tabs_count
				
				
				if suffix_info = suffix_line.match(/\Ac: (.*)\Z/)
					suffix    = suffix_info[1]
					dest_line = prefix+suffix
					
					destination_file.puts dest_line
				else
					STDERR.puts "Invalid suffix format in #{source_path} is wrong"
					exit(1)
				end
				
				previous_tabs_count = tabs_count
					
			else
				STDERR.puts "Invalid prefix format in #{source_path}."
				exit(1)
			end
		end
	end
end

##
# Merges the left and the right, considering the base, sends the merged code to STDOUT.
# Params:
# +base+:: expanded path to a common predecessor of left and right, which left and right originated from
# +left+:: expanded path to the file that should be merged
# +right+:: expanded path to the file that should be merged
def merge(base, left, right)
	base_expanded_path  = File.expand_path(base)
	left_expanded_path  = File.expand_path(left)
	right_expanded_path = File.expand_path(right)
	
	[
		base_expanded_path,
		left_expanded_path,
		right_expanded_path,
	].each do |file|
		if !File.file?(file)
			STDERR.puts "Could not find #{file}."
			exit(1)
		end
	end
	
	Dir.mktmpdir do |dir|
		begin
			extention     = File.extname(base_expanded_path)
			parsed_base   = Tempfile.new(['parsed_base',   extention], dir)
			parsed_left   = Tempfile.new(['parsed_left',   extention], dir)
			parsed_right  = Tempfile.new(['parsed_right',  extention], dir)
			parsed_output = Tempfile.new(['parsed_output', extention], dir)
			output        = Tempfile.new(['output',        extention], dir)
			
			[
				parsed_base,
				parsed_left,
				parsed_right,
				output,
			].each do |temp_file|
				temp_file.close
			end
			
			text_to_intolmerge(base_expanded_path,  parsed_base.path)
			text_to_intolmerge(left_expanded_path,  parsed_left.path)
			text_to_intolmerge(right_expanded_path, parsed_right.path)
			
			Open3.popen3('diff3', '-m', '--', parsed_left.path, parsed_base.path, parsed_right.path) do |stdin, stdout, stderr, thread|
				parsed_output.write(stdout.read)
			end
			parsed_output.close
			
			intolmerge_to_text(parsed_output.path, output.path)
			
			File.readlines(output.path).each do |line|
				STDOUT.puts line
			end
		ensure
			[
				parsed_base,
				parsed_left,
				parsed_right,
				parsed_output,
				output,
			].each do |temp_file|
				temp_file.unlink
			end
		end
	end
end

merge(*ARGV)
