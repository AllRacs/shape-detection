video = VideoReader('video\Sillas_1_2019_lenta.mp4');
final = VideoWriter('vprocesado.mp4', 'MPEG-4');
open(final);

while hasFrame(video)
    tic;
    
    img = readFrame(video);
    [img1,img2] = createMask(img);
    
    cc = bwconncomp(img1);
    L = labelmatrix(cc);
    s = regionprops(L, 'BoundingBox', 'Area', 'Extent', 'Eccentricity');
    a = [s.Area];
    ex = [s.Extent];
    ecc = [s.Eccentricity];
   
    idx = find(ex>0.3 & ex<0.6 & ecc<0.8 & ecc>0.2 & a>2000);
    bw2 = ismember(L, idx);
    cc2 = bwconncomp(bw2);
    L2 = labelmatrix(cc2);
    s2 = regionprops(L2, 'BoundingBox', 'Area', 'Perimeter', 'Centroid');
    
    bounding = [s2.BoundingBox];
    a = [s2.Area];
    b = [s2.Perimeter];
    cen = [s2.Centroid];
    cen(1,3) = 2;
    scen = size(cen);
    
    si = size(bounding);
    si = si(2);
    nboun = si/4;
    
    bounding2 = zeros(1,4);
    if nboun > 1
        bounding2 = bounding(si-3:si);
        cen = cen(scen(2)-1:scen);
    elseif nboun == 1
        bounding2 = bounding;
    end
    
    str = ['Perimetro: ' num2str(max(b)), fprintf('\n') 'Area: ' num2str(max(a))];
    triangulo = insertObjectAnnotation(img, 'Rectangle', bounding2, str, 'FontSize', 20);
    triangulo = insertShape(triangulo, 'Rectangle', bounding2, 'LineWidth', 5);
    triangulo = insertShape(triangulo, 'Circle', cen, 'LineWidth', 5, 'color', 'red');
    
    hImage = subplot(2, 2, 1);
    imshow(triangulo);
    title('Detección Triangulo RGB');
    
    hImageB = subplot(2, 2, 2);
    imshow(img1);
    title('Detección Formas');
    
    hImageB2 = subplot(2, 2, 3);
    imshow(bw2);
    title('Detección Triangulo BW');
    drawnow; % Refrescar.
    
    writeVideo(final, triangulo);
    
    for i=1:3
        if hasFrame(video)
            aux = readFrame(video);
            tri = insertObjectAnnotation(aux, 'Rectangle', bounding2, str, 'FontSize', 20);
            tri = insertShape(tri, 'Rectangle', bounding2, 'LineWidth', 5);
            tri = insertShape(tri, 'Circle', cen, 'LineWidth', 5, 'color', 'red');
            
            writeVideo(final, tri);
        end
    end
    
    toc
end

close(final);
