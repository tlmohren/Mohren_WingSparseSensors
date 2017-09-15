# Mohren_WingSparseSensors

Code for paper in prep by T.Mohren, T.Daniel, B.Brunton

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
            |- sparseWingSensors.m  
            |- predictTrain.m 
            |- randCrossVal.m 
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
        |- figs/
            |- run_experimentalSTAfit.png
            |- Figure1A.png
            |- Figure1B.png
            |- Figure2A.png
            |- Figure2BC.png
            |- Figure3.png
            |- Figure4.png
        |- test_code
	  
## Software requirements

Code was developed on MATLAB 2015a. 

## Authors

* **Thomas Mohren** - *code development* - (https://github.com/tlmohren)
* **Tom Daniel** - *supervisor* 
* **Bing Brunton** - *supervisor* - (https://github.com/bwbrunton)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Annika Eberle for developing the eulerLagrange wing model 
[Eberle et al. 2015](http://rsif.royalsocietypublishing.org/content/12/104/20141088.short)
