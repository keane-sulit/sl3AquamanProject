classdef steg_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        Label                          matlab.ui.control.Label
        LogOutButton                   matlab.ui.control.Button
        AccountTextArea                matlab.ui.control.TextArea
        AccountLabel                   matlab.ui.control.Label
        HiddenMessageTextArea          matlab.ui.control.TextArea
        HiddenMessageTextAreaLabel     matlab.ui.control.Label
        DecryptedMessageTextArea       matlab.ui.control.TextArea
        DecryptedMessageTextAreaLabel  matlab.ui.control.Label
        DecryptLoadButton              matlab.ui.control.Button
        LoadImageButton                matlab.ui.control.Button
        EncryptButton                  matlab.ui.control.Button
    end

    
    properties (Access = public)
        message char % Description
        image
    end
    
    properties (Access = private)
        CallingApp % Description
    end
    
    methods (Access = private)
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, LoginRegister, User)
            app.image = [];
            app.CallingApp = LoginRegister;
            app.AccountTextArea.Value = char(User);
        end

        % Value changed function: HiddenMessageTextArea
        function HiddenMessageTextAreaValueChanged(app, event)
            app.message = char(app.HiddenMessageTextArea.Value);
        end

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            % Prompt user to select an image file
            [fileName, pathName] = uigetfile({'*.tiff';'*.jpg;*.png;*.bmp'}, 'Select an image file');

            % Check if user cancelled file selection
            if isequal(fileName, 0)
                return
            end
        
            % Construct full path to selected image file
            imagePath = fullfile(pathName, fileName);
        
            % Load selected image file
            try
                app.image = imread(imagePath);
            catch ME
                errordlg('Error loading image file. Please try again.');
                return
            end

            % Check if image is loaded
            if isempty(app.image)
                errordlg('Error: Could not load image file.');
                return
            end
        end

        % Button pushed function: EncryptButton
        function EncryptButtonPushed(app, event)
            % Check if image and message are loaded
            if isempty(app.image) || isempty(app.message)
                errordlg('Please load an image and enter a message first.')
                return
            end
        
            % Encrypt message into image
            encrypted_image = steg_encrypt(app.image, app.message);
        
            % Save encrypted image
            [file, path] = uiputfile({'*.tiff;*.jpg;*.png;*.bmp'}, 'Save As');
            if file ~= 0
                imwrite(encrypted_image, fullfile(path, file));
                hash = DataHash(encrypted_image,'hex','array');
                name = char(app.AccountTextArea.Value);
                extension = '.txt';
                try
                    fileID = fopen(strcat(name,extension), 'a');
                    fprintf(fileID, '%s\n', hash);
                    fclose(fileID);
                catch ME
                    errordlg(['Error writing to file: ' ME.message], 'Error');
                end
                msgbox('Encryption successful.')
            end
        end

        % Button pushed function: DecryptLoadButton
        function DecryptLoadButtonPushed(app, event)
             % Prompt user to select encrypted image file
            [filename, filepath] = uigetfile({'*.tiff';'*.jpg;*.jpeg;*.png;*.bmp'}, 'Select encrypted image file');
            
            % Check if user clicked Cancel
            if isequal(filename, 0) || isequal(filepath, 0)
                return
            end
            
            % Check hash
            hash = DataHash(imread(strcat(filepath,filename)),'hex','array');
            name = char(app.AccountTextArea.Value);
            extension = '.txt';
            fileID = fopen(strcat(name,extension), 'r');
            hash_exist = false;
            
            if exist(strcat(name,extension), 'file') == 2
                % File exists.
                while ~feof(fileID)
                    saved_hash = fgetl(fileID);
                    if isempty(saved_hash)
                        continue;
                    end
                    if strcmpi(saved_hash, hash);
                        hash_exist = true;
                        break;
                    end
                end
            else
                % Error dialog
                errordlg('Decryption error!');
            end
            
            fclose(fileID);
            if hash_exist == false
                errordlg('Decryption error!');
                return;
            else 
                % Call steg_decrypt function to decrypt message from encrypted image
                decryptedmsg = steg_decrypt(fullfile(filepath, filename));
                % Display decrypted message in app
                app.DecryptedMessageTextArea.Value = decryptedmsg;
                % Show success message
                msgbox('Message decrypted successfully.', 'Success', 'modal');
            end
        end

        % Value changed function: DecryptedMessageTextArea
        function DecryptedMessageTextAreaValueChanged(app, event)
            value = app.DecryptedMessageTextArea.Value;
        end

        % Value changed function: AccountTextArea
        function AccountTextAreaValueChanged(app, event)
            value = app.AccountTextArea.Value;
        end

        % Button pushed function: LogOutButton
        function LogOutButtonPushed(app, event)
            main;
            app.delete;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create EncryptButton
            app.EncryptButton = uibutton(app.UIFigure, 'push');
            app.EncryptButton.ButtonPushedFcn = createCallbackFcn(app, @EncryptButtonPushed, true);
            app.EncryptButton.FontName = 'Avenir';
            app.EncryptButton.Position = [437 266 100 23];
            app.EncryptButton.Text = 'Encrypt';

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.FontName = 'Avenir';
            app.LoadImageButton.Position = [437 301 100 23];
            app.LoadImageButton.Text = 'Load Image';

            % Create DecryptLoadButton
            app.DecryptLoadButton = uibutton(app.UIFigure, 'push');
            app.DecryptLoadButton.ButtonPushedFcn = createCallbackFcn(app, @DecryptLoadButtonPushed, true);
            app.DecryptLoadButton.FontName = 'Avenir';
            app.DecryptLoadButton.Position = [104 145 100 23];
            app.DecryptLoadButton.Text = 'Decrypt / Load';

            % Create DecryptedMessageTextAreaLabel
            app.DecryptedMessageTextAreaLabel = uilabel(app.UIFigure);
            app.DecryptedMessageTextAreaLabel.HorizontalAlignment = 'center';
            app.DecryptedMessageTextAreaLabel.WordWrap = 'on';
            app.DecryptedMessageTextAreaLabel.FontName = 'Avenir';
            app.DecryptedMessageTextAreaLabel.Position = [213 91 71 30];
            app.DecryptedMessageTextAreaLabel.Text = 'Decrypted Message';

            % Create DecryptedMessageTextArea
            app.DecryptedMessageTextArea = uitextarea(app.UIFigure);
            app.DecryptedMessageTextArea.ValueChangedFcn = createCallbackFcn(app, @DecryptedMessageTextAreaValueChanged, true);
            app.DecryptedMessageTextArea.Editable = 'off';
            app.DecryptedMessageTextArea.FontName = 'Avenir';
            app.DecryptedMessageTextArea.Position = [289 44 248 124];

            % Create HiddenMessageTextAreaLabel
            app.HiddenMessageTextAreaLabel = uilabel(app.UIFigure);
            app.HiddenMessageTextAreaLabel.HorizontalAlignment = 'center';
            app.HiddenMessageTextAreaLabel.WordWrap = 'on';
            app.HiddenMessageTextAreaLabel.FontName = 'Avenir';
            app.HiddenMessageTextAreaLabel.Position = [104 247 66 30];
            app.HiddenMessageTextAreaLabel.Text = 'Hidden Message';

            % Create HiddenMessageTextArea
            app.HiddenMessageTextArea = uitextarea(app.UIFigure);
            app.HiddenMessageTextArea.ValueChangedFcn = createCallbackFcn(app, @HiddenMessageTextAreaValueChanged, true);
            app.HiddenMessageTextArea.FontName = 'Avenir';
            app.HiddenMessageTextArea.Position = [180 200 248 124];

            % Create AccountLabel
            app.AccountLabel = uilabel(app.UIFigure);
            app.AccountLabel.HorizontalAlignment = 'right';
            app.AccountLabel.FontName = 'Avenir';
            app.AccountLabel.Position = [109 363 49 22];
            app.AccountLabel.Text = 'Account';

            % Create AccountTextArea
            app.AccountTextArea = uitextarea(app.UIFigure);
            app.AccountTextArea.ValueChangedFcn = createCallbackFcn(app, @AccountTextAreaValueChanged, true);
            app.AccountTextArea.Editable = 'off';
            app.AccountTextArea.FontName = 'Avenir';
            app.AccountTextArea.FontWeight = 'bold';
            app.AccountTextArea.Position = [173 366 150 21];

            % Create LogOutButton
            app.LogOutButton = uibutton(app.UIFigure, 'push');
            app.LogOutButton.ButtonPushedFcn = createCallbackFcn(app, @LogOutButtonPushed, true);
            app.LogOutButton.FontName = 'Avenir';
            app.LogOutButton.Position = [437 364 100 23];
            app.LogOutButton.Text = 'Log Out';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.FontName = 'Avenir';
            app.Label.FontSize = 16;
            app.Label.Position = [36 396 571 43];
            app.Label.Text = 'A Steganographic Text Encryption and Decryption Application in MATLAB';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = steg_exported(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end