spatial_extract_image_info <- function(df) {
  df <- df %>%
    mutate(
      image = gsub("https://unyavwofnmwihnpvkjji.supabase.co/storage/v1/object/public/test-stimuli/spatialcognition/", "", image),
      image = gsub(".png", "", image),
      rotation = as.numeric(gsub("rotate_", "", gsub(".*rotate_", "", image)))
    )
  return(df)
}