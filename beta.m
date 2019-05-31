%Homework3
imageInput = imread('WormHole_2H.tif');

grayImage = rgb2gray(imageInput);
[Ix Iy]=size(grayImage);
imageInput = imrotate(imageInput,-90);
temp = [];
for i = 1:Ix
    for j = 1:Iy
        if grayImage(i,j) < 35
            temp(i,j) = 1;
        else
            temp(i,j) = 0;
        end
    end
end

temp_pad = padarray(temp,[1 1],0,'both');

for i = 1 : Ix
    for j = 1 : Iy
        sum = 0;
        for k = 1 : 3
            for l = 1 : 3
                sum = sum + temp_pad(i+k-1,j+l-1);
            end
        end
        if sum > 4 
            temp(i,j) = 1;
        else
            temp(i,j) = 0;
        end
    end
end

img_fft = fft2(double(temp));
  img_fft = img_fft.';    
  u = 1 : Ix;
  v = 1 : Iy;

  currentx = find(u>Ix/2);
  u(currentx) = u(currentx)-Ix;
  
  currenty = find(v>Iy/2);
  v(currenty) = v(currenty)-Iy;
  
  [U,V] = meshgrid(u,v);
  D = sqrt((U.^2) + (V.^2));
  
  H_glf = exp(-(D.^2)./(2.*20).^2);
  G_glf = img_fft.*H_glf;
  temp = ifft2(G_glf);
  temp = fliplr(temp);
  [Ix Iy] = size(temp);
  

for i = 1:Ix
    for j = 1:Iy
        if temp(i,j) > 0.2
            temp(i,j) = 1;
        else
            temp(i,j) = 0;
        end
    end
end
    figure();
    imshow(imageInput);
    centers = [];
for circle_radius = [ 6 7 8 9 ]

    x = -circle_radius-1:circle_radius+1;
    y = -circle_radius-1:circle_radius+1;
    [xx yy] = meshgrid(x,y);
    u = zeros(size(xx));
    u((xx.^2+yy.^2)<circle_radius^2)=1;

    
    [Cx Cy] = size(u);
    im_pad = padarray(temp,[circle_radius+1 circle_radius+1],0,'both');
    [Px Py] = size(im_pad);
    
    
    for i = 1:Ix
        for j = 1:Iy
            count = 0;
            for k = 1:Cx
                for l = 1:Cy
                    if im_pad(i+k-1,j+l-1) == u(k,l)
                        count = count + 1;
                    end
                end
            end
            if count > 0.85*Cx*Cy
                centers = [centers;j+l-2*circle_radius i+k-2*circle_radius];
            end    
        end
    end

end

    [cx cy] = size(centers);
    index = 0;

for i = 1 : cx
    if index == 0
        index = centers(i,1);
        viscircles(centers(i,1:2),circle_radius);
    else
        if abs(centers(i,1)-index) > circle_radius
            index = centers(i,1);
            viscircles(centers(i,1:2),circle_radius);
        end
    end
end
