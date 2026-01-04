%%% This part is to assign tracks in nuclear area; the section below to
%%% visualize tracks falling the selected nuclear area.
% Inputdata= "nuc" This is output of c1_nuc_dapipoor_spk.m, and
%%%"tracksFinal" This is output of UTrack.
%%%%%%DRAW tracks
trackslongerthan=2; % change this to select minimum length of track 
last=length(tracksFinal);

total_d1=nan(length(tracksFinal),1);
track_loc=cell(length(tracksFinal),1);
trk_loc_ratio=zeros(length(tracksFinal),4);

 % test_spk_in_nuc = nuc;
  test_spk_in_nuc = nuc;
for i5=1:last %length(tracksFinal)
   
    clear xcoord ycoord tracktobeshown d1 location 
    tr=tracksFinal(i5).tracksCoordAmpCG;
    D1(i5,1)=length(tr)/8;  
    
    if D1(i5,1)>trackslongerthan % && (sum(isnan(tr(1,:)))/8)/D1(i5,1)<0.16 %number of points in the track.
        %Basically no extraordinary big step (assumed to be an link error 
     
         tracktobeshown=tracksFinal(i5).tracksCoordAmpCG;
            
             for i6=1:D1(i5,1)
                  xcoord(i6,1)=tracktobeshown(1,1+8*(i6-1));
                  ycoord(i6,1)=tracktobeshown(1,2+8*(i6-1));     
             end
             
             
         %%%%make a plot - visualize tracks    
          if any(xcoord<2) && any(ycoord<2)
             wrongtrack{i5}=i5;
          else
              xcoordfilled=fillmissing(xcoord,'previous');
              ycoordfilled=fillmissing(ycoord,'previous');
          
        %spk_in_nuc;
          xcoord1=xcoord(~isnan(xcoord));
          ycoord1=ycoord(~isnan(ycoord));
          
          for ip=1:length(xcoord1)
             location(ip,1)=test_spk_in_nuc(round(ycoord1(ip)),round(xcoord1(ip)));
 
              %trk_loc_ratio(i5,:)=trk_loc_ratio(i5,:)/length(xcoord1);
          end
          
        trk_loc_ratio(i5,1) = sum(location==290)/length(location);
        trk_loc_ratio(i5,2) = sum(location==200)/length(location);
        trk_loc_ratio(i5,3) = sum(location==100)/length(location);
        trk_loc_ratio(i5,4) = sum(location==0)/length(location);
          % 0 =out of cell, 100 =in spk, 190 = nucleoplasm.
          %imshow(test_spk_in_nuc,[])
        
 
          end
    n=length(find(D1>trackslongerthan)) ;   
    end
end  
save([path fname '_trk_loc_ratio.mat'],'trk_loc_ratio')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% [Option] for track visualization, choose inout= 1/2/3/4, in spk=1, in dna channel =2,  nucleoplasm =3, out of nuc =4

l=cool(length(tracksFinal));
for inout=2;%in spk=1, in dna channel =2,  nucleoplasm =3, out of nuc =4
    range=0.8;
    clear trk
    figure, imshow(nuc,[])
  %  figure, imshow(Inew,[])  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%,,
    trk=find(trk_loc_ratio(:,inout)>=range); %outof spk
    %trk=find(trk_loc_ratio(:,1)==1); %in spk
    for i0=1:length(trk)
        i=trk(i0);
    clear xcoord0 ycoord0 d1
    tracktobeshown=tracksFinal(i).tracksCoordAmpCG;
    nframe=length(tracktobeshown)/8.;
    length_oftrack(i)=nframe;
        for i2=1:nframe
            xcoord0(i2,1)=tracktobeshown(1+8*(i2-1));
            ycoord0(i2,1)=tracktobeshown(2+8*(i2-1));
        end

         xcoord=xcoord0(~isnan(xcoord0));
         ycoord=ycoord0(~isnan(ycoord0));

         for i3=1:length(xcoord)-1
              dX=xcoord(i3,1)-xcoord(i3+1,1);
              dY=ycoord(i3,1)-ycoord(i3+1,1);
              d1(i3,1)=sqrt(dX^2+dY^2)      ;
         end

         if sum(d1>=7)>0 % 18 pixel =~2um
           % i=i 
         else
            hold on
            plot(xcoord, ycoord,'LineWidth',1,'Color',l(i,:)) 
            hold on, plot(xcoord(1,1), ycoord(1,1),'o', 'MarkerFaceColor','g','MarkerSize',2)
            %         subplot(1,2,2), plot(xcoord, ycoord,'LineWidth',1, 'MarkerEdgeColor', [0.5 0.1470 0.9410]) 
            %         axis([0 256 0 256])
         end

    end

    %savefig(gcf, [path 'tracks_nuc' num2str(inout) '.fig'])
    
end
%%
f=gcf
    axis off
    set(gca, 'LooseInset',get(gca,'TightInset'));

    exportgraphics(f, [path fname 'Alltracks_loc' num2str(inout) 'zoomin_.tif'], 'Resolution', 400, 'BackgroundColor', 'none')
  
