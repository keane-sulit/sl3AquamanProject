function [username, password] = logindlg()
    % Prompt for username
    prompt = {'Enter username:'};
    dlgtitle = 'Login';
    dims = [1 50];
    definput = {''};
    answer = inputdlg(prompt, dlgtitle, dims, definput);

    if isempty(answer)
        username = '';
        password = '';
        return;
    end

    % Check if username is in accounts file
    accountsFile = 'accounts.txt';
    accounts = readAccounts(accountsFile);
    username = answer{1};
    if ~isfield(accounts, username)
        errordlg('Username not found. Please register first.', 'Invalid Username');
        username = '';
        password = '';
        return;
    end

    % Prompt for password
    prompt = {'Enter password:'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);

    if isempty(answer)
        username = '';
        password = '';
        return;
    end

    % Check if password matches with username in accounts file
    password = answer{1};
    if ~strcmp(accounts.(username), password)
        errordlg('Incorrect password.', 'Invalid Password');
        username = '';
        password = '';
        return;
    end

    % Display success prompt
    msgbox('Login successful!', 'Success');
end