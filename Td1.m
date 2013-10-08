function Td1()
    close all;
    %1 Fonction utiles
    u=double(imread('LENA.BMP'));
%     figure;imshow(u, [0 255]);
%     figure;imagesc(u, [0 255]);
%     figure;image(u);

    %2 Histogramme
    %2 1 Transformation simples
    
    function h=T_1(v)
        if v>128
            h=255;
        else
            h=0;
        end
    end

    function h2=T_2(v)
        h2=255-v;
    end
    
    [x,y]=size(u);
    V=zeros(x,y);
    W=zeros(x,y);
    for i=1:x
        for j=1:y
            tmp=u(i,j);
            V(i,j)=T_1(tmp);
            W(i,j)=T_2(tmp);
        end
    end
    
%    figure;imshow(V, [0 255]);%seillage
%    figure;imshow(W, [0 255]);%negatif
        
    %2 2 Amelioration de la dynamique
%    clown();
    
    %3 Filtrage
%    filtre();

    %FFT
%    Fourier();
    
    %filtrage frequentiel
    filtrage_freq();
end

function clown()
    u=double(imread('CLOWN_LUMI2.BMP'));
    figure;imshow(u, [0 255]);
    figure;imhist(u/255)
    
    function h=T(v,min,max)
        if min==max
            h=0;
        else
            h=((v-min)*1.0/(max-min))*255;
        end
    end

    [x,y]=size(u);
    min=u(1,1);
    max=u(1,1);
    for i=1:x
        for j=1:y
            tmp = u(i,j);
            if tmp>max
                max=tmp;
            end
            if tmp<min
               min=tmp;
            end
        end
    end
        
    V=zeros(x,y);
    for i=1:x
        for j=1:y
            tmp=u(i,j);
            V(i,j)=T(tmp,min,max);
        end
    end
    figure;imshow(V, [0 255]);%C est bien mieux
    figure;imhist(V/255)
    
    %2 3 Histogramme cumule
    function h2=histo_cumul(v)
       h2=zeros(1,256);
       [x,y]=size(v);
        for i=1:x
            for j=1:y
               h2(1,v(i,j)+1)=h2(1,v(i,j)+1)+1;
            end
        end
        for k=2:256
            h2(1,k)=h2(1,k)+h2(1,k-1);
        end
        h2=h2/h2(1,256);
       
    end
    
    function h3=T_2(v,table_assoc)
       h3=255*table_assoc(1,v+1);
    end

    tab=histo_cumul(u);
    [x,y]=size(u);
    V=zeros(x,y);
    for i=1:x
        for j=1:y
            tmp=u(i,j);
            V(i,j)=T_2(tmp,tab);
        end
    end
    figure;imshow(V, [0 255]);%C est bien mieux
    figure;imhist(V/255)
    
end


function filtre()

    u=double(imread('LENA.BMP'));
    figure;imshow(u, [0 255]);
    
    h1=ones(3)/9;
    h2=[0 1 0;1 -4 1;0 1 0];
    
    w1=imfilter(u,h1);
    w2=imfilter(u,h2);
    figure;imshow(w1, [0 255]);%flou, on fait une moyenne ==> filtre moyennant
    figure;imshow(w2, [0 255]);%on fait les contours, opose du Laplacien ==> filtre mediant
    
    bruit=u+(20*randn(size(u)));
    figure;imshow(bruit, [0 255]);
    w3=imfilter(bruit,h1);
    w4=imfilter(bruit,h2);
    figure;imshow(w3, [0 255]);%flou, on fait une moyenne
    figure;imshow(w4, [0 255]);%on fait les contours, opose du Laplacien
    
    V = imnoise(uint8(u),'salt & pepper',0.1);
    figure;imshow(V, [0 255]);
    w5=imfilter(V,h1);
    w6=imfilter(V,h2);
    figure;imshow(w5, [0 255]);%flou, on fait une moyenne
    figure;imshow(w6, [0 255]);%on fait les contours, opose du Laplacien
    
end

function Fourier()

    u=double(imread('LENA.BMP'));
    figure;imshow(u, [0 255]);

    v=fft2(u);
    
    function w=norme(v)
        [x,y]=size(v);
        w=v;
        for i=1:x
            for j=1:y
                w(i,j)=log(norm(v(i,j)));
            end
        end        
    end
    
    w=norme(v);
    
    function h=T(v,min,max)
        if min==max
            h=0;
        else
            h=((v-min)*1.0/(max-min))*255;
        end
    end
    
    [x,y]=size(w);
    min=w(1,1);
    max=w(1,1);
    for i=1:x
        for j=1:y
            tmp = w(i,j);
            if tmp>max
                max=tmp;
            end
            if tmp<min
               min=tmp;
            end
        end
    end
        
    V=zeros(x,y);
    for i=1:x
        for j=1:y
            tmp=w(i,j);
            V(i,j)=T(tmp,min,max);
        end
    end
    
    figure;imshow(fftshift(V), [0 255]);
    
end

function filtrage_freq()
    u=double(imread('LENA.BMP'));
    figure;imshow(u, [0 255]);

    v=fft2(u);
    
    H=zeros(size(u));
    for i=1:5
        for j=1:5
            H(i,j)=1/25;
        end
    end
    hf=fft2(H);
    
    transfo=hf.*v;
    
    final=ifft2(transfo);
    figure;imshow(final, [0 255]);%C est un flou
    
    
    
    h=ones(5)/25;
    w=imfilter(u,h);
    figure;imshow(w, [0 255]);%on obtient bien la meme chose
end
