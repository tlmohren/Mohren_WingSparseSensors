function [ output_args ] = plot_sensorlocs( binar)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% binar = zeros(1326,1);
% for j = 1:size(Sloc,2)
%     sensors = Sloc(:,j);
%     binar(sensors)  = binar(sensors) + 1;
% end
% binar = binar/size(Sloc,2);
% binar = get_pdf(Sloc);

sensor_locs = reshape(binar,26,51); 
[Xl,Yl]= meshgrid(1:51,1:26);

% ---------------
% figure()
    imshow((1-sensor_locs), 'InitialMagnification', 'fit')
    set(gca,'YDir','normal')

    rectangle('Position',[0.5,0.5,51,26])
%     sensor_locsnew = sensor_locs;
% sensor_locsnew(1:50) = 0;
% sensor_locs
%     sensor_locsnew 3
    
    
%     
%     
% figure()
%     hold on 
%     pcolor(Xl,Yl,(1-sensor_locs))
% %     pcolor(Xl,Yl,(sensor_locs))
%             h = gca;
% % %     scatter(sensor_locs)
% %     rectangle('Position',[1,1,51,25])
% %     get(h,'YtickLabel' );
% %     set(h,'YtickLabel','_');
% %     set(h,'YtickLabelRotation',30);
% %     get(h,'Ytick');
% %     set(h,'YTick',(7:6:25)+1);
% %     set(h,'XtickLabel',[])
% %     set(h,'fontsize',60)
% % %     shading interp
%     shading flat 
% %             colormap(flipud(gray))
% %     %  shading faceted
%     colormap((gray))
%     axis equal
%     axis([1,52,1,26])



    
%             pcolor(Xl,Yl,(sensor_locs/iters))
%             hold on 
%             rectangle('Position',[1,1,51,25])
%             %    ylabel(['q',num2str(q),' r=',num2str(ideal_modes)])
%             h = gca;
%             get(h,'YtickLabel' );
%             set(h,'YtickLabel','_');
%             set(h,'YtickLabelRotation',30);
%             get(h,'Ytick');
%             set(h,'YTick',(7:6:25)+1);
%             set(h,'XtickLabel',[])
%             set(h,'fontsize',40)
%         %     set(h,'fontsize',30)
%             shading flat
%             colormap(flipud(gray))
%             axis equal
%             axis([1,52,1,26])
%             g = colorbar;
%             set(g,'fontsize',15)
%             ylabel(g,'Placement likelyhood')
%             hold off






end

