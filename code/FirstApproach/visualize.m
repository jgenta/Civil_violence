function [show]=visualize(Map)

%%---Provides a visualization of the Grid---
% Input:
% -the grid
%
% Output:
% -A figure showing:
%   *Inactive People in green
%	*Active People in red
%	*Cops in black


    show=ones(size(Map));
    
%	These operations are used to set the right colors
    inactive=Map(:,:,1)-Map(:,:,2);
    active=Map(:,:,2);
    cops=Map(:,:,3);
    
    show(:,:,1)=show(:,:,1)-inactive;
    show(:,:,3)=show(:,:,3)-inactive;
    
    show(:,:,2)=show(:,:,2)-active;
    show(:,:,3)=show(:,:,3)-active;
    
    show(:,:,1)=show(:,:,1)-cops;
    show(:,:,2)=show(:,:,2)-cops;
    show(:,:,3)=show(:,:,3)-cops;
    
  
    show=show*255;
    
    %imshow(show);
    %pause(0.1);
    %hold on
    
end