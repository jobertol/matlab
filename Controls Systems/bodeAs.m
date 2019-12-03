%Bode Plot Asymptote Function - Monovariable Transferfunctions

function bodeAs(sys,wLow,wHigh)

    % Parameters for Graph Aesthetics
    lineWidth = 0.5;
    dottedWidth = 1;
    dotColor = 'g';
    asymColor = 'r';
    markSize = 5;

    % bodeAs() corresponds to bode()
    % Call as asymp(h) or asymp(h,wmin,wmax)
    if nargin == 3
        bode(sys,{wLow,wHigh});
    elseif nargin == 1
        bode(sys);
    else
        error('arguments must be either ''h'' -- or ''h,wmin,wmax''');
    end

    % Extract Transfer Function Information
    [num,den] = tfdata(sys,'v');
    if nargin == 3
        [mag,phase,w] = bode(sys,{wLow,wHigh});
    elseif nargin == 1
        [mag,phase,w] = bode(sys);
    end

    % Remove Dimensions of 1 from Input Matricies
    mag = 20.*log10(squeeze(mag));
    phase = squeeze(phase);


    % Degree of denominator polynomial
    denDeg = length(den)-1;
    k = denDeg+1;
    while den(k) == 0
        k = k-1;
    end

    % Number of pure integrators (if any)
    denIntegr = denDeg+1-k;
    % Order of denominator and denominator ignoring integrators
    den = den(1:denDeg+1-denIntegr);
    denDeg = k-1;
    % Remove possible higher order term zero coefficients in nominator
    k = 1;
    while num(k) == 0
        k = k+1;
    end
    numDeg = length(num)-k;
    num = num(k:k+numDeg);
    % Find order of remaining nominator polynomial and number of pure derivators (if any)
    k = numDeg+1;
    while num(k) == 0
        k = k-1;
    end
    numDeriv = numDeg+1-k;
    num = num(1:numDeg+1-numDeriv);
    numDeg = k-1;

    % Total zero frequency gain ignoring integrators and derivators
    gain = num(length(num))/den(length(den));

    % Account for negative gain (if any)
    gain = abs(gain);

    % Find left start points for amplitude and phase
    magStart = 20*log10(gain/w(1)^(denIntegr-numDeriv));
    phaStart = 90*round(phase(1)/90);

    % Initial slope for magnitude
    magSlopeAccum = -20*(denIntegr-numDeriv);

    % Roots of remaining numerator and denominator
    zeroes = roots(num);
    poles = roots(den);

    % Putt all roots in one long row vector with zeroes first
    zp = [zeroes',poles'];

    % Find change in magnitude and phase due to each zero (if any)
    if numDeg > 0
        dmag(1:numDeg) = 20*ones(1,numDeg);
        dph(1:numDeg) = 90*(round(2*((real(zeroes) < 0)-0.5)));
    end

    % Find change in magnitude and phase due to each pole (if any)
    dmag(numDeg+1:numDeg+denDeg)= -20*ones(1,denDeg);
    dph(numDeg+1:numDeg+denDeg)= 90*(round(2*((real(poles) > 0)-0.5)));

    % Find and sort break frequencies
    % Original order of zerpoles, dmag and dph is still kept
    [freqPoints,ord] = sort(abs(complex(real(zp),imag(zp))));

    % Add first and last frequency point for plot
    freqPoints = [w(1),freqPoints,w(end)];
    np = length(freqPoints);

    % Allocate vectors for mag and phase plots
    magPoints=ones(1,np);
    phaPoints=ones(1,2*(np-1));

    % Initial points that are to be plotted later:
    magPoints(1) = magStart;
    phaPoints(1) = phaStart;
    phaPoints(2) = phaStart;

    % Find remaining points for mag and phase plots
    for k = 2:np
        if k > 2
    %       Update accumulated slope
            magSlopeAccum = magSlopeAccum+dmag(ord(k-2));
        end
    %   Calculate magnitude points
        magPoints(k) = magPoints(k-1)+ magSlopeAccum*log10(freqPoints(k)/freqPoints(k-1));
    %   Calculate phase points
        if k < np
            phaPoints(2*k-1) = phaPoints(2*k-2)+dph(ord(k-1));
            phaPoints(2*k) = phaPoints(2*k-1);
        end
    end
    % Make the magintude axes current, and plot there
    h = get(findall(get(gcf,'Children'),'String','Magnitude (dB)'),'Parent');
    axes(h);
    hold on;
    grid;
    plot(w,mag,'LineWidth',lineWidth);
    magMax = max([magPoints,mag']); magMin=min([magPoints,mag']);
    ySpan = magMax-magMin;
    for yDelta = [2 4 10 20 40]
        yhlp = ySpan/yDelta;
        if yhlp < 8
            break;
        end
    end
    magMin=yDelta*floor(magMin/yDelta); magMax=yDelta*ceil(magMax/yDelta);
    if magMin == magMax
        magMin = magMin-2; magMax=magMax+2;
    end
    magLimitIncr = (magMax-magMin)*0.02;
    set(get(gcf, 'CurrentAxes'),'YTick',magMin:yDelta:magMax);
    set(get(gcf, 'CurrentAxes'),'YLim',[magMin magMax]);
    yScaleMag = axis;
    yScaleMag(3) = magMin-magLimitIncr;
    yScaleMag(4) = magMax+magLimitIncr;
    axis(yScaleMag);

    % Magnitude asymptote plot on top of magnitude part of Bode diagram
    plot(freqPoints(2:np-1),magPoints(2:np-1),'Marker','.','LineStyle','-','Color',asymColor,'MarkerSize',markSize,'LineWidth',lineWidth);

    % No dots at start and end points
    plot(freqPoints(1:2),magPoints(1:2),'LineStyle','-','Color',asymColor,'LineWidth',lineWidth);
    plot(freqPoints(np-1:np),magPoints(np-1:np),'LineStyle','-','Color',asymColor,'LineWidth',lineWidth);

    % Label Key Frequencies
    yMarkers = yScaleMag(3:4);
    keyVals = unique(freqPoints(2:np-1),'stable');
    counter = 0;
    for i=1:length(keyVals)
        yVals = [yMarkers(1) yMarkers(2)];
        xVals = [keyVals(i) keyVals(i)];
        plot(xVals,yVals,'LineStyle',':','Color',dotColor,'LineWidth',dottedWidth);
        text(keyVals(i),(yMarkers(1)*(0.7+0.2*counter)),sprintf('%.2f',keyVals(i)),'FontSize',7);
        counter = mod(counter+1,2);
    end
    hold off;

    % Phase asymptote plot on top of phase part of Bode diagram
    % First make the phase axes current, and plot grid
    h = get(findall(get(gcf,'Children'),'String','Phase (deg)'),'Parent');
    axes(h);
    hold on;
    grid;

    % Re-scale phase diagram
    phMax = max([phaPoints,phase']); phMin=min([phaPoints,phase']);
    ySpan = phMax-phMin;
    for yDelta = [10 15 30 45 90 180]
        yhlp = ySpan/yDelta;
        if yhlp < 8
            break;
        end
    end
    phMin = yDelta*floor(phMin/yDelta); phMax=yDelta*ceil(phMax/yDelta);
    if phMin == phMax
        phMin = phMin-45; phMax=phMax+45;
    end
    phLimitIncr = (phMax-phMin)*0.02;
    set(get(gcf, 'CurrentAxes'),'YLim',[phMin phMax]);
    yScalePh = axis;
    yScalePh(3) = phMin-phLimitIncr;
    yScalePh(4) = phMax+phLimitIncr;
    axis(yScalePh);

    % Generate more frequency points for vertical lines
    freqPoints = sort([freqPoints(1:np-1),freqPoints(2:np)]);
    np = length(freqPoints);
    plot(freqPoints(2:np-1),phaPoints(2:np-1),'r.-','MarkerSize',markSize,'LineWidth',lineWidth);

    % No dots at start and end points
    plot(freqPoints(1:2),phaPoints(1:2),'r-','LineWidth',lineWidth);
    plot(freqPoints(np-1:np),phaPoints(np-1:np),'r-','LineWidth',lineWidth);
    set(get(gcf, 'CurrentAxes'),'YTick',phMin:yDelta:phMax);

    % Convert frequency axis to decimal numbers:
    x = get(gca, 'XTickLabel');
    x = strrep(x,'{',''); x = strrep(x,'}','');
    for i=1:length(x)
        x{i} = num2str(str2num(x{i}));
    end
    set(gca, 'XTickLabel',x);
    grid;
    hold off;
end
