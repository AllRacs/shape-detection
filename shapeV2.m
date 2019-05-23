video = VideoReader('video\Sillas_1_2019_lenta.mp4');
% opticFlow = opticalFlowFarneback;
final = VideoWriter('shapedetection.mp4', 'MPEG-4');
open(final);
cont = 0;
while hasFrame(video)
    tic
    img = readFrame(video);
%     imgGris = rgb2gray(img);
%     bw = im2bw(imgGris, [150/255]);
%     comp = imcomplement(bw);
    [bw, bb] = rgbfunctionBlue(img);
    cc = bwconncomp(bw);
    L = labelmatrix(cc);
    s = regionprops(L, 'Area', 'Perimeter');
    a = [s.Area];
    b = [s.Perimeter];
    triangularidad = (4*pi*a)./(b.*b);
    idx = find(triangularidad>0.6 & triangularidad<0.7 & a>2000);
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
    
    imshow(triangulo);
    writeVideo(final, triangulo);
%     for i=1:3
%         if hasFrame(video)
%             aux = readFrame(video);
%             tri = insertObjectAnnotation(aux, 'Rectangle', bounding2, str, 'FontSize', 20);
%             tri = insertShape(tri, 'Rectangle', bounding2, 'LineWidth', 5);
%             writeVideo(final, tri);
%         end
%     end
    toc
end
close(final);
