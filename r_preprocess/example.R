#!/usr/bin/env Rscript

source("./seurat_to_m3vae.R")
load("./metabolic_data.RData")


seurat2m3vae(
  sample = "spatial_exampleDATA",
  species = "Mus_musculus",
  datatype = "Spatial",
  root = "./example/spatial_exampleDATA/",
  output_root = "./example/spatial_exampleDATA/m3vaeinput"
)

seurat2m3vae(
  sample = "single-cell_exampleDATA",
  species = "Homo sapiens",
  datatype = "single_cell",
  root = "./example/single-cell_exampleDATA/",
  output_root = "./example/single-cell_exampleDATA/m3vaeinput"
)
