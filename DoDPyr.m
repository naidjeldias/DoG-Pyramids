clear all; clc; close all;
 
im = imread('imagens/zebra.png');

%caso a imagem for rgb converter para grayscale
if size(im,3)>= 3
    im = rgb2gray(im);
end

%definindo o kernel
a = 0.375;
w = [1/4-a/2 1 /4 a 1/4 1/4-a/2];
L = 5;
 
[DoG] = imDoG(im,w,w,L);
 
 
figure; 
for i = 1:L
   
    subplot(1,L,i);
    imshow(DoG{i}, []);
   
end

Aux = DoG{L};
G {1} = Aux;
i = 2;
for j=L:-1:2
    Aux = imExpand(Aux, DoG{j-1},w,w);
    G {i} = Aux;
    i = i + 1;
end

figure;
for i = 1:L
   
    subplot(1,L,i);
    imshow(G{i}, []);
   
end
 
 
%%
% imDoG
% Input :
% I - input image
% p - filter
% d - filter
% L - number of levels
% Output :
% DoG - DoG Pyramid
%%
function [DoG] = imDoG (I, p, d, L)  
    P = {};R = {};
    for i = 1:(L-1)
        %gaussian up level
        [G1] = imreduce(I,p,d);
        %R{i} = G1;
        [Expand]  = expand(G1,p,d);
        [Expandn] = normalization( Expand);
        DoG{i} = double(I) - Expandn;
        I = G1;
    end
    DoG{L} = I;
end

%%
% imreduce
% Input :
% image - input image
% Output :
% image - normalized image
%%
function [image] = normalization( image)
        max_ = max(max(image));
        min_ = min(min(image));
        dif = max_ - min_;
        image = ((image-min_).*255)./(dif);
end
 
 
%%
% imreduce
% Input :
% G0 - input image
% p - filter
% d - filter
% Output :
% G1 - image subsamp
%%
function [G1] = imreduce(G0, p, d)
   
    for i = 1:size(G0,1)
        I1(i,:) = conv(G0(i,:),p,'same');
    end
 
    for i = 1:size(G0,2)
        I1(:,i) = conv(I1(:,i),d,'same');
    end
 
    G1 = I1(:,1:2:end);
    G1 = G1(1:2:end,:);
   
end

 
%%
% imexpand
% Input :
% G1 - upper level gaussian pyramid image
% D0 - Difference DoG pyramid image
% p - filter
% d - filter
% Output :
% G0 - upper level  image
%%
function [G0] = imExpand(G1, D0,p,d)
 
    G1 = expand(G1, p, d);
    
 
    G0 = normalization(G1)+D0;
   
 
end
%%
% imexpand
% Input :
% G1 - upper level gaussian pyramid image
% p - filter
% d - filter
% Output :
% I1 - upper level gaussian image
%%
function [I1] = expand(G1, p, d)
   
    for i = 2:2:2*size(G1,1)
        A1(i,:) = G1((i/2),:);
    end
   
    for i = 2:2:2*size(A1,2)
        A2(:,i) = A1(:,(i/2));
    end
   
    for i = 1:size(A2,1)
        I2(i,:) = conv(A2(i,:),p,'same');
    end
 
    for i = 1:size(I2,2)
        I1(:,i) = conv(I2(:,i),d,'same');
    end
   
end
 