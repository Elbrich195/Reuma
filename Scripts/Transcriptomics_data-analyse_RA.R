
# Transcriptomics analyse van genen en pathways geassocieerd met reumatoïde artritis
# Elbrich Bouma
# 20-6-2025



#set working directory
setwd("C:/pad/naar/de/datafolder")

library(Rsubread)
library(Rsamtools)

#Maak een indexbestand aan van het menselijke referentiegenoom (GRCh38) voor snelle uitlijning van de reads.
buildindex(
  basename = 'ref_Homo_Sapien',
  reference = 'GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 8000,
  indexSplit = TRUE)

# mappen van monsters tegen menselijk genoom (forward en reverse)
align.Gezond1 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785819_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785819_2_subset40k.fastq",  # reverse reads
  output_file = "Gezond1.BAM"
)
align.Gezond2 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785820_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785820_2_subset40k.fastq",  # reverse reads
  output_file = "Gezond2.BAM"
)
align.Gezond3 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785828_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785828_2_subset40k.fastq",  # reverse reads
  output_file = "Gezond3.BAM"
)
align.Gezond4 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785831_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785831_2_subset40k.fastq",  # reverse reads
  output_file = "Gezond4.BAM"
)
align.Reuma1 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785979_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785979_2_subset40k.fastq",  # reverse reads
  output_file = "Reuma1.BAM"
)
align.Reuma2 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785980_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785980_2_subset40k.fastq",  # reverse reads
  output_file = "Reuma2.BAM"
)
align.Reuma3 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785986_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785986_2_subset40k.fastq",  # reverse reads
  output_file = "Reuma3.BAM"
)
align.Reuma4 <- align(
  index = "ref_Homo_Sapien",
  readfile1 = "SRR4785988_1_subset40k.fastq",  # forward reads
  readfile2 = "SRR4785988_2_subset40k.fastq",  # reverse reads
  output_file = "Reuma4.BAM"
)


# Bestandsnamen aan de monsters geven en sorteren op genomische positie
samples <- c('Gezond1', 'Gezond2', 'Gezond3', 'Gezond4', 'Reuma1', 'Reuma2', 'Reuma3', 'Reuma4')
lapply(samples, function(s) {sortBam(file = paste0(s, '.BAM'), destination = paste0(s, '.sorted'))})

#indexbestand bij elk BAM-bestand maken (makkelijker om specifieke regio's vinden)
lapply(samples, function(s) {indexBam(file = paste0(s, '.sorted.bam'))})



library(readr)
library(dplyr)
library(Rsamtools)
library(Rsubread)


#lijst met alle BAM-bestanden
allsamples <- c('Gezond1.BAM', 'Gezond2.BAM', 'Gezond3.BAM', 'Gezond4.BAM', 'Reuma1.BAM', 'Reuma2.BAM', 'Reuma3.BAM', 'Reuma4.BAM')

#tellen hoeveel reads op elk gen mapt in elk sample (gebruikt GTF-files)
#LET OP! forward en reverse reads aanwezig, dus isPairedEnd = TRUE
count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "genomic.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = TRUE
)

#check
head(count_matrix$annotation)
head(count_matrix$counts)
str(count_matrix)

# Haal alleen de matrix met tellingen eruit (hoevaak elk gen voorkomt in elk sample)
counts <- count_matrix$counts
rownames(counts) <- counts[, 1]


#opslaan matrix
write.csv(counts, "count_matrix.csv")
head(counts)



BiocManager::install('DESeq2')
BiocManager::install('KEGGREST')
library(DESeq2)
library(KEGGREST)

#countmatrix inladen als dit nog niet gedaan is
counts <- read.table("count_matrix.txt", row.names = 1)

#tabel maken met welke samples bij gezonde personen of RA-patiënten horen
treatment <- c("Gezond", "Gezond", "Gezond", "Gezond", "Reuma", "Reuma", "Reuma", "Reuma")
treatment_table <- data.frame(treatment)
rownames(treatment_table) <- c('SRR4785819', 'SRR4785820', 'SRR4785828', 'SRR4785831', 'SRR4785979', 'SRR4785980', 'SRR4785986', 'SRR4785988')
#rownames = samplenummers, want in de verkregen countmatrix door school zijn ze zo genoemd


# Maak DESeqDataSet aan (DeSeq zet alle data om tot een goede vorm voor statistische analyse)
dds <- DESeqDataSetFromMatrix(countData = round(counts),     #round: rond komma getallen af (DESeq kan geen komma getallen gebruiken)
                              colData = treatment_table,
                              design = ~ treatment)

# Voer differentiële expressie-analyse uit
dds <- DESeq(dds)
resultaten <- results(dds)

# Resultaten opslaan in een bestand
write.table(resultaten, file = 'Resultaten_Reuma.csv', row.names = TRUE, col.names = TRUE)

#Tellen hoeveel genen zijn up or down-regulated (en is dit significant en biologisch relevant)
#Upregulated 2085 genen
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange > 1, na.rm = TRUE)
#downregulated 2487 genen
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange < -1, na.rm = TRUE)


#resultaten sorteren 
#sterkste upregulated gen boven
hoogste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = TRUE), ]
#sterkste downregulated gen boven
laagste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = FALSE), ]
#meest significante p-waarde boven
laagste_p_waarde <- resultaten[order(resultaten$padj, decreasing = FALSE), ]

#hoogste fold change= MTND5P5
head(hoogste_fold_change)
#laagste fold change= HNRPA3PP6
head(laagste_fold_change)
#laagste p-waarde= ANKRD30BL
head(laagste_p_waarde)

#volcanoplot laat zien welk genen significant veranderen in expressie
#x-as=log2FoldChange (hoe sterk is het verschil?)
#y-as= -log10(padj) (hoe significant is het verschil?)
if (!requireNamespace("EnhancedVolcano", quietly = TRUE)) {
  BiocManager::install("EnhancedVolcano")
}
library(EnhancedVolcano)

EnhancedVolcano(resultaten,
                lab = rownames(resultaten),
                x = 'log2FoldChange',
                y = 'padj')


#volcanoplot opslaan
dev.copy(png, 'Volcanoplot_Reuma.png', 
         width = 8,
         height = 10, 
         units = 'in',
         res = 500)



BiocManager::install("goseq")
BiocManager::install("geneLenDataBase")
BiocManager::install("org.Dm.eg.db")
library(goseq)
library(geneLenDataBase)
library(org.Dm.eg.db)
library(dplyr)


#resultaten opnieuw inladen als dit nodig is
resultaten <- read.table('Resultaten_Reuma.csv', row.names = 1)

#ALL = alle gennamen in de dataset
#DEG = alle gennamen van genen die <0.05 significant zijn (padj) (DEG=differentially expressed gene)
ALL <- (row.names(resultaten))
resultaten <- data.frame(resultaten)  
DEG <- resultaten %>%
  filter(padj <0.05)
DEG <-row.names(DEG)

#maak een binaire vector (nodig voor GO-analyse) met:
#     1 = het gen is een DEG 
#     0 = het gen is niet significant veranderd in expressie
gene.vector=as.integer(ALL%in%DEG)
names(gene.vector)=ALL 

#check
head(gene.vector)
tail(gene.vector)


#lange sequenties hebben meer kans om significant te lijken, moet voor worden gecorrigeerd
supportedOrganisms()
pwf <- nullp(gene.vector, "hg19", "geneSymbol")


#genlengtecorrectie plot opslaan
dev.copy(png, 'Nullplot.png', 
         width = 8,
         height = 10, 
         units = 'in',
         res = 500)


#bereken welke GO-termen significant vaker voorkomt onder DEGs dan verwacht
GO.wall=goseq(pwf, "hg19","geneSymbol")

#Check welke GO-temen het meest significant zijn
head(GO.wall)


library(ggplot2)

#selecteer top 10 GO-termen met laagste p-waarde
#x-as: percentage DEGs binnen elke GO-term
#y-as: GO-term omscrijving
GO.wall %>% 
  top_n(10, wt=-over_represented_pvalue) %>% 
  mutate(hitsPerc=numDEInCat*100/numInCat) %>% 
  ggplot(aes(x=hitsPerc, 
             y=term, 
             colour=over_represented_pvalue, 
             size=numDEInCat)) +
  geom_point() +
  expand_limits(x=0) +
  labs(x="Hits (%)", y="GO term", colour="p value", size="Count")


#Go-enrichmentplot opslaan
dev.copy(png, 'GO.wall.png', 
         width = 10,
         height = 8, 
         units = 'in',
         res = 500)



#pathview visulatiseer KEGG pathways (database met genen en de daarbij behorende biologische processen)
if (!requireNamespace("pathview", quietly = TRUE)) {
  BiocManager::install("pathview")
}
library(pathview)
library(KEGGREST)

#maak eeen vector met log2FoldChanges per gen
res_folchange <- resultaten$log2FoldChange
names(res_folchange) <- rownames(resultaten)

#visualiseren van de genexpressie (log2FoldChange) binnen een KEGG-pathway
pathview(
  gene.data = res_folchange,  # log2 fold changes per gen
  pathway.id = "hsa05323",    # KEGG ID voor een pathway (Rheumatoid arthritis)
  species = "hsa",            #'hsa' = humaan gen in KEGG database
  gene.idtype = "SYMBOL",     # Geef aan dat welke soort KEGG-ID's dit zijn
  limit = list(gene = 5),     # Kleurenschaal voor log2FC (-5 tot +5)
  low = list(gene = "red"),
  mid = list(gene = "gray75"),
  high = list(gene = "chartreuse3"),
  )


#kijken welk genen horen bij KEGG-pathway hsa05323
keggLink("hsa", "path:hsa05323")

#kijken in welke KEGG pathway het humaan gen 1432 voorkomt
keggLink("pathway", "hsa:1432")

