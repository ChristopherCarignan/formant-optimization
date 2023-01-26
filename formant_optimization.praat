# # # # # # # # # # # # # # # # # # # # # # # # # # # #
# formant_optimization.praat
# created by Christopher Carignan
# Department of Speech, Hearing and Phonetic Sciences
# University College London
# 30 September, 2022
#
# Updates
# 26 January, 2023:  changed estimation of the point of measurement stability
# # # # # # # # # # # # # # # # # # # # # # # # # # # #

### IMPORTANT ###
### Select a sound object in the Praat window before running script
###

# parameters
ceil_lo = 3500
ceil_hi = 6000
timestep = 0.005

filename$ = selected$("Sound")

# create baseline formant object
select Sound 'filename$'
To Formant (burg)... timestep 5 ceil_lo 0.025 50
Rename... 'filename$'_baseline

# create baseline formant track matrices
for i from 1 to 5
	select Formant 'filename$'_baseline
	To Matrix... i
	Rename... f'i'
endfor

# iterate through F5 ceilings (ceil_lo Hz - ceil_high Hz) in steps of 50 Hz
steps = (ceil_hi - ceil_lo)/50

for i from 1 to steps
	# get current F5 ceiling (Hz)
	step = i*50
	ceiling = ceil_lo + step

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

Create Table with column names... formants points time f1 f2 f3 f4 f5

# iterate through each time step
for i from 1 to points

	# estimate the point of measurement stability for each formant at the time step
	for j from 1 to 5

		select Matrix f'j'
		f'j'# = Get all values in column... i

		# calculate the first difference (velocity) of the formant track
		diff# = zero#(measures-1)		
		for k from 1 to measures-1
			diff#[k] = abs(f'j'#[k+1] - f'j'#[k])
		endfor

		# find the maximum absolute difference
		# this is the point of divergence between (potentially) two stability points
		# (we want the second one, since the formant ceilings are increasing)
		maxidx = imax(diff#)

		# trim from the maximum index
		ftrim# = zero#(1+measures-maxidx)
		y = 1
		for k from maxidx to measures
			ftrim#[y] = f'j'#[k]
			y = y+1
		endfor

		# calculate the first difference of the trimmed data
		diff# = zero#(measures-maxidx)
		for k from 1 to measures-maxidx-1
			diff#[k] = abs(ftrim#[k+1] - ftrim#[k])
		endfor
		
		# find the minimum absolute difference of the trimmed data 
		# this is the estimate of the measurement stability point
		minidx = imax(0-diff#)
		
		# get the formant value at the stability point
		f'j' = ftrim#[minidx]
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