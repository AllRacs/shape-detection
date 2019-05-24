video = VideoReader('video\Sillas_1_2019_lenta.mp4');
final = VideoWriter('GermyVideo.mp4', 'MPEG-4');
%viewer = vision.DeployableVideoPlayer;

open(final);
while hasFrame(video)
    tic;
    img = readFrame(video);
    [img1,img2] = createMask(img);
    cc = bwconncomp(img1);
    L = labelmatrix(cc);
    s = regionprops(L, 'Area', 'Perimeter', 'BoundingBox', 'Extent', 'Eccentricity');
    a = [s.Area];
    b = [s.Perimeter];
    ex = [s.Extent];
    ecc = [s.Eccentricity];
    %triangularidad = (4*pi*a)./(b.*b);
    idx = find(ex>0.3 & ex<0.6 & ecc<0.8 & ecc>0.2 & a>2000);
    bw2 = ismember(L, idx);
    cc2 = bwconncomp(bw2);
    L2 = labelmatrix(cc2);
    s2 = regionprops(L2, 'BoundingBox');
    bounding = [s2.BoundingBox];
    
    si = size(bounding);
    si = si(2);
    nboun = si/4;
    
    bounding2 = zeros(1,4);
    if nboun > 1
        bounding2 = bounding(si-3:si);
    elseif nboun == 1
        bounding2 = bounding;
    end
    
    str = ['Perimetro: ' num2str(max(b)), fprintf('\n') 'Area: ' num2str(max(a))];
    triangulo = insertObjectAnnotation(img, 'Rectangle', bounding2, str, 'FontSize', 20);
    triangulo = insertShape(triangulo, 'Rectangle', bounding2, 'LineWidth', 5);
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
    
    imshow(triangulo);
    writeVideo(final, triangulo);
    for i=1:3
        if hasFrame(video)
            aux = readFrame(video);
            tri = insertObjectAnnotation(aux, 'Rectangle', bounding2, str);
            tri = insertShape(tri, 'Rectangle', bounding2, 'LineWidth', 5);
            writeVideo(final, tri);
        end
    end
    toc
end
close(final);
implay(final);

