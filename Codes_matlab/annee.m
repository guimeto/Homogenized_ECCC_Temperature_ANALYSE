%% ANNEE
%
%% DESCRIPTION DU CODE
% Ce code permet de decouper une serie temporelle en annee
%
%             
% Sortie:   - 1 vecteurs (1 par annee) 
function [Win]=annee(start_year, end_year, Sig, y_length)

curr_year=start_year;
temp=1;
ii=1;
t=1;
if(y_length==366)
    while (curr_year <= end_year)
        if ( mod(curr_year, 4)==0 )
            for j=temp:temp+365   
                    Win(ii,t)=Sig(j);
                    ii=ii+1;
            end
            
            temp=temp+366;
        else
            for j=temp:temp+364
                    Win(ii,t)=Sig(j);
                    ii=ii+1;           
            end      
            temp=temp+365;
        end        
        curr_year=curr_year+1;
        t=t+1;
        ii=1;
    end
    
elseif(y_length==365)
    while (curr_year <= end_year)
        for j=temp:temp+364
            
                Win(ii,t)=Sig(j);
                ii=ii+1;          
        end
        temp=temp+365;
        curr_year=curr_year+1;
        t=t+1;
        ii=1;
    end
end
        
