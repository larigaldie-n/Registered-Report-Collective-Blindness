eyeScrollR_make <- function()
{
  if (!dir.exists(file.path("intermediate_data", "ET"))) {dir.create(file.path("intermediate_data", "ET"), recursive = TRUE)}
  ET_files <- list.files(path=file.path("raw_data", "ET_raw"), pattern="*.csv", full.names = TRUE, recursive = TRUE)
  ET_files_names <- basename(ET_files)
  datasets <- lapply(ET_files, read_csv, comment="#", show_col_types = FALSE)
  datasets <- lapply(datasets,
                     function(x) {names(x) <- make.names(names(x))
                     return(x)
                     }
  )
  
  img_height <- 38579
  img_width <- 1920
  
  source("eyeScrollR_make_timestamps.R")
  
  calib_img <- readPNG("calibration_image.png")
  calibration <- scroll_calibration_auto(calib_img, 100)
  
  for (i in seq_len(length(datasets)))
  {
    startmedia <- (datasets[[i]] %>% filter(SlideEvent=="StartMedia"))[["Timestamp"]]
    d_ET <- eye_scroll_correct(eyes_data = datasets[[i]],
                               timestamp_start = timestamp_start[[ET_files_names[[i]]]],
                               timestamp_stop = timestamp_stop[[ET_files_names[[i]]]],
                               time_shift = startmedia,
                               image_width = img_width,
                               image_height = img_height,
                               calibration = calibration,
                               scroll_lag = get_scroll_lag(refresh_rate = 60, n_frame = 2))
    
    d_ET <- d_ET %>% 
      select(Timestamp = Timestamp.Shifted, Gaze.X, Gaze.Y, Corrected.Gaze.X, Corrected.Gaze.Y, Corrected.Fixation.X, Corrected.Fixation.Y, Scroll)
    
    write_csv(d_ET, file = file.path("intermediate_data", "ET", ET_files_names[i]), na = "")
  }
}
