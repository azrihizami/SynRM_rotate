# SynRM_rotate
This repository groups programmes used to simulate the SynRM machine in FEMM and evaluate different parameters. The programs are Matlab programs that run FEMM via dedicated functions.

The main program to analyze the machine topology: Main_1.m
	To run it the steps below need to be followed:
	a. Create a CAD model of the machine to be studied
	b. Export the cross section of the machine into dxf file
	c. Import the dxf file into FEMM. To make rotational movement in batches of FE analysis, the rotor need to be rotated, ison=lated form the stator. 
	So, select only the rotor and save a FEMM file for an initial rotor position.
	d. Run the 'Rotate_rotor.m' program that creates duplicate of the rotor at chosen position and angular rotation resolution.
	e. Run the 'Main_1.m' program that does the following:
		1. Open the rotor FEMM file
		2. Add stator geometry to it
		3. Add blocks and defined properties, as well as assigning groups of components
		4. Add circuit property
		5. Add boundary properties
		6. It saves the completely defined machine at each angular position
		7. Mesh and analyze the model
		8. Post processing analysis can be added later on

The repository includes:
1. 'Main_1.m' 			: The main file
2. 'SynRM_SegRotor.dxf' 	: The dxf file of the motor geometry exported for CAD 
3. 'Rotor_0deg.FEM'		: The FEMM file of the rotor alone. Extracted manually from the dxf above.
4. 'Rotate_rotor.m' 		: The m file that rotate the rotor geometry
5. 'Add_stator.m'  		: The m file that add stator geometry to the stator. Not necessary as it is now included in the 'Main_1.m'
6. 'Stator_points_134.mat'	: The nodes parameters file of the stator. Needed to recreate the stator in 1 and 5. 
7. 'Stator_segments_134.mat'	: The segments parameters file of the stator. Needed to recreate the stator in 1 and 5.
8. 'Stator_arcs_134.mat'	: The arc segments parameters file of the stator. Needed to recreate the stator in 1 and 5.
9. 'TriphaseCurrent.m'		: A matlab code that plot the 3 phases current for value verification
