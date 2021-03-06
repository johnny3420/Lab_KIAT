### Comparing different conditions

#Load files and library
library(edgeR)
library(reshape2)
library(ggplot2)
library(plyr)
library(gplots)
load("F2.read.count.small.Rdata")
load("F2.read.count.sample.Rdata")

# Create DGElist and Normalize
dge.data.F2 <- DGEList(counts=F2.read.count.small, group=F2.read.count.sample$Batch)
dge.data.F2 <- calcNormFactors(dge.data.F2, method = "TMM") 

# Setting up design
design.F2 <- model.matrix(~group, data=dge.data.F2$samples)
colnames(design.F2) <- levels(dge.data.F2$samples$group)
design.F2

# estimating dispersions and create fit
dge.data.F2 <- estimateGLMCommonDisp(dge.data.F2, design.F2,verbose = TRUE) # Disp = 0.26724 , BCV = 0.517
dge.data.F2 <- estimateGLMTrendedDisp(dge.data.F2,design.F2)
dge.data.F2 <- estimateGLMTagwiseDisp(dge.data.F2,design.F2)
plotBCV(dge.data.F2) #export Plot


fit <- glmFit(dge.data.F2, design.F2)

et <- exactTest(dge.data.F2)
et

lrt.b_vs_a <-glmLRT(fit, coef = 2)
b_vs_a <- summary(decideTestsDGE(lrt.b_vs_a,p.value=0.01))
b_vs_a
#    [,1] 
# -1 22988
# 0  21938
# 1  18893