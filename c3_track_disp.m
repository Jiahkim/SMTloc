%Need data " trk_loc_ratio", "tracksFinal"
%Assign trackslongerthan (lenth of tracks), inout (nuclear region)
%This m-file generates histograme of per-frame displacement that you can
%export for fitting to extract Diffusion coefficient.
%%%%%%%%%%%%%%%%%%%%%%
%figure, imshow(Inew,[])
%%
trackslongerthan=2;
for inout=1:3 %in spk=1, in dna channel =2,  nucleoplasm =3, out of nuc =4
    clearvars -except tracksFinal trk_loc_ratio path inout trackslongerthan
    
    trk=find(trk_loc_ratio(:,inout)>=range); %outof spk
    msd_coll=nan(500, length(trk));
    %trk=find(trk_loc_ratio(:,1)==1); %in spk
    length_oftrack=nan(length(trk),1);
    max_traveldist=nan(length(trk),1);
    DiffCoef_coll=nan(length(trk),2);
    total_d1=nan(length(trk),1);
    for i0=1:length(trk)
        i=trk(i0);
        clear xcoord0 ycoord0 d1 xcoord ycoord Theta  dr_msd d1 traveldist
        tracktobeshown=tracksFinal(i).tracksCoordAmpCG;
        nframe=length(tracktobeshown)/8.;
        length_oftrack(i0)=nframe;
   %%%%%%%collect all displacement without filering by trj length     
        for i2=1:nframe
            xcoord0(i2,1)=tracktobeshown(1+8*(i2-1));
            ycoord0(i2,1)=tracktobeshown(2+8*(i2-1));
        end
             xcoord=xcoord0(~isnan(xcoord0));
             ycoord=ycoord0(~isnan(ycoord0));
        
        for Li=1:length(xcoord)-1
             dX=xcoord(Li,1)-xcoord(Li+1,1);
             dY=ycoord(Li,1)-ycoord(Li+1,1);
             d01(Li,1)=sqrt(dX^2+dY^2) ; 
        end
        coll_disp0{i0,1}=d01 ;
        
        
        if length_oftrack(i0)>trackslongerthan && (sum(isnan(tracktobeshown(1,:)))/8)/length_oftrack(i0)<0.16 %number of points in the track.
     
                for i2=1:nframe
                    xcoord0(i2,1)=tracktobeshown(1+8*(i2-1));
                    ycoord0(i2,1)=tracktobeshown(2+8*(i2-1));
                end
                    xcoord=xcoord0(~isnan(xcoord0));
                    ycoord=ycoord0(~isnan(ycoord0));

            %                     hold on
            %                     plot(xcoord, ycoord,'-*','LineWidth',1.5,'MarkerEdgeColor','r') 
            %                     hold on, plot(xcoord(1,1), ycoord(1,1),'o', 'MarkerFaceColor','g')
                          %     subplot(1,2,2), plot(xcoord, ycoord,'LineWidth',1, 'MarkerEdgeColor', [0.5 0.1470 0.9410]) 
                               %axis([0 256 0 256])
        
        end
    end

    clear A
    A=cell2mat(coll_disp)*0.106;
    figure, histogram(A,'Binwidth',0.02) %%% all the displacement in um scale
    A0=cell2mat(coll_disp0)*0.106;
    hold on, histogram(A0,'Binwidth',0.02)
    title(['Location' num2str(inout)])

    tracklength(:,1)=length_oftrack; tracklength(:,2)=max_traveldist;
    save([path 'tracklength_vs_trvdist' num2str(inout) '.mat'], 'tracklength')
    figure, plot(length_oftrack, max_traveldist,'.')
    xlabel('Length numb of points ')
    ylabel('maximum travel distance um')%Frequency')
    title(['Location' num2str(inout)])
   % 
   % save([path 'DiffCoef_coll' num2str(inout) '.mat'], 'DiffCoef_coll') 
   
end    
%%
