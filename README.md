# Mohren_WingSparseSensors
Code for paper in prep Mohren, Daniel, Brunton

### General Structre

    Mohren_WingSparseSensors/
      |- README.md
      |- LICENSE
      |- scripts/
	     |- addpathFolderStructure.m
         |- run_paperAnalysis.m
         |- run_Figure1.m
         |- run_Figure2A.m
         |- run_Figure2BC.m
         |- run_Figure3.m
         |- run_Figure4.m
		 |- run_normalizationParameter.m
		 |- run_allFigures.m
		 
      |- functions/
		 |- createParListSingle.m
		 |- createParListTotal.m
		 |- createParSet.m
		 
		 |- eulerLagrange.m
		 |- eulerLagrangeConcatenate.m  
		 |- funcCa.m 
		 |- gaussian_perturbation.m  
		 |- shape2.m  
		 |- shapefunc2.m 
		 |- createODEfile_rotvect.m
		 |- disturbanceCalibrate.m
		 |- whiteNoiseDisturbance.m 
		 
		 |- createNeuralFilt.m
		 |- neuralEncoding.m  
		 |- predictTrain.m 
		 |- randCrossVal.m 
		 
		 |- sparseWingSensors.m  
		 |- PCA_LDA_singVals.m 
		 |- LDA_n.m  
		 |- sensorLocSSPOC.m  
		 |- SSPOC.m  
		 |- sensorLocClassify.m  
		 |- classify_nc.m
		 
		 |- combineDataMat.m
		 |- getMeanSTD.m  
		 |- shadedErrorBar.m  
		 |- sigmFitParam.m  
		 |- get_pdf.m  
		 |- plotSensorLocs.m  
		 
		 |- spa_sf.m  
		 
      |- figs/
	     |- Figure1A_R1R2withExpFilterIter5.png
	  |- test_code


