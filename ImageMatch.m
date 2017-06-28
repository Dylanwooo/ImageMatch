close all;
clear all;
clc;
%˫������
imgL = imread('Left.tif');
imgL = imgL(:,:,1:3);
imgL=rgb2gray(imgL);
imgR=imread('Right.tif');
imgR = imgR(:,:,1:3);
imgR=rgb2gray(imgR);

%ͼ��m�Ǹߣ�n�ǿ�
[m n]=size(imgR);

%ģ�崰�ں������������ڴ�С
w1 = 5;
w2 = 20;
%����Harris�㷨���
L = onHarris(imgL);
R = onHarris(imgR);

[sizeL,sizeT] = size(L);
[sizeR,sizeT] = size(R);

index = 1;
judge = 1;
%�����Ҽ��
for i = 1:sizeL
    x = L(i,1);
    y = L(i,2);

    %ģ�崰��
    window1 = zeros(w1*w1);
    for j = 1:w1*w1
        temp = floor(w1 / 2);
		xIndex = x + floor(j / w1) - temp;
		yIndex = y + mod(j, w1) - temp;
		if (x + floor(j / w1) - temp) < 1
			xIndex = 1;
        elseif (x + floor(j / w1) - temp) > m
			xIndex = m;
        end

		if (y + mod(j, w1) - temp) < 1
			yIndex = 1;
        elseif (y + mod(j, w1)  - temp) > n
			yIndex = n;
        end
        window1(j) = imgL(xIndex,yIndex);
    end
    
    for j = -1:1
        Rmax = -1;
        %��������
        window2 = zeros(w2*w2);
        for c = 1:n
            cIndex = x + j;
            if cIndex < 1
                cIndex = 1;
            elseif cIndex > m
                cIndex = m;
            end
            for k = 1:w2*w2
               temp = floor(w2 / 2);
               xIndex = cIndex + floor(k / w2) - temp;
               yIndex = c + mod(k, w2) - temp;

               if (cIndex + floor(k / w2) - temp) < 1
                   xIndex = 1;
               elseif (cIndex + floor(k / w2) - temp) > m
                   xIndex = m;
               end

               if (c + mod(k, w2) - temp) < 1
                   yIndex = 1;
               elseif (c + mod(k, w2)  - temp) > n
                   yIndex = n;
               end
               window2(k) = imgR(xIndex, yIndex);
            end
            
            Rtemp = correlation(window1, window2, w2);     
            %���ϵ����ֵ����Ϊ0.9
            if Rtemp > Rmax && Rtemp>0.9
                Rmax = Rtemp;
                 for i1 = 1:sizeR
                    if(R(i1,1) == cIndex) && (R(i1,2) == c) 
                        windowT(index, 1) = cIndex;
                        windowT(index, 2) = c;
                        windowT1(index, 1) = x;
                        windowT1(index, 2) = y;
                        judge = 0;
                    end
                 end             
            end
       end    
    end
    if judge == 0
        index = index + 1;
        judge = 1;
    end
end

index = 1;
judge = 1;

%���ҵ����⣬���˫����
[sizeT,sizeT1] = size(windowT);

for i = 1:sizeT
    x = windowT(i,1);
    y = windowT(i,2);
    %ģ�崰��
    window1 = zeros(w1*w1);
    for j = 1:w1*w1
        temp = floor(w1 / 2);    
		xIndex = x + floor(j / w1) - temp;
		yIndex = y + mod(j, w1) - temp;
		if (x + floor(j / w1) - temp) < 1
			xIndex = 1;
        elseif (x + floor(j / w1) - temp) > m
			xIndex = m;
        end

		if (y + mod(j, w1) - temp) < 1
			yIndex = 1;
        elseif (y + mod(j, w1)  - temp) > n
			yIndex = n;
        end
        window1(j) = imgR(xIndex,yIndex);
    end
    
    for j = -1:1
        Rmax = -1;

        %��������
        window2 = zeros(w2*w2);
        for c = 1:n
            cIndex = x + j;
            if cIndex < 1
                cIndex = 1;
            elseif cIndex > m
                cIndex = m;
            end
            for k = 1:w2*w2
               temp = floor(w2 / 2);
               xIndex = cIndex + floor(k / w2) - temp;
               yIndex = c + mod(k, w2) - temp;

               if (cIndex + floor(k / w2) - temp) < 1
                   xIndex = 1;
               elseif (cIndex + floor(k / w2) - temp) > m
                   xIndex = m;
               end

               if (c + mod(k, w2) - temp) < 1
                   yIndex = 1;
               elseif (c + mod(k, w2)  - temp) > n
                   yIndex = n;
               end
               window2(k) = imgL(xIndex, yIndex);
            end
            Rtemp = correlation(window1, window2, w2);          
            if Rtemp > Rmax && Rtemp>0.9
                Rmax = Rtemp;
                if(windowT1(i,1) == cIndex && windowT1(i,2) == c)
                    windowR(index, 1) = x;
                    windowR(index, 2) = y; 
                    windowL(index, 1) = cIndex;
                    windowL(index, 2) = c;
                    judge = 0;
                end               
            end
       end    
    end
    if judge == 0
        showIndex(index) = index;
        index = index + 1;
        judge = 1;
    end
end

[FinalSize,sizeT] = size(windowL);

figure(1);
title('ƥ����');
imshow(imgL);
hold on;
for i = 1:FinalSize
    plot(windowL(i, 2), windowL(i, 1), 'r+');
end

figure(2);
title('ƥ����');
imshow(imgR);
hold on; 
for i = 1:FinalSize
    plot(windowR(i, 2), windowR(i, 1), 'r+');
end
t=toc 
