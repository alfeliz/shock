#! /usr/bin/octave --no-gui

###########################################################################################
#
#
#  OCTAVE SCRIPT TO READ MANUALLY COLLECTED DATA OF SHOCK WAVES FROM STREAK IMAGES, 
#     TRANFORM AND USE THEM 
#    Made by Gonzalo Rodríguez Prieto
#       (gonzalo#rprietoATuclm#es)
#       (Mail: change "#" by "." and "AT" by "@"
#              Version 1.00
#
#
#########################################################
#
#  It uses the functions:
#			 regdatasmooth 
#			 display_rounded_matrix
#			 deri
#
#  They must be in the same directory.
#
###########################################################################################



clear; %Just in case there is some data in memory.

pkg load all; #Load all the packages. 

files = dir('ALEX*.csv'); #Take the *.csv files with an'ALEX' in.
#The script assumes all the script images to be analized are in the the same folder than the script.


tic; #Counting time

########
# Some variables and data scaling.
########

um = 95; #um/px (Streak space scaling)

mm = um*1e-3; #mm/px

us = 20/1024; #us/px (Streak time scaling) (IT IS ASSUMED THAT ALL THE STREAKS SHARE THE SWEEP TIME!!!!)


for i=1 : numel(files) #In each file name...



	disp(files(i).name) #Shot identification
	alex = dlmread(files(i).name, ',',1,0); #reading the CSV file
	
	t = linspace(alex(1,2),alex(end,2),200)'; #200 points in the smoothed radius
	r_smooth= regdatasmooth(alex(:,2), alex(:,3), "xhat", t, "lambda", 0.007 ); #Smoothed radius
	v = [deri(r_smooth,t(2)-t(1))]'; #finding velocity 
	a = [deri(v,t(2)-t(1))]';#finding acel.
	v = [v; 0; 0];
	a = [a; 0; 0; 0; 0];
	#SAVING DATA:
	[file_shock, msg] = fopen( horzcat(files(i).name(1:index(files(1).name,"-")-1), "_shock.txt"), "w");
	if (file_shock == -1) 
	   error ("shock script: Unable to open file name: %s, %s",filename, msg); 
	endif; 	
	
	fdisp(file_shock,"time(us) shock_rad(mm)	shoc_vel(mm/us)	shock_acc(mm/us^2)");#first line (Columns Descriptor)
	redond = [4	4	4	6]; #Saved precision
	shock_raw = [t*us, r_smooth*mm, v*(mm/us), a*(mm/(us*us))]; #Matrix with data
	display_rounded_matrix(shock_raw,redond,file_shock); #Saving RAW data
	fclose(file_shock); #Closing the file
	
endfor;





timing = toc;
###
# Total processing time
###

disp("Script shock.m execution time:")
disp(timing /60)
disp(" min.")  




#That's...that's all folks!!!
	
