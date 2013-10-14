@f.each_line do |line|#!/usr/bin/env ruby
#practice.rb
f1 = 'testfile_1.sam'
f2 = 'testfile_2.sam'


filelist = [f1,f2]



#gives you the last seq number of the file
def get_last_seq_num(filename)
	seq_num = []
	f = File.open(filename)
	f.each_line do |line|
		seq_num << line.split("seq.")[1].to_i
	end
	seq_num.last
end

#gives you a sum of the last seq numbers from the previous files in the filelist
def seq_num_sum(filelist)
	add_seq_num = []
	seq_num = []
	f_num = 0
	for i in 0 .. filelist.size-1
		if i == 0
			add_seq_num << 0
			f = File.open(filelist[i])
			f.each_line do |line|
				num = line.split("seq.")[1].to_i + add_seq_num[i].to_i
				f_num = num.to_s			
			end
			i += 1
		else
			add_seq_num << add_seq_num[i-1] + get_last_seq_num(filelist[i-1])
			File.open(filelist[i]) do |f|
				out = ""
				f.each do |line|
					num = line.split("seq.")[1].to_i  
					num2 = add_seq_num[i].to_i
					num_s = num.to_s
					f_num = (num + num2).to_s
					out << line.gsub(num_s, f_num)			
				end
				f.pos = 0
				f.print out
			end
			i += 1			
		end
	end
end


File.open("merged.sam", "w") {|f_out|
	filelist.each{|f_name|
		File.open(f_name){|f_in|
			f_in.each{|f_str|
				f_out.puts(f_str)}}}}





