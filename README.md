# M3VAE
Multi‑Modal Metabolic Variational Autoencoder
## Installation
Install from PyPI:
pip install m3vae==0.1.1
## Input file hierarchy
```markdown

args.root/
    {sample}_exp.csv
    {sample}_coords.csv
    {sample}_counts.csv
    {sample}_neighbor_means_counts.csv
    {sample}_score.csv
    {sample}_adj_matrix.csv
```
     
## M3VAE Input File Specification (R Preview) All input fills can be output by seurat_to_m3vae.R
```markdown
1. {sample}_exp.csv
The expression profile file. Each row represents a gene, and each column represents a single cell.
The first column stores gene symbols, and the remaining columns correspond to individual cell expression values.
> file = rio::import("./m3vaeinput/spatial_exampleDATA_exp.csv")
> file[1:5,1:5]
       V1 AAACAAGTATCTCCCA.1 AAACATTTCCCGGATT.1 AAACCTAAGCAGCCGG.1 AAACGAGACGGTTGAT.1
1    Xkr4                  0                  0                  0                  0
2  Gm1992                  0                  0                  0                  0
3 Gm19938                  0                  0                  0                  0
4 Gm37381                  0                  0                  0                  0
5     Rp1                  0                  0                  0                  0

2. {sample}_coords.csv
The spatial coordinate file. Each row represents a single cell, including cell barcode and corresponding spatial x-y coordinates.
> file = rio::import("./m3vaeinput/spatial_exampleDATA_coords.csv")
> file[1:5,]
                  V1     x    y
1 AAACAAGTATCTCCCA-1 11787 5130
2 AAACATTTCCCGGATT-1 13956 5676
3 AAACCTAAGCAGCCGG-1 14757 7252
4 AAACGAGACGGTTGAT-1  8858 7756
5 AAACGGGCGTACGGGT-1 14749 6348

3. {sample}_counts.csv
The raw expression count file. Each row represents a single cell, and each column represents a gene. The first column stores cell barcodes, and the remaining columns correspond to gene count values.
> file = rio::import("./m3vaeinput/spatial_exampleDATA_counts.csv")
> file[1:5,1:5]
                  V1 Lypla1 Atp6v1h Adhfe1 Sgk3
1 AAACAAGTATCTCCCA.1      1       0      0    0
2 AAACATTTCCCGGATT.1      1       0      0    0
3 AAACCTAAGCAGCCGG.1      0       0      0    0
4 AAACGAGACGGTTGAT.1      0       0      0    0
5 AAACGGGCGTACGGGT.1      0       0      0    0

4. {sample}_neighbor_means_counts.csv
The neighborhood smoothed expression file. Each row represents a single cell, and each column represents a gene. Stores averaged gene expression values from adjacent cells. Note: This file is only required for spatial transcriptomic data and is not used for single-cell data input.
> file = rio::import("./m3vaeinput/spatial_exampleDATA_neighbor_means_counts.csv")
> file[1:5,1:5]
                  V1 Lypla1 Atp6v1h Adhfe1 Sgk3
1 AAACAAGTATCTCCCA.1    1.4     0.8    2.0  0.0
2 AAACATTTCCCGGATT.1    0.4     0.6    0.2  0.0
3 AAACCTAAGCAGCCGG.1    0.2     0.0    0.2  0.0
4 AAACGAGACGGTTGAT.1    1.0     1.4    1.2  0.2
5 AAACGGGCGTACGGGT.1    0.2     0.0    0.4  0.2
Single-cell will not input the "neighbor_means_counts.csv" file

In the {sample}_score.csv, rows represent individual genes while columns represent individual cells.

> file = rio::import("./m3vaeinput/spatial_exampleDATA_score.csv")
> file[1:5,1:2]
                  V1    Glycolysis / Gluconeogenesis - Mus musculus (house mouse) - Mus musculus (mouse)
1 AAACAAGTATCTCCCA-1                                                                        0.2087134
2 AAACATTTCCCGGATT-1                                                                        0.2102013
3 AAACCTAAGCAGCCGG-1                                                                        0.1582515
4 AAACGAGACGGTTGAT-1                                                                        0.2353885
5 AAACGGGCGTACGGGT-1                                                                        0.1614607

5. {sample}_scores.csv
The pathway enrichment score file. Each row represents a single cell, and each column represents a biological pathway. Stores pathway activity scores for individual cells.
> file = rio::import("./m3vaeinput/spatial_exampleDATA_adj_matrix.csv")
> file[1:5,1:4]
                  V1 AAACAAGTATCTCCCA-1 AAACATTTCCCGGATT-1 AAACCTAAGCAGCCGG-1
1 AAACAAGTATCTCCCA-1          0.2155905          0.0000000          0.0000000
2 AAACATTTCCCGGATT-1          0.0000000          0.2586816          0.0000000
3 AAACCTAAGCAGCCGG-1          0.0000000          0.0000000          0.2156319
4 AAACGAGACGGTTGAT-1          0.0000000          0.0000000          0.0000000
5 AAACGGGCGTACGGGT-1          0.0000000          0.0000000          0.0000000
```  

## Output file hierarchy:
```markdown
args.output_root/
    output_root/
        {sample}_flux.csv
        {sample}_balance.csv
        {sample}_prob.csv
        {sample}_python_clusters.csv
        {sample}_GMM_BICAIC.pdf
        {sample}_Importance.pdf
        {sample}_spatial_cluster.pdf


``` 

## Usage
```markdown
m3vae -h
usage: m3vae [-h] --sample SAMPLE [--species {Homo_sapiens,Mus_musculus}] [--test_file TEST_FILE]
              [--moduleGene_file MODULEGENE_FILE] [--stoichiometry_matrix STOICHIOMETRY_MATRIX]
              [--cName_file CNAME_FILE] [--output_flux_file OUTPUT_FLUX_FILE]
              [--output_balance_file OUTPUT_BALANCE_FILE] --root ROOT [--output_root OUTPUT_ROOT]
              [--datatype {Spatial,single_cell}] [--epochs EPOCHS] [--n_clusters_range N_CLUSTERS_RANGE] [--seed SEED]
              [--n_components N_COMPONENTS] [--custom_colors CUSTOM_COLORS]

M3VAE: Multi-Modal Metabolic Variational Autoencoder

options:
  -h, --help            show this help message and exit
  --sample SAMPLE       Sample name of input files, which is also used to name the output files
  --species {Homo_sapiens,Mus_musculus}
                        Species: 'Homo_sapiens'(human) or 'Mus_musculus'(mouse). Default: Homo_sapiens
  --test_file TEST_FILE
                        Tab‑separated gene profile matrix input file. Row is gene symbol, column is single‑cell or
                        spatial spot. Default: {sample}_exp.csv under --root.
  --moduleGene_file MODULEGENE_FILE
                        The table contains genes for each module. We provide human and mouse two models. For human
                        model, please use module_gene_m168.csv which is default. All candidate moduleGene files are
                        provided in /data/ folder.
  --stoichiometry_matrix STOICHIOMETRY_MATRIX
                        The table describes relationship between compounds and modules. Each row is an intermediate
                        metabolite and each column is metabolic module. For human model, please use cmMat_c70_m168.csv
                        which is default. All candidate stoichiometry matrices are provided in /data/ folder.
  --cName_file CNAME_FILE
                        Built‑in compound name table csv.This table contains the names of the compounds and their
                        corresponding identifiers. Specifically, the first row represents the names of the compounds,
                        and the second row shows the corresponding identifiers. Default: cName_c70_m168.csv
  --output_flux_file OUTPUT_FLUX_FILE
                        Filename for predicted flux output. Default: {sample}_flux.csv
  --output_balance_file OUTPUT_BALANCE_FILE
                        Filename for predicted balance output. Default: {sample}_balance.csv
  --root ROOT           The data directory for input data. The root includes Spatial folder, filtered_count_matrix
                        folder or filtered_feature_bc_matrix.h5. The Spatial folder includes
                        tissue_positions_list.csv, tissue_hires_image.png, tissue_lowres_image.png and
                        scalefactors_json.json. The filtered_count_matrix folder includes barcodes.tsv.gz,
                        features.tsv.gz, and matrix.mtx.gz
  --output_root OUTPUT_ROOT
                        Output directory for MMMVAE results storing output matrices. Default: {root}/output
  --datatype {Spatial,single_cell}
                        The data type input by the user, either 'single_cell' or 'Spatial'. Default: Spatial
  --epochs EPOCHS       Training epochs. Default: 100
  --n_clusters_range N_CLUSTERS_RANGE
                        Upper bound for niche‑cluster search. Algorithm searches optimal k from 2 to this value.
                        Default: 15
  --seed SEED           Random seed for reproducibility. Default: 2026
  --n_components N_COMPONENTS
                        Manually set fixed number of metabolic niche clusters, skip automatic BIC‑based optimal‑k
                        selection.
  --custom_colors CUSTOM_COLORS
                        Comma‑separated hex color strings for plotting metabolic ecotypes, e.g.: ['#83fc8d',
                        '#7c7afa'].

``` 
## Test:
```markdown
#Local installation
cd ./M3VAE
conda activate m3vae_env
pip install -e . 

#Online installation
pip install m3vae

m3vae -h
m3vae --sample spatial_exampleDATA  --species Mus_musculus --datatype Spatial  --root .\r_preprocess\example\spatial_exampleDATA\m3vaeinput
m3vae --sample single-cell_exampleDATA  --species Homo_sapiens --datatype single_cell  --root .\r_preprocess\example\single-cell_exampleDATA\m3vaeinput 
``` 


## Test output
```markdown
(m3vae_env) D:\Desktop\M3VAE>m3vae --sample spatial_exampleDATA  --species Mus_musculus --datatype Spatial  --root .\r_preprocess\example\spatial_exampleDATA\m3vaeinput
scFEA start...
Load data done.
D:\Desktop\M3VAE\src\m3vae\M3VAE.py:327: FutureWarning: The behavior of DataFrame concatenation with empty or all-NA entries is deprecated. In a future version, this will no longer exclude empty or all-NA columns when determining the result dtypes. To retain the old behavior, exclude the relevant entries before the concat operation.
  geneExprDf = pd.concat([geneExprDf, temp], ignore_index=True, sort=False)
Process data done.
Starting train neural network...
100%|████████████████████████████████████████████████████████████████████████████████| 100/100 [01:28<00:00,  1.14it/s]
Training time: 88.08639144897461
Starting load data...
Starting process data...
Active modalities: ['score', 'balance', 'flux', 'counts', 'neighbor']
Starting training...
Epoch 000 | Loss=7.5302 | Recon=7.5302 | KL=0.2742 |
Epoch 020 | Loss=5.0009 | Recon=4.8414 | KL=0.7976 |
Epoch 040 | Loss=4.8495 | Recon=4.4950 | KL=0.8864 |
Epoch 060 | Loss=4.4985 | Recon=4.1121 | KL=0.6440 |
Epoch 080 | Loss=4.3076 | Recon=3.8563 | KL=0.5642 |
 BIC and AIC Plotting...
Auto-selected best n_components = 11 (min BIC)
Process data done:

================ GMM Model Selection =================
[INFO] BIC/AIC curve has been saved to:
.\r_preprocess\example\spatial_exampleDATA\mmmvaeinput\output\spatial_exampleDATA_GMM_BICAIC.pdf
[INFO] Please check this file to determine the optimal number of clusters.
[INFO] If you do not specify --n_components, the model will use the BIC-optimal value.
=====================================================

[AUTO] n_components is not provided. Using BIC-optimal value: 11
.\r_preprocess\example\spatial_exampleDATA\mmmvaeinput\output\spatial_exampleDATA_spatial_cluster.pdf

``` 