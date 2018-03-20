function [ accuracy, w_sspoc ] = sensorLocClassifySTD(  sensors,Xtrain,Gtrain,Xtest,Gtest )
%[ accuracy ] = SensorLocClassify(  sensors,Xtrain,Gtrain,Xtest,Gtest )
% 
% Neural inspired sensors enable sparse, efficient classification of spatiotemporal data
% Mohren T.L., Daniel T.L., Brunton S.L., Brunton B.W.
%   Last updated: 2018/01/16  (TM)
%------------------------------

    n =  size(Xtest,1);
    classes = unique(Gtest); 
    c = numel(classes); 
    q = length(sensors);

    Phi = zeros(q, n);                                      % construct the measurement matrix Phi
    for qi = 1:q,
        Phi(qi, sensors(qi)) = 1;
    end;
    % learn new classifier for sparsely measured data
    w_sspoc= LDA_n(Phi * Xtrain, Gtrain);
    Xcls = w_sspoc' * (Phi * Xtrain);

    % compute centroid of each class in classifier space
    centroid = zeros(c-1, c);
    s_dev = zeros(c-1, c);
    for i = 1:c, 
        centroid(:,i) = mean(Xcls(:,Gtrain==classes(i)), 2);
        s_dev(:,i) = std(Xcls(:,Gtrain==classes(i)));
    end;
    % use sparse sensors to classify X
    cls = classify_ncSTD(Xtest, Phi, w_sspoc, centroid, s_dev);            % NOTE: if Jared's is used, multiple outputs!
    accuracy =  sum(cls == Gtest)/numel(cls);

end

