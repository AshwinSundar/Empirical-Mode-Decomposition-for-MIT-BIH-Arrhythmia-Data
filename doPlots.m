function doPlots( xin, originalData, titleString, timeOffset )

%DOPLOTS Create plots from EMD calculation
%   Detailed explanation goes here

    close    

    m = size(xin,1);
    n = size(xin,2);

    % ScreenSize vector is [left bottom width height]
    %
    % h is the figure handle
    
    scrsz = get(groot,'ScreenSize');   
    h = figure('Name',titleString,'NumberTitle','off', 'PaperType', 'A', 'Position', [1 1 scrsz(3)/2 scrsz(4)], 'InvertHardcopy', 'off'); % create new figure

    xvals = 0:n-1;
    xvals = timeOffset + xvals / 360.;
    
    yAxisLimit = max(max(xin));
    
    goldStd_020007 = [0.79 2.35; 5.97 7.93; 11.32 12.84; 17.13 18.82; 22.73 24.32; 27.17 29.18; 33.12 34.89; 38.81 40.26; 44.49 46.14; 49.40 50.99; 55.60 56.95];
    lowerBar = [0.79 0.79 5.97 5.97 11.32 11.32 17.13 17.13 22.73 22.73 27.17 27.17 33.12 33.12 38.81 38.81 44.49 44.49 49.40 49.40 55.60 55.60];
    upperBar = [2.35 2.35 7.93 7.93 12.84 12.84 18.82 18.82 24.32 24.32 29.18 29.18 34.89 34.89 40.26 40.26 46.14 46.14 50.99 50.99 56.95 56.95];
    
    barCenter = (upperBar + lowerBar) / 2.;
    barHeight = barCenter;
    for i1 = 1:size(barHeight)
        barHeight(i1) = (-1)^i1 * yAxisLimit;
    end
        
    rows = double(idivide( int8(m+2), int8(2), 'ceil'));
    for i = 1:m
        
        yout1 = xin(i,:);

        subplot(rows,2,i);
        p1 = plot(xvals, xin(i,:), barCenter, barHeight, '-^r');
        p1(2).LineWidth = 3;
        
        if i == m
            str = sprintf('Residual');
        else
            str = sprintf('Mode %d',i);
        end
        
        title(str);
        axis([timeOffset,timeOffset+1,-yAxisLimit,yAxisLimit]);
    end
        
    subplot(rows,2,2*rows);
    plot(xvals, originalData);
    
    title('Original');
    axis([timeOffset,timeOffset+1,-yAxisLimit,yAxisLimit]);
    xlabel('time (s)') 
    %ylabel('Amplitude') 
    
    startMode = 7;
    endMode = 10;
    
    reconstructed = xin(endMode,:);
    for j = startMode:endMode-1
        reconstructed = reconstructed + xin(j,:);
    end
    
    subplot(rows,2,2*rows-1);
    plot(xvals, reconstructed);

    str = sprintf('Reconstructed (modes %d to %d)',startMode, endMode);
    title(str);
    axis([timeOffset,timeOffset+1,-yAxisLimit,yAxisLimit]);
    xlabel('time (s)') 
    %ylabel('Amplitude') 
    
    %print('-depsc', '-r300', titleString)
    print(h, titleString, '-dpng')
end

