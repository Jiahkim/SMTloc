(1) c1_nuc_dapipoor_spk.m
Purpose: Generate a segmented image of nuclear compartments: speckles, interchromatin, and chromatin-dense areas.
Input:
Image of speckles and DNA in .tif format.
If your images are in a different format, change the file extension in line 10.
Adjustments:
Adjust image levels for contrast in lines 6–9 as needed.
Set the path and file name for saving/reading in lines 4–5.
Output:
Segmented areas saved separately in a .mat file, and combined in nuc.mat.
In the combined segmented image, pixel values correspond to:
Speckle area = 290
Interchromatin = 200
Chromatin-dense region = 100
(2) c2_track_loc.m
Purpose: Sort tracks based on the segmented nuclear image.
Input:
nuc.mat (from c1_nuc_dapipoor_spk.m)
tracksFinal (track data from UTrack)
Settings:
Change line 6 to select the minimum track length to include.
Output:
trk_loc_ratio.mat: Fraction of each track in NS, IC, Chromatin, and outside the nucleus (in order).
Optional: Visualize which tracks belong to each nuclear region (see header section in the code).
(3) c3_track_disp.m
Purpose: Generate a histogram of per-frame displacements for calculating diffusion coefficients.
Input:
trk_loc_ratio.mat (from c2_track_loc.m)
tracksFinal (from UTrack)
Settings:
To save the histogram, activate line 73.
Output:
Histogram ready for export and further analysis.
