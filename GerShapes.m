video = VideoReader('Sillas_1_2019_lenta.mp4');
final = VideoWriter('GermyVideo.mp4', 'MPEG-4');
open(final);
for i=1:1:900
   img = read(video, i);
    imgGris = rgb2gray(img);
    bw = im2bw(imgGris, [150/255]);
    comp = imcomplement(bw);
    cc = bwconncomp(comp);
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
    triangulo = insertShape(img,'Rectangle', bounding, 'LineWidth', 5);
    imshow(triangulo);
    writeVideo(final, triangulo);
end
close(final);
play(final);