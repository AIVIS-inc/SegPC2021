function BW_nu = labelChose(nuSet, pixel_labels, img_ab)
% he: input image, nuSet: binary segmentation result of nucleus. 
se = strel('disk',20);
% Change to hsv space
img_hsv = rgb2hsv(img_ab);
saturation = img_hsv(:,:,2);

%Based on the value of saturation, classify the nucleus in the image.
saturation = im2single(saturation);
nuImg = saturation .* nuSet;
mnz = mean(nonzeros(nuImg));


mask1 = pixel_labels==1;
color_Mask1 = saturation .* mask1;
mnz_Mask1 = mean(nonzeros(color_Mask1));

mask2 = pixel_labels==2;
color_Mask2 = saturation .* mask2;
mnz_Mask2 = mean(nonzeros(color_Mask2));

mask3 = pixel_labels==3;
color_Mask3 = saturation .* mask3;
mnz_Mask3 = mean(nonzeros(color_Mask3));

% Compare the average saturation value of nucleus with that of each label obtained via "imsegkmeans".
% The label with smallest difference is recognized as nucleus. 
absDiff = [abs(mnz -mnz_Mask1), abs(mnz -mnz_Mask2), abs(mnz -mnz_Mask3)]
[val, idx] = min(absDiff);

if idx==1
    BW = imopen(mask1, se);
    BW_nu = imfill(BW, 'holes');
elseif idx==2
    BW = imopen(mask2, se);
    BW_nu = imfill(BW, 'holes');
else
    BW = imopen(mask3, se);
    BW_nu = imfill(BW, 'holes');
end