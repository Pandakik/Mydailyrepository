
fig_ = image;


            img_adjust = imadjust(fig_,[0.65;0.7],[0,1]);
            %h = fspecial('motion',4.4);
            h=fspecial('gaussian',200);%?¸ßË¹ÂË²¨
            img_im= imfilter(img_adjust,h);
            IM2 = im2bw(img_im);      
             B=[0 1 0
               1 1 1
              0 1 0];
            %             SE = strel('line',20,90);
            IM2=imdilate(IM2,B);
            IM2 = imerode(IM2,B);
            IM2 = imerode(IM2,B);
            IM2 = imfilter(IM2 ,h);
            IM2 = imfilter(IM2 ,h);
            IM2 = imerode(IM2,B);
              IM2 = imfilter(IM2 ,h);
                IM2 = imfilter(IM2 ,h);
                
                
img_reg = regionprops(IM2,  'area', 'boundingbox');
areas = [img_reg.Area];
rects = cat(1,  img_reg.BoundingBox);
for i = 1:size(rects, 1)
    if areas(i)>50
   rectangle('position', rects(i, :), 'EdgeColor', 'r');
    end
end   