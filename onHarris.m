function A = HarrisF(img)
[m n]=size(img);
wSize = 2;

tmp=zeros(m+wSize,n+wSize);
tmp(wSize:m+wSize-1,wSize:n+wSize-1)=img;
Ix=zeros(m+wSize,n+wSize);
Iy=zeros(m+wSize,n+wSize);

%计算梯度
Ix(:,2:n)=tmp(:,3:n+1)-tmp(:,1:n-1);
Iy(2:m,:)=tmp(3:m+1,:)-tmp(1:m-1,:);

Ix2=Ix(2:m+1,2:n+1).^2;
Iy2=Iy(2:m+1,2:n+1).^2;
Ixy=Ix(2:m+1,2:n+1).*Iy(2:m+1,2:n+1);

h=fspecial('gaussian',[3 3],2);
%二维线型数字滤波，即加入高斯权重
Ix2=filter2(h,Ix2);
Iy2=filter2(h,Iy2);
Ixy=filter2(h,Ixy);

Rmax=0;
R=zeros(m,n);
k = 0.06; %一般取0.04~0.06
%计算R矩阵
for i=1:m
    for j=1:n
        M=[Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)];
        R(i,j)=det(M)-k*(trace(M))^2;
        
        if R(i,j)>Rmax
            Rmax=R(i,j);
        end
    end
end

A=[];

%窗口大小
m_Size = 5;

for i=1:m
    for j=1:n
        if R(i,j)>0.01*Rmax     %取0.01Rmax能得到较好的结果
            for c = 0:m_Size*m_Size
					temp = floor(m_Size / 2);
					yIndex = i + floor(c / m_Size) - temp;
					xIndex = j + mod(c, m_Size) - temp;
					if (i + floor(c / m_Size) - temp) < 1
						yIndex = 1;
                    elseif (i + floor(c / m_Size) - temp) > m
						yIndex = m;
                    end

					if (j + mod(c, m_Size) - temp) < 1
						xIndex = 1;
                    elseif (j + mod(c, m_Size)  - temp) > n
						xIndex = n;
                    end
                    
                    if R(i, j) < R(yIndex, xIndex)
                        break;
                    end
                    
                    if(c == m_Size*m_Size)
                        window=zeros(2);
                        window=[i,j];
                        A = [A;window];
                    end
            end
        end
    end
end
end
