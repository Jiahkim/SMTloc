%This m-file is to make a segemented image of NS, Interchromatin,
%Chromatin area.
%Next m-file to use "c2_track_loc.m" that sort tracks based on this segmented image.
path='folder directory';
fname='file name';
level1=0.6; %To select chromatin-dense region
level2=0.7; %To select nucleus area
level3=0.7; %To select NS(speckle) area
%%[DNA image]
img=double(imread([path fname '.tif'],1)); % time-projection of DNA and NS
img_blur=imgaussfilt(img,0.5);
T=adaptthresh(img_blur, 0.06);%0.07
BW0dna = imbinarize(img_blur,T*level1);%76);%76);%
%imshow(BW0dna,[]) %This could be on/off to see segmented area.
%%
%%%%%%[Nuc boundary]%%%%%%%%%%%%%%%%%%%%%%
% img_blur=imgaussfilt(uint16(img),2);
% T=adaptthresh(img_blur, 0.005);%0.07
% nuc_bd = imbinarize(img_blur,T*0.8);%76);%76);%63);
img_blur=imgaussfilt(img,2);
Tgr=graythresh(img_blur)
nuc_bd = imbinarize(img_blur,Tgr*level2);imshow(nuc_bd)%1.1);
nuc_bd1 = bwareaopen(nuc_bd, 5000);
nuc_bd2=imfill(nuc_bd1, 'holes');
figure,imshow([nuc_bd1 nuc_bd2],[])
% %%alternative way1
% BW0dna1 = imbinarize(img_blur,T*0.8);
% remv =imfill(BW0dna1, 'holes');
% nuc_bd2 = bwareaopen(remv, 5000);
% imshow([remv nuc_bd2],[])
%%
%%[Speckle image]%%%%%%%%%%%%%%%%%%%%%%
%img0 = double format
img0=double(imread([path fname '.tif']),2);
spk1 = imadjust(rescale(rescale(imgaussfilt(img0,0.5)),[0 0.4]),[],[],1.2);
SENSITIVITY=0.5;%0.05; %0.1 %increse SENSITIVITY, detect background signals& broad spk area.
T=adaptthresh(spk1, SENSITIVITY);
BW0spk = imbinarize(spk1,T*level3);%78);%0.85
BW1spk=imfill(BW0spk, 'holes');imshow(BW1spk,[])
BW1spk(find(nuc_bd2==0))=0;
BW2spk = bwareaopen(BW1spk, 5);
imshow(BW2spk,[])
%%
BW0dna1=BW0dna-nuc_bd2;
canvas=zeros(size(img));
canvas(find(BW0dna1<0))=1;
canvas2 = bwareaopen(canvas,50);
imshow(canvas2,[])
%%
% BW2spk_rem=BW2spk-imcomplement(nuc_bd2);
% BW2spk(find(BW2spk_rem<1))=0;

spk=BW2spk;
dapipoorregion=canvas2;
nucbd=nuc_bd2;
save([path fname '_spk.mat'],'spk')
save([path fname '_dapipoorregion.mat'],'canvas2')
save([path fname '_nucbd.mat'],'nuc_bd2')

nuc=nucbd*100;%[1]
nuc(find(dapipoorregion==1))=200;%[2]
nuc(find(spk==1))=290;

save([path fname '_final_nuc.mat'],'nuc')
imshow(nuc,[])
