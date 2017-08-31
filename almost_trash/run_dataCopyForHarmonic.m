% Data copy for harmonic 


    [dataDirectory,baseName] = fileparts(pwd);
    simLocation = [dataDirectory filesep baseName,'Data'];
    simLocationNameBase = [simLocation filesep 'strainSet_*'];
    
    matches = dir(simLocationNameBase)
    
    for j = 1:length(matches)
       I = strfind( matches(j).name ,'cEl');
        matches(j);
        
        
       if ~isempty(I)
           matches(j).name;
           j
           
           movefile( [simLocation filesep matches(j).name ] ,...
              [simLocation filesep matches(j).name(1:I-1) 'harm0.2.mat' ])
%            load( [simLocation filesep matches(j).name ] )
%            save( [simLocation filesep matches(j).name(1:I-1) 'harm0.2.mat' ])
       end
       
    end