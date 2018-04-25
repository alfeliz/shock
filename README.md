# shock
Octave script/program to read the manually collected data on the shock waves and trasnform them to better use them.


## Usage

Just run the program from the console in the folder with all the *.CSV data ot the radius. 
The script assumes that their names are _ALEX???.CSV_, and read and transform them automatically.
Output is a text file with the shock wave radius, velocity and acceleration over time in mm and µs units.

The script needs the files:
* deri.m,
* display_round_matrix.m, and 
* regdatasmooth. 

The last function is from the Octave package "data-smoothing"

