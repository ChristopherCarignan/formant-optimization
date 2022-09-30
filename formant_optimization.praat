# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# formant_optimization.praat
# created by Christopher Carignan
# Department of Speech, Hearing and Phonetic Sciences
# University College London
# 30 September, 2022
# # # # # # # # # # # # # # # # # # # # # # # # # # # #

### IMPORTANT ###
### Select a sound object in the Praat window before running script
###


filename$ = selected$("Sound")

ceil_low = 3500
ceil_hi = 6000
timestep = 0.005

select Sound 'filename$'
To Formant (burg)... timestep 5 ceil_low 0.025 50
Rename... 'filename$'_baseline

# create baseline formant track matrices
for i from 1 to 5
	select Formant 'filename$'_baseline
	To Matrix... i
	Rename... f'i'
endfor

# iterate through F5 ceilings (ceil_low Hz - ceil_high Hz) in steps of 50 Hz
steps = (ceil_hi - ceil_low)/50

for i from 1 to steps
	step = i*50
	ceiling = ceil_low + step

	# create formant tracks with the current ceiling
	select Sound 'filename$'
	To Formant (burg)... timestep 5 ceiling 0.025 50

	# add formant measures to their respective matrices
	for j from 1 to 5
		select Formant 'filename$'
		To Matrix... j
		Rename... f'j'_new

		plus Matrix f'j'
		Merge (append rows)

		select Matrix f'j'
		Remove

		select Matrix f'j'_f'j'_new
		Rename... f'j'
	endfor

	# clean up
	select Formant 'filename$'
	for j from 1 to 5
		plus Matrix f'j'_new
	endfor
	Remove
endfor

select Matrix f1
points = Get number of columns
measures = Get number of rows
median = round(measures/2)

Create Table with column names... formants points time f1 f2 f3 f4 f5

# iterate through each time step
for i from 1 to points
	# calculate the median formant value at this time step
	for j from 1 to 5
		select Matrix f'j'
		f'j'# = Get all values in column... i
		f'j'# = sort#(f'j'#)
		f'j' = f'j'#[median]
	endfor 

	select Formant 'filename$'_baseline
	time = Get time from frame number... i

	# add time step and median formant values to table
	select Table formants
	Set numeric value... i "time" time
	for j from 1 to 5
		Set numeric value... i "f'j'" f'j'
	endfor
endfor

# clean up
select Formant 'filename$'_baseline
for j from 1 to 5
	plus Matrix f'j'
endfor
Remove