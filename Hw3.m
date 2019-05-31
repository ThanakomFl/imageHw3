%ima = imread('WormHole_1H.tif'); 
ima = imread('WormHole_2H.tif'); 

imax = imrotate(ima,-90); 
ima_gray = rgb2gray(ima);
ima_gray = imrotate(ima_gray,-90);
ima_gray = imbinarize(ima_gray,0.23);
ima_gray = ~ima_gray;

[X , Y] = size(ima_gray);
centers = [];
pad_size = 0;

for circle_size = [13 15 17 19 21 23]
    
    Z = zeros(circle_size); 
    origin = [round((size(Z,2)-1)/2+1) round((size(Z,1)-1)/2+1)]; 
    radius = round(sqrt(numel(Z)/(2*pi))); 
    [Cx,Cy] = meshgrid((1:size(Z,2))-origin(1),(1:size(Z,1))-origin(2)); 
    Z(sqrt(Cx.^2 + Cy.^2) <= radius) = 1; 

    kernel = Z;
    [x,y] = size(Z);
    ima_gray_pad = padarray(ima_gray,[(x-1)/2 (y-1)/2],0,'both');

    count = 0;
    redundance = 0;
    old_redundance = 0;
    for i = 1 : X
        for j = 1 : Y
            avg = 0;
            for k = 1  : x
                for l = 1 : y
                    if ima_gray_pad(i+k-1,j+l-1) == kernel(k,l) 
                        avg = avg+1;
                    end
                end
            end
               if  avg > 0.87*((x*y))
                   if 0.95*(x*y) > avg
                        count = count +1;
                        if count > 0
                            pad_size = circle_size;
                        end
                            centers = [centers;j+(circle_size-pad_size)/2 i+(circle_size-pad_size)/2];
                   end
               end
        end
    end
    if count > 0
        pad_size = circle_size;
    end
end
    
    figure;
    imshow(imax);
    [n o] = size(centers);
    real_centers = [];
    index = 0;
    for kk = 1 : n
        if index == 0
            index = centers(1,1);
            real_centers = [real_centers;centers(1,1) centers(1,2)];
        else
            if abs(centers(kk,1)-index) > circle_size/2
                index = centers(kk,1);
                real_centers = [real_centers;centers(kk,1) centers(kk,2)];
            end
        end
    end
    
    [n o] = size(real_centers);
    for m = 1 : n
        viscircles(real_centers(m,1:2),pad_size/2);
    end
    
    