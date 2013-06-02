require 'spec_helper'

describe "Plot"  do
	#testfile1.txt = [1		2, 3	4, 5	6, 7	8]
	#testfile2.txt = empty file
	#testfile3.jpg = jpg file

	before :each do
		@dataset1 = Dataset.new("testfile1.txt")
		@dataset2 = Dataset.new("testfile2.txt")
		@dataset3 = Dataset.new("testfile3.jpg")
		@filename = "testfileXYZ.txt"
	end
	
	describe "#new" do
		it "returns a new dataset object" do
			@dataset1.should be_an_instance_of Dataset
		end
	end

	describe "#dataset" do
		it "throws an **Error when given empty dataset" do
			lambda @dataset2.should raise_exception 
		end		

		it "throws an **Error when given wrong data type" do
			lambda {@dataset3}.should raise_exception 
		end

	end

	describe "#get_xdata" do
		it "returns all x data from dataset" do
			@dataset1.get_xdata.length.should == 4
		end
	end

	
end