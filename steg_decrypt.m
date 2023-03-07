function decryptedmsg = steg_decrypt(imgfilename)
    % Read in the encrypted image
    imgdec = imread(imgfilename);
    
    % Initialize variables for iterating through the image
    [maxrows, maxcolumns, maxpages] = size(imgdec);
    imgdecbinary = str2double(reshape(cellstr(dec2bin(imgdec)), size(imgdec)));
    dashcounter = 0;
    rows = 1;
    columns = 1;
    page = 1;
    eightcounter = 1;
    msgcolumns = 1;
    decryptedmsg = [];
    save = "";
    
    % Extract the binary message from the image and decrypt it
    while dashcounter < 3
        save = strcat(save,string(mod(double(imgdecbinary(rows,columns,page)), 2)));
        page = page + 1;
        if page == 4
            columns = columns + 1;
            page = 1;
        end
        if columns == maxcolumns + 1
            rows = rows + 1;
            columns = 1;
        end
        eightcounter = eightcounter + 1;
        if eightcounter == 9
            if bin2dec(save) == 45 % ASCII code for dash
                dashcounter = dashcounter + 1;
            else
                decryptedmsg(1,msgcolumns) = bin2dec(save) - 3;
                msgcolumns = msgcolumns + 1;
            end
            save = "";
            eightcounter = 1;
        end 
    end
    
    decryptedmsg = char(decryptedmsg);
end
