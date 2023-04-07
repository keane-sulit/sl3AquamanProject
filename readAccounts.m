function accounts = readAccounts(filename)
    % Read accounts file and return a struct of username-password pairs
    accounts = struct();
    try
        fileID = fopen(filename, 'r');
        tline = fgetl(fileID);
        while ischar(tline)
            C = strsplit(tline, ',');
            username = C{1};
            password = C{2};
            accounts.(username) = password;
            tline = fgetl(fileID);
        end
        fclose(fileID);
    catch ME
        errordlg(['Error reading accounts file: ' ME.message], 'Error');
    end
end