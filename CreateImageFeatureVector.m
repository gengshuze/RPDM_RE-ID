
function one_color = CreateImageFeatureVector( rgbIm )
% Creates the features vector for the image 'rgbIm'.

    % Divide the image into 18x1 cells
    xLen = floor( size(rgbIm,1) / 18 );
    subIms = mat2cell( rgbIm, ...
        [xLen, xLen,xLen,xLen,xLen,xLen,xLen,xLen,xLen,...
        xLen,xLen,xLen,xLen,xLen,xLen,xLen,xLen,...
        size(rgbIm,1) - 17*xLen], ...
        size(rgbIm,2), 3 );
    
    
    R_vec = [];
    Y_vec = [];
   
    C_vec = [];
    H_vec = [];
  
    for i=1:numel(subIms)
        [rgbvec,yiqvec,ycbcrvec,hsvvec]= FeatureVector( subIms{i} );
        R_vec = [ R_vec, rgbvec ];
        Y_vec = [ Y_vec, yiqvec ];
        C_vec = [ C_vec, ycbcrvec ];
        H_vec = [ H_vec, hsvvec ];
    end
    one_color=[R_vec H_vec C_vec Y_vec ];
    one_color=one_color';
   
    
end

function [rgbvec,yiqvec,ycbcrvec,hsvvec]= FeatureVector( rgbIm )
%% rgb
    numPixels = numel(rgbIm(:,:,1));

    r = reshape( rgbIm(:,:,1), numPixels, 1 );
    g = reshape( rgbIm(:,:,2), numPixels, 1 );
    b = reshape( rgbIm(:,:,3), numPixels, 1 );
    
    r = double(r) / 255; 
    g = double(g) / 255; 
    b = double(b) / 255; 
   
    rHist = hist( r, linspace(0,1,16) ); 
    gHist = hist( g, linspace(0,1,16) ); 
    bHist = hist( b, linspace(0,1,16) ); 

    rHist = rHist ./ sum(rHist);
    gHist = gHist ./ sum(gHist);
    bHist = bHist ./ sum(bHist);

    rgbvec = [rHist gHist bHist];
    
    %% yiq
     yiqIm = rgb2ntsc( rgbIm );
    numPixels = numel(yiqIm(:,:,1));

    y = reshape( yiqIm(:,:,1), numPixels, 1 );
    i = reshape( yiqIm(:,:,2), numPixels, 1 );
    q = reshape( yiqIm(:,:,3), numPixels, 1 );

    yHist = hist( y, linspace(0,1,16) ); 
    iHist = hist( i, linspace(0,1,16) ); 
    qHist = hist( q, linspace(0,1,16) ); 

    yHist = yHist ./ sum(yHist);
    iHist = iHist ./ sum(iHist);
    qHist = qHist ./ sum(qHist);

    yiqvec = [yHist iHist qHist];
    
    %% ycbcr
     ycbcrIm = rgb2ycbcr( rgbIm );
    numPixels = numel(ycbcrIm(:,:,1));

    yc = reshape( ycbcrIm(:,:,1), numPixels, 1 );
    bc = reshape( ycbcrIm(:,:,2), numPixels, 1 );
    r = reshape( ycbcrIm(:,:,3), numPixels, 1 );
    
    yc = double(yc) / 255; 
    bc = double(bc) / 255; 
    r = double(r) / 255; 

    ycHist = hist( yc, linspace(0,1,16) ); 
    bcHist = hist( bc, linspace(0,1,16) ); 
    rHist = hist( r, linspace(0,1,16) ); 

   
    ycHist = ycHist ./ sum(ycHist);
    bcHist = bcHist ./ sum(bcHist);
    rHist = rHist ./ sum(rHist);

    ycbcrvec = [ycHist bcHist rHist];
    %% hsv
    hsvIm = rgb2hsv( rgbIm );
    numPixels = numel(hsvIm(:,:,1));

    h = reshape( hsvIm(:,:,1), numPixels, 1 );
    s = reshape( hsvIm(:,:,2), numPixels, 1 );
    v = reshape( hsvIm(:,:,3), numPixels, 1 );

    hHist = hist( h, linspace(0,1,16) ); 
    sHist = hist( s, linspace(0,1,16) ); 
    vHist = hist( v, linspace(0,1,16) ); 

    
    hHist = hHist ./ sum(hHist);
    sHist = sHist ./ sum(sHist);
    vHist = vHist ./ sum(vHist);

    hsvvec = [hHist sHist vHist];


end

