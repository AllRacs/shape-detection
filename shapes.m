video = VideoReader('Sillas_1_2019_lenta.mp4');
final = VideoWriter('GermyVideo7grfffgkdffff5tgfrtd6.avi', 'MPEG-4');
%viewer = vision.DeployableVideoPlayer;
open(final);
tic;
while hasFrame(video)
    img = readFrame(video);
    [img1,img2] = createMask(img);
    cc = bwconncomp(img1);
    L = labelmatrix(cc);
    s = regionprops(L, 'Area', 'Perimeter', 'BoundingBox', 'Extent', 'Eccentricity');
    a = [s.Area];
    %b = [s.Perimeter];
    ex = [s.Extent];
    ecc = [s.Eccentricity];
    %triangularidad = (4*pi*a)./(b.*b);
    idx = find(ex>0.3 & ex<0.6 & ecc<0.8 & ecc>0.2 & a>2000);
    bw2 = ismember(L, idx);
    cc2 = bwconncomp(bw2);
    L2 = labelmatrix(cc2);
    s2 = regionprops(L2, 'BoundingBox');
    bounding = [s2.BoundingBox];
    lengthB = size(bounding);
    numObj = lengthB/4;
    numObj(2)
    if numObj(2) == 1 
        triangulo = insertShape(img,'Rectangle', bounding, 'LineWidth', 5);
        %depVideoPlayer(triangulo);
		hImage = subplot(2, 2, 1);
        title('Detección Triangulo RGB');
		imshow(triangulo);
        hImageB = subplot(2, 2, 2);
        title('Detección Formas');
		imshow(img1);
        hImageB2 = subplot(2, 2, 3);
        title('Detección Triangulo BW');
        imshow(bw2);
		drawnow; % Refrescar.
        writeVideo(final, triangulo);
    elseif numObj(2) > 1
        triangulo = insertShape(img,'Rectangle', [bounding(5) bounding(6) bounding(7) bounding(8)], 'LineWidth', 5);
        %depVideoPlayer(triangulo);
		hImage = subplot(2, 2, 1);
        title('Detección Triangulo RGB');
		imshow(triangulo);
        hImageB = subplot(2, 2, 2);
        title('Detección Formas');
		imshow(img1);
        hImageB2 = subplot(2, 2, 3);
        title('Detección Triangulo BW');
        imshow(bw2);
		drawnow; % Refrescar.
        writeVideo(final, triangulo);
    elseif numObj(2) == 0
        %depVideoPlayer(img);
		hImage = subplot(2, 2, 1);
        title('Detección Triangulo RGB');
		imshow(img);
        hImageB = subplot(2, 2, 2);
        title('Detección Formas');
		imshow(img1);
        hImageB2 = subplot(2, 2, 3);
        title('Detección Triangulo BW');
        imshow(bw2);
		drawnow; % Refrescar.
        writeVideo(final, img);
    end
end
toc
close(final);
implay(final);


