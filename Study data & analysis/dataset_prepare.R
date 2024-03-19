library(png)
library(tidyverse)
library(eyeScrollR)

# First, remove Z in file names (used by the Flask server for a simplified
# counting of participants per condition)
# Then, exclude bad or incomplete data sets (poor calibration, eye tracker files
# without an associated response file and conversely, no responses in the
# response file, low frequency of eye tracking data)
source("preprocessing.R")
remove_Z()
exclude()

# Takes files from /raw_data/ET_raw (raw eye tracker files from iMotions), and
# outputs eyeScrollR-corrected files into /intermediate_data/ET/
source("eyeScrollR_make.R")
eyeScrollR_make()

# Takes files from /intermediate_data/ET/ (eyeScrollR-corrected files), and
# outputs files in /final_data/, which are complete data files with all
# statements, questionnaire ratings, experimental condition and total dwell
# times
# Then, pick 3 random long (>150ms) fixations at the end of the stimuli
# presentation (after the median of timestamps), pick the central video frame,
# and prepare everything for the outcome-neutral checking that those fixations
# are indeed close to eyeScrollR-corrected fixations. Allows to check if the
# participant did respect instructions regarding only using the mouse wheel
# to scroll, and if eyeScrollR did everything correctly. Those fixations are
# output in ../Fixation check/ET_check
source("dataset_merge.R")
datasets_merge()
pick_fixation_time()