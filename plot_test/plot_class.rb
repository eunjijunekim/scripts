#!/usr/bin/env ruby
#plot_class.rb

class Dataset 
	def initialize filename = false
	@filename = filename			
	@f = File.read(@filename)
	end

	#open and read in the files by column
	def get_xdata
		xData = []
		@f.each_line do |line|
			xData << line.split(" ")[0].to_f
		end
		xData
	end

	def get_ydata
		yData = []
		@f.each_line do |line|
			yData << line.split(" ")[1].to_f
		end		
		yData
	end
end


