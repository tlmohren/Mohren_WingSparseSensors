function [ ] = plot_modes( U, x, y, r, params )
% plot_modes
%   Visualize the first r modes of the singular value decomposition.

height = int8(2);
width = idivide(r, height, 'ceil');

figure;
hold on, colormap jet
for i=1:r
    subplot(double(height), double(width), i)
    mode = reshape(U(:, i), [params.Lx, params.Ly]);              % ith strain eigenmode
    surf(x', y', mode, 'Edgecolor', 'none')
    axis([-params.a params.a 0 2*params.b -1 1])    % set axis limits
    title(['Mode ', num2str(i)]);
    box off, grid off, axis on, shading interp
    view([0, 90])                                   % Top down view
    
    colorbar
end



end

