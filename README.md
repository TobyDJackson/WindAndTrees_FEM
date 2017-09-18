# WindAndTrees_FEM

DOI version available here https://zenodo.org/record/894543#.Wb_kosiGM2x

 The script Example_QSM_to_AbaqusInput takes a QSM (Terrestial LiDAR to QSM process available here: https://doi.org/10.5281/zenodo.844626)
 and converts it into an ABAQUS input file using the function Convert_Q2A_full, which can be used to run a Finite Element analysis in ABAQUS. 
 The other files are subsections and sample data + sample QSM
 
 We encourage users to adapt and update this code + raise issues on GitHub (https://github.com/TobyDJackson/WindAndTrees_FEM)

 There are two options:
 A. Import just the tree geometry into ABAQUS and apply forcings
 manually in the CAE GUI. The output will be within the CAE.
    
 B. Import geometry + define analysis steps - this allows ABAQUS
 analyses to be run in batches. This includes:
       i. Simple analysis steps - gravity, frequency
       ii. Complex analysis - fluid wind forcing, depends on input wind data
       iii. Artificial forcings - pull and release or wind ramp to determine critical wind speeds
 The output of all of these programs will be a .dat file which contains the data, but in a hard-to-use format. 
 In a future release I will provide a script to read in these dat files - it is currently not robust. 
 There is also a .odb output that can be viewed in abaqus VIEWER.
 

 Output variable is by default strain, but can be changed.
 Users require lots of parameters and material properties data, so the
 code below may require changing if this is unavailable.
    
 The free version of abaqus (student) supports both options A and B
 above but each tree is limited to 1000 nodes (999 beams) and does not
 include the AQUA module, through which wind forcing is currently defined.




 The input QSM should have long cylinders and no discontinuities - otherwise the analysis will crash. 
 I use simplify_model_by_branch_size (property of Pasi Raumonen and distributed under GNU license and copied here)
 to achieve these QSMs. See relevant subsection in https://doi.org/10.5281/zenodo.844626 for full details
 Briefly, the function takes an input QSM and deletes all branches above a user defined branching order. 
 The branching order calculation is not yet accurate, so I set this arbitrarilty hight. 
 It then deletes all cylinders under a certain radius (I use 1cm) + all subsequent cylinders. 
 Finally it averages together neighbouring cylinders n times (I use n=2)
