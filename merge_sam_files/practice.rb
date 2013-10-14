#!/usr/bin/env ruby
#practice.rb
f1 = 'testfile_1.sam'
f2 = 'testfile_1.sam'
f3 = 'testfile_1.sam'


filelist = [f1,f2,f3]



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

seq_new_num(filelist)

#File.open("merged.sam", "w") {|f_out|
#	filelist.each{|f_name|
#		File.open(f_name){|f_in|
#			f_in.each{|f_str|
#				f_out.puts(f_str)}}}}





