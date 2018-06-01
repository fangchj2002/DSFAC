
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "A robust fuzzy region-based active contours with saliency-aware
% prior for image segmentation"
% Jiangxiong Fang
% code at : https://github.com/fangchj2002/FRACSP
% East China University of Technology & Nanchang university
% Email:fangchj2002@163.com
% 6th, May, 2018
% The parameters are defined as follows:
% uIn:   The ppesudo LSF;
% Img:   The input image;
% G:     The edge detector in Eq. (19)
% featue:The saliency map
% lambda1,lambda2,alpha1,alpha2: the weighted coefficient in Eq. (21)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u,e,deltaF]= fuzzy_RegionEdge(uIn, Img,G,feature,lambda1,lambda2,alpha1,alpha2)

      u0 = uIn;
      sigma =1.5;
      
      K = fspecial('gaussian',5,sigma); % Caussian kernel      
      f1=conv2(Img.*(u0.^2),K,'same'); 
      f2=conv2(Img.*((1-u0).^2),K,'same');
      
     
      t1 = u0.^2;
      t2 = (1-u0).^2;
      
      c1 = sum(sum(f1))/sum(sum(t1));         % average inside of Phi1
      c2 = sum(sum(f2))/sum(sum(t2));         % average outside of Phi2
     
      edg1 = conv2(feature.*(u0.^2),G,'same'); 
      edg2 = conv2(feature.*((1-u0).^2),G,'same');
      
      e1 = sum(sum(edg1))/sum(sum(t1)); 
      e2 = sum(sum(edg2))/sum(sum(t2));
      
      un= 1./ (1+(lambda1*(Img-c1).^2+alpha1*(feature-e1).^2)./(lambda2*(Img-c2).^2+alpha2*(feature-e2).^2));
      
      f1=conv2(Img.*(u0.^2),K,'same'); 
      f2=conv2(Img.*((1-u0).^2),K,'same');
      
      t1 = u0.^2;
      t2 = (1-u0).^2;   
      
      c1 = sum(sum(f1))/sum(sum(t1));         % average inside of Phi1
      c2 = sum(sum(f2))/sum(sum(t2));         % average outside of Phi2

      edg1 = conv2(feature.*(u0.^2),K,'same'); 
      edg2 = conv2(feature.*((1-u0).^2),K,'same');
      
      e1 = sum(sum(edg1))/sum(sum(t1)); 
      e2 = sum(sum(edg2))/sum(sum(t2));
      
      l1 = (un.^2-u0.^2);
      l2 = (1-un).^2-(1-u0).^2; 
      
      s1 = sum(sum(t1));
      s2 = sum(sum(t2));

            
      delta1 = s1*l1.*((Img-c1).^2)./(s1+l1);
      delta2 = s2*l2.*((Img-c2).^2)./(s2+l2);
      delta3 = s1*l1.*((feature-e1).^2)./(s1+l1);
      delta4 = s2*l2.*((feature-e2).^2)./(s2+l2);
      deltaF = lambda1*delta1+lambda2*delta2+alpha1*delta3+alpha2*delta4;
      idx = find(deltaF<0);
      u0(idx)=un(idx); 
      e = sum(sum(f1 + f2 + edg1 + edg2));
      deltaF = sum(sum(deltaF));
      u = u0;     
end