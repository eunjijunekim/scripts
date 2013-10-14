#!/usr/bin/env ruby
#main.rb

require 'plot_class'
require 'rubygems'
require 'gnuplot'


#create an output file 
outFname='graph_new.png'

#input filenames
filename1 = 'chr18_poly.txt'
filename2 = 'chr18_20FYGD_mut'

#new files
f1 = Dataset.new(filename1)
f2 = Dataset.new(filename2)

#set i value for scaling plots
i = 0.4

#plot
Gnuplot.open do |gp|
	Gnuplot::Plot.new( gp ) do |plot|
		
		plot.output outFname
		plot.terminal 'png'
		plot.title "20FYGD_mut Chr18, window_length=50SNP, Homozygosity Score (Wik + TLF)"
		plot.ylabel "Homozygosity score"
		plot.xlabel " "
		plot.xtics 'format "%.0sMbp"' 
		plot.xtics 'nomirror'
		plot.ytics 'nomirror'
		
		#horizontal lines
		plot.arrow 'from 0,0.1 to 50000000,0.1 nohead lt 0 lc 0'
		plot.arrow 'from 0,0.4 to 50000000,0.4 nohead lt 0 lc 2'
		plot.arrow 'from 0,0.9 to 50000000,0.9 nohead lt 0 lc 0'

		x1 = f1.get_xdata
		y1 = f1.get_ydata
		x2 = f2.get_xdata
		y2 = f2.get_ydata

		#scale 
		if y1.max > 1 
			y1 = y1.map{|y| y * (i/y1.max)}
		end

		if y2.max > 1
			y2 = y2.map{|y| y * (i/y2.max)}
		end

		plot.data = [ 

			Gnuplot::DataSet.new( [x1, y1] ) do |ds|
				ds.with= "lines lc 2"
				ds.notitle
			end,

			Gnuplot::DataSet.new([x2, y2]) do |ds|
				ds.with = "lines lc 3"
				ds.notitle
			end
		]
		
	end
end