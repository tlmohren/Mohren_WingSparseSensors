# Mohren_WingSparseSensors

Code for paper in prep by T.Mohren, T.Daniel, S. Brunton, B.Brunton

## Software requirements

Code was developed on MATLAB 2015a.

## Authors

* **Thomas Mohren** - *code development* - (https://github.com/tlmohren)
* **Tom Daniel** - *supervisor*
* **Steve Brunton** - *supervisor*
* **Bing Brunton** - *supervisor* - (https://github.com/bwbrunton)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Annika Eberle for developing the eulerLagrange wing model
[Eberle et al. 2015](http://rsif.royalsocietypublishing.org/content/12/104/20141088.short)

### General Structre
    Mohren_WingSparseSensors/
        |- README.md
        |- LICENSE
        |- accuracyData
            |- Data_*
        |- eulerLagrangeData
            |- strainSet*
        |- figData
            |- ...
        |- figs/
            |- Figure_*

        |- simulation_scripts/
            |- addpathFolderStructure.m
            |- run_exampleScript.m
            |- run_mainSimulation.m
            |- run_ZcodeDiagnose.m
            |- run_ZcreateFigHistograms.m
            |- run_ZnormalizationParameter.m
        |- figure_scripts/
            |- addpathFolderStructure.m
            |- run_Figure_R1_SSPOCvsRandom.m
            |- run_Figure_R2_disturbance.m
            |- run_Figure_R3_encoderVariation.m
            |- run_Figure_*
        |- functions/
            |- createParListSingle.m
            |- createParListTotal.m
            |- createParSet.m
            |- spa_sf.m  
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