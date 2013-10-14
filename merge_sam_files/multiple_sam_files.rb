#!/usr/bin/env ruby
require 'optparse'
require "fileutils"
#require 'logger'

#$logger = Logger.new(STDERR)
#OptionParser

def setup_options(args)
	options = {:output_dir => "./merged_sam",
			   :sample_name => ""}

	opt_parser = OptionParser.new do |opts|
		opts.banner = "Usage: multiple_sam_files.rb [options] sam_file*"
		opts.separator ""
	
		opts.on("-o", "--output_dir [DIR]", :REQUIRED, String, "Root directory for the results (default: ./merged_sam)" ) do |o|
			options[:output_dir] = o
		end
	
		opts.on("-n", "--sample_name", :REQUIRED, String, "Sample name of the merged SAM file" ) do |n|
			options[:sample_name] = n
		end
	
		opts.on("-d", "--debug", "Run in debug mode") do |d|
			options[:log_level] = "debug"
		end
	
		opts.on_tail("-h", "--help", "Show this message") do
			puts opts
			exit
		end
	end
	
	args = ["-s"] if args.length == 0
	opt_parser.parse!(args)
	raise "Please specify sam_files" if args.length == 0
	options
end


#gives you the last seq number of the file
def get_last_seq_num(filename)
	seq_num = []
	f = File.open(filename)
	f.each_line do |line|
		puts line
		seq_num << line.split("seq.")[1].to_i
	end
	seq_num.last
end
#gives you sam files with updated seq numbers	
def seq_new_num(filelist)
	initial_num = 0
	for i in 0 .. filelist.size-1
		if i == 0
			initial_num = get_last_seq_num(filelist[i]) 
			i += 1
		else	
			File.open(filelist[i]) do |f|
				out = ""
				last_sequence_name = ""
				initial_num += 1
				f.each do |line|
					num = line.split("seq.")[1].to_i  
					num_s = num
					last_sequence_name = num_s if last_sequence_name == ""
					if last_sequence_name != num_s
						initial_num += 1
						last_sequence_name = num_s
					end
					puts line.gsub(num_s.to_s, initial_num.to_s)
				end
			end
		end
		i += 1			
	end
end

options = setup_options(ARGV)
output_dir = options[:output_dir]
sample_name = options[:sample_name]

begin
  FileUtils.mkdir_p options[:output_dir] unless File.directory? options[:output_dir]
rescue Exception => e
  STDERR.puts e.message
end

FileUtils.cd(output_dir)

$stdout = STDOUT
STDOUT.reopen(File.open(sample_name + "_merged.sam","w+"))
seq_new_num(ARGV)


