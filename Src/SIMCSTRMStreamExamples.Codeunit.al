codeunit 50100 "SIMC STRM Stream Examples"
{

    // In Online BC we are not allowed to access the service tier so we can't upload or download files from the service tier anymore.
    // This means that traditional file handling is not possible.
    // In order to handle importing and exporting files, we need to use Streams and TempBlob. Think of streams as files in memory only. 
    // Streams are maintained similar to files, except we don't have to worry about creating temp files and up- or downloading files any more.
    // There are two streams:
    //        InStream: This stream is going into Business Central. We can read from it and process its content like we read files in NAV
    //        OutStream: This stream is coming out of Business Central. We can write to the stream like we wrote text into a file in NAV
    // So the direction of the stream is in relation to Business Central.
    //
    // In order to import/export a physical file from/to the local client, we use FileManagement functions on TempBlob
    // 
    // In order to test this code, you will need a text file with some lines of text like this:
    //      Line 1
    //      Line 2
    //      Line 3
    //
    // You will also need an Excel file. Just use a small simple excel file, as we don't process the content


    // This function will upload a file that the user picks and load it into an InStream and shows the content line by line
    procedure UploadLocalFileIntoStream()
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ReadInStream: InStream;
        FileName: Text;
        TextLine: Text;
    begin
        // We clear TempBlob. We really don't need to do it here since the local var is already cleared.
        Clear(TempBlob);
        // Create the Instream so we can read from it. 
        TempBlob.CreateInStream(ReadInStream);
        // We could use UploadIntoStream here, but we get a lot of error checks and control using BLOBImportWithFilter instead
        // This will read the file into the TempBlob so we can read the file using the InStream
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, 'Select Text file to import', '', 'Text files (*.txt)|*.txt', 'txt');
        // Show File name
        Message('File name: ' + FileName);
        // Read the InStream line by line
        While not ReadInStream.EOS() do begin
            ReadInStream.ReadText(TextLine);
            // Here we just display the text. This is where you would write code to handle the content
            Message(TextLine);
        end;
    end;

    // This function will download a generated stream to the local download folder
    procedure DownloadLocalFileFromStream()
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        WriteOutStream: OutStream;
        FileName: Text;
    begin
        // We clear TempBlob. We really don't need to do it here since the local var is already cleared.
        Clear(TempBlob);
        // Create the Outstream so we can write to the TempBlob.
        TempBlob.CreateOutStream(WriteOutStream);
        // We write 3 lines with carriage returns to the Outstream 
        // This is where you would write code to populate the TempBlob from the OutStream and ultimately to the downloaded file
        WriteOutStream.WriteText('Exported Line 1');
        WriteOutStream.WriteText();
        WriteOutStream.WriteText('Exported Line 2');
        WriteOutStream.WriteText();
        WriteOutStream.WriteText('Exported Line 3');
        // We need a file name
        FileName := 'Exportfile.txt';
        // Export the generated file to the local download folder
        FileManagement.BLOBExport(TempBlob, FileName, true);
    end;

    // This is an example how to read an Excel file. We do not process the file, just showing how to use an Instream to read the excel file and
    // read it into ExcelBuffer
    procedure UploadExcelFileIntoExcelBuffer()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ReadInStream: InStream;
        FileName: Text;
        SheetName: Text;
    begin
        // We clear TempBlob. We really don't need to do it here since the local var is already cleared.
        Clear(TempBlob);
        // Create the Instream so we can read from it.
        TempBlob.CreateInStream(ReadInStream);
        // Let the user pick the Excel file. This will read the file into the TempBlob so we can read the file using the InStream
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, 'Select Excel file to import', '', 'Excel files (*.xlsx)|*.xlsx', 'xlsx');
        // Show File name
        Message('File name: ' + FileName);
        // Read the Sheet name. Notice we use the Stream version of SelectSheetName
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ReadInStream);
        Message('Sheet name: ' + SheetName);
        //  Open the Excel book. We use the Stream version of that call
        TempExcelBuffer.OpenBookStream(ReadInStream, SheetName);
        // Here we read the spreadsheet into ExcelBuffer
        TempExcelBuffer.ReadSheet();
        // Here goes code to process ExcelBuffer
    end;

    // This is an example how to read a binary file into a custom Blob field in the Item table. 
    procedure UploadBinaryFileToItem(var Item: Record Item)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ReadInStream: InStream;
        WriteOutStream: OutStream;
        FileName: Text;
    begin
        // We clear TempBlob. We really don't need to do it here since the local var is already cleared.
        Clear(TempBlob);
        // Create the Instream so we can read from it.
        TempBlob.CreateInStream(ReadInStream);
        // Let the user pick the any file. This will read the file into the TempBlob so we can read it using the InStream
        FileManagement.BLOBImportWithFilter(TempBlob, 'Select file to import', '', 'All files (*.*)|*.*', '');

        // If a file was loaded we continue the process
        if FileName <> '' then begin
            // We create an outstream so we can write into the Blob field on the Item record
            Item."SIMC STRM Item Attachment".CreateOutStream(WriteOutStream);
            // Copy the ReadInsteam to WriteOutstream. This will load the binary file (InStream) into the Item Blob field (OutStream)
            CopyStream(WriteOutStream, ReadInStream);
            // Modify the Item record to save the Blob
            Item.Modify();
        end;
    end;

    procedure DownloadBinaryFileFromItem(Item: Record Item)
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        ReadInStream: InStream;
        WriteOutStream: OutStream;
        NoAttachmentTxt: Label 'Item has not attachment';
    begin
        Clear(TempBlob);
        if not Item."SIMC STRM Item Attachment".HasValue() then
            error(NoAttachmentTxt);
        Item.CalcFields("SIMC STRM Item Attachment");
        Item."SIMC STRM Item Attachment".CreateInStream(ReadInStream);
        TempBlob.CreateOutStream(WriteOutStream);
        CopyStream(WriteOutStream, ReadInStream);
        FileManagement.BLOBExport(TempBlob, Item.Description, true);
    end;

}