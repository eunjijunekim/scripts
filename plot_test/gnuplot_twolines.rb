#!/usr/bin/env ruby
#example.rb
require 'rubygems'
require 'gnuplot'

#create an output file
outFname='example_graph.png'

#read in the files
#file1 has larger y-values than file2
file1 = File.open("chr18_poly.txt")
xData1 = []
yData1 = []
file1.each_line do |line|
	xData1 << line.split(" ")[0].to_f
	yData1 << line.split(" ")[1].to_f
end
file1.close

file2 = File.open("chr18_20FYGD_mut")
xData2 = []
yData2 = []
file2.each_line do |line|
	xData2 << line.split(" ")[0].to_f
	yData2 << line.split(" ")[1].to_f
end
file2.close

#plot
Gnuplot.open do |gp|
	Gnuplot::Plot.new( gp ) do |plot|
		
		plot.output outFname
		plot.terminal 'png'
		plot.title "20FYGD_mut Chr18, window_length=50SNP, Homozygosity Score (Wik + TLF)"
		plot.ylabel "Homozygosity score"
		plot.xlabel " "
		#plot.xrange "[-1000000:51000000]"
		#plot.yrange "[-0.05:1.05]"
		plot.xtics 'format "%.0sMbp"' 
		plot.xtics 'nomirror'
		plot.ytics 'nomirror'
		
		#horizontal lines
		plot.arrow 'from 0,0.1 to 50000000,0.1 nohead lt 0 lc 0'
		plot.arrow 'from 0,0.4 to 50000000,0.4 nohead lt 0 lc 2'
		plot.arrow 'from 0,0.9 to 50000000,0.9 nohead lt 0 lc 0'

		x1 = xData1
		y1 = yData1.collect{|y| y * (0.4/yData1.max)} 
		x2 = xData2
		y2 = yData2
		
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


