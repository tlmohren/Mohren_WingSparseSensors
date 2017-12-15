% renaming script


location = 'D:\Mijn_documenten\Dropbox\A_PhD\C_Papers\ch_Wingsensors\Mohren_WingSparseSensors\accuracyData'
startName = 'Data_Data_R1_Iter100_run1'

nameMatches = dir( [location filesep startName '*'])

for j = 1:length(nameMatches)
    nameMatches(j).name
    ind = strfind(nameMatches(j).name, 'dT')
    newName = [nameMatches(j).name(6:21) nameMatches(j).name(27:end) ]
%     movefile( [location filesep nameMatches(j).name ],...
%         [location filesep newName ] )
end