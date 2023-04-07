function [username, password] = logindlg()
    prompt = {'Enter username:', 'Enter password:', 'Confirm password:'};
    dlgtitle = 'Enter Account Information';
    dims = [1 50];
    definput = {'', '', ''};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    if isempty(answer)
        username = '';
        password = '';
        return;
    end
    
    username = answer{1};
    password = answer{2};
    confirm_password = answer{3};
    
    while ~strcmp(password, confirm_password)
        prompt = {'Passwords do not match. Enter password:', 'Confirm password:'};
        answer = inputdlg(prompt, dlgtitle, dims, {password, ''});
        
        if isempty(answer)
            username = '';
            password = '';
            return;
        end
        
        password = answer{1};
        confirm_password = answer{2};
    end
    
    % Check password length
    if length(password) < 8
        errordlg('Password must be at least 8 characters long.', 'Invalid Password');
        username = '';
        password = '';
        return;
    end
    
    % Check password strength
    if ~any(isstrprop(password, 'upper')) || ~any(isstrprop(password, 'lower')) || ~any(isstrprop(password, 'digit'))
        errordlg('Password must contain at least one uppercase letter, one lowercase letter, and one digit.', 'Invalid Password');
        username = '';
        password = '';
        return;
    end

    % Write account info to file
    try
        fileID = fopen('accounts.txt', 'a');
        fprintf(fileID, '%s,%s\n', username, password);
        fclose(fileID);
    catch ME
        errordlg(['Error writing account info to file: ' ME.message], 'Error');
    end
end