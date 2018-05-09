%% Constants
OFFSET = 100;
FNAME = 'C:\tmp\hood.tif';

%% Download and Resize
hood = importdata(FNAME);
[m,n]=size(hood);
X = hood(1+OFFSET:m-OFFSET,1+OFFSET:n-OFFSET);
sX = imresize(X,[100,100]);

%% Export Data as 100x100 Json
fid = fopen('mthood.json','w+t');
fprintf(fid,'{"width":100,"height":100,"values":[');
fprintf(fid,'%i,',sX(1:end-1));
fprintf(fid,'%i]}',sX(end));
fclose(fid);

%% Plot Data
figure(1);clf
subplot(2,1,1);
imagesc(X);
hold on
contour(X,20,'k');
axis equal

subplot(2,1,2);
imagesc(sX);
hold on
contour(sX,20,'k');
axis equal