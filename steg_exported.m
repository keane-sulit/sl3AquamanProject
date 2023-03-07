classdef steg_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        HiddenMessageTextArea          matlab.ui.control.TextArea
        HiddenMessageTextAreaLabel     matlab.ui.control.Label
        DecryptedMessageTextArea       matlab.ui.control.TextArea
        DecryptedMessageTextAreaLabel  matlab.ui.control.Label
        DecryptButton                  matlab.ui.control.Button
        LoadImageButton                matlab.ui.control.Button
        EncryptButton                  matlab.ui.control.Button
    end

    
    properties (Access = public)
        message char % Description
        image
    end
    
    methods (Access = private)
        
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.image = [];
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
                msgbox('Encryption successful.')
            end
        end

        % Button pushed function: DecryptButton
        function DecryptButtonPushed(app, event)
             % Prompt user to select encrypted image file
            [filename, filepath] = uigetfile({'*.tiff';'*.jpg;*.jpeg;*.png;*.bmp'}, 'Select encrypted image file');
            
            % Check if user clicked Cancel
            if isequal(filename, 0) || isequal(filepath, 0)
                return
            end
            
            % Call steg_decrypt function to decrypt message from encrypted image
            decryptedmsg = steg_decrypt(fullfile(filepath, filename));
            
            % Display decrypted message in app
            app.DecryptedMessageTextArea.Value = decryptedmsg;
            
            % Show success message
            msgbox('Message decrypted successfully.', 'Success', 'modal');
        end

        % Value changed function: DecryptedMessageTextArea
        function DecryptedMessageTextAreaValueChanged(app, event)
            value = app.DecryptedMessageTextArea.Value;
            
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
            app.EncryptButton.Position = [420 323 100 23];
            app.EncryptButton.Text = 'Encrypt';

            % Create LoadImageButton
            app.LoadImageButton = uibutton(app.UIFigure, 'push');
            app.LoadImageButton.ButtonPushedFcn = createCallbackFcn(app, @LoadImageButtonPushed, true);
            app.LoadImageButton.Position = [420 358 100 23];
            app.LoadImageButton.Text = 'Load Image';

            % Create DecryptButton
            app.DecryptButton = uibutton(app.UIFigure, 'push');
            app.DecryptButton.ButtonPushedFcn = createCallbackFcn(app, @DecryptButtonPushed, true);
            app.DecryptButton.Position = [87 202 100 23];
            app.DecryptButton.Text = 'Decrypt';

            % Create DecryptedMessageTextAreaLabel
            app.DecryptedMessageTextAreaLabel = uilabel(app.UIFigure);
            app.DecryptedMessageTextAreaLabel.HorizontalAlignment = 'center';
            app.DecryptedMessageTextAreaLabel.WordWrap = 'on';
            app.DecryptedMessageTextAreaLabel.Position = [196 148 71 30];
            app.DecryptedMessageTextAreaLabel.Text = 'Decrypted Message';

            % Create DecryptedMessageTextArea
            app.DecryptedMessageTextArea = uitextarea(app.UIFigure);
            app.DecryptedMessageTextArea.ValueChangedFcn = createCallbackFcn(app, @DecryptedMessageTextAreaValueChanged, true);
            app.DecryptedMessageTextArea.Position = [272 101 248 124];

            % Create HiddenMessageTextAreaLabel
            app.HiddenMessageTextAreaLabel = uilabel(app.UIFigure);
            app.HiddenMessageTextAreaLabel.HorizontalAlignment = 'center';
            app.HiddenMessageTextAreaLabel.WordWrap = 'on';
            app.HiddenMessageTextAreaLabel.Position = [87 305 66 29];
            app.HiddenMessageTextAreaLabel.Text = 'Hidden Message';

            % Create HiddenMessageTextArea
            app.HiddenMessageTextArea = uitextarea(app.UIFigure);
            app.HiddenMessageTextArea.ValueChangedFcn = createCallbackFcn(app, @HiddenMessageTextAreaValueChanged, true);
            app.HiddenMessageTextArea.Position = [163 257 248 124];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = steg_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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