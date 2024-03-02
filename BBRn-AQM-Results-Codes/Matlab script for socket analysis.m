
file1name=uigetfile('*.*');
file1=fopen(file1name, 'r');
fieldname=input('Please enter field name to search in file:','s');
%disp(fieldname);
%make a double pass
%first one to know how many lines are there in the file

file2=fopen('out.txt','w');

numlines=0;
while ~feof(file1)
    line1=fgetl(file1);
    numlines=numlines+1;
    disp(numlines);
    %disp(line1);
    
    word1='';
    maxlen=length(line1);
end
%go back to start of file
frewind(file1);
for lines=1:numlines
    line1=fgetl(file1);
    disp(i);
    %disp(line1);
    
    maxlength=length(line1);
    word1='';
    i=0;
    j=i;
    while i<maxlength
        %begin gathering current field
        word1='';
        while j<maxlength
            j=j+1;
            if line1(j)~=' '
                word1=strcat(word1,line1(j));
            else
                i=j;
                break;
            end
        end
        if j==maxlength
            i=j;
        end
        disp(word1);
        maxwordlength=length(word1);
        %check if current word contains the field name
        if contains(word1,fieldname)
            %extract value of field from this word
            %position of field within word
            k=strfind(word1,fieldname);
            %ensuring exact match, not part of larger string
            %to do this check if next letter is colon or space
            %except the pacing_rate type fields where a space follows
            if maxwordlength==k+length(fieldname)-1
                %is exception like pacing_rate
                %go on
            else
                if word1(k+length(fieldname))==' ' || word1(k+length(fieldname))==':'
                    %go on
                else
                    break;
                end
                if k>1 && isletter(word1(k-1))
                    break;
                end
            end
            %disp(k);
            %search of colon or space after this postion
            validx=k;
            for m=k:maxwordlength
                if word1(m)==':' 
                    validx=m;
                    break;
                end
            end
            if m<maxwordlength
                %increment to go to first char of value
                validx=validx+1; 
                %gather value
                val1='';
                p=validx;
                while p<=maxwordlength
                    if word1(p)~=' ' && ~(isletter(word1(p)))
                        val1=strcat(val1,word1(p));
                    else
                        break;
                    end
                    p=p+1;
                end
                %disp(val1);
                %write to file2
                fprintf(file2,'%s\r\n' ,val1);
            else
                %colon is missing and there could be space instead
                %gather next word as value
                word1='';
                while j<maxlength
                    j=j+1;
                    if line1(j)~=' '
                        word1=strcat(word1,line1(j));
                    else
                        i=j;
                        break;
                    end
                end
                if j==maxlength
                    i=j;
                end
                disp(word1);
                %now extract value from this word minus the units
                maxwordlength=length(word1);
                validx=1; 
                %gather value
                val1='';
                p=validx;
                while p<maxwordlength
                    if word1(p)~=' ' && ~(isletter(word1(p)))
                        val1=strcat(val1,word1(p));
                    else
                        break;
                    end
                    p=p+1;
                end
                disp(val1);
                %write to file2
                fprintf(file2,'%s\r\n' ,val1);
            end
            
            
        end
        
        
        
    end

end

fclose(file1);
fclose(file2);


