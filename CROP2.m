function [res, top, bot] = CROP2(im)
 

    [r c z] = size(im);

    top1 = 0;
    for i = 1:r
        if im(i, 2, :) ~= 0
            break;
        end
        top1 = i;
    end
    
    top2 = 0;
    for i = 1:r
        if im(i, c-1, :) ~= 0
            break;
        end
        top2 = i;
    end
    
    top = min(top1, top2);%%%%%%%%%%%%%%%%%%%%%%%%%
    
    left1 = 0;
    for i = 1:c
        if im(2, i, :) ~= 0
            break;
        end
        left1 = i;
    end
    
   left2 = 0;
    for i = 1:c
        if im(r-1, i, :) ~= 0
            break;
        end
        left2 = i;
    end
    
     left = min(left1, left2);%%%%%%%%%%%%%%%%%%%%%%%%%
     if left>200
         left = 1;
     end
     
    bot1 = 0;
    for i = 1:r
        if im(r-i, 2, :) ~= 0
            break;
        end
        bot1 = i;
    end
    
     bot2 = 0;
    for i = 1:r
        if im(r-i, c-1, :) ~= 0
            break;
        end
        bot2 = i;
    end
    
    bot = min(bot1, bot2);%%%%%%%%%%%%%%%%%%%%%%%%%
    
    right1 = 0;
    for i = 1:c
        if im(2, c-i, :) ~= 0
            break;
        end
        right1 = i;
    end
    
    right2 = 0;
    for i = 1:c
        if im(r-1, c-i, :) ~= 0
            break;
        end
        right2 = i;
    end
    
   right = min(right1, right2);%%%%%%%%%%%%%%%%%%%%%%%%%
   if right>200
         right = 1;
   end
   
   
   res = im(top+1:r-bot, left+1:c-right, :);
   


end