codeunit 50100 "SIMC STRM Stream Examples"
{

    // In Online BC we are not allowed to access the service tier so we can't upload or download files from the service tier.
    // This means that traditional file handling is not possible.
    // In order to handle importing and exporting files, we need to use Streams and TempBlob. Thing of streams as files in memory only. 
    // Streams ar maintained similar to files, except we don't have to worry about creating temp files and uploading files any more.
    // There are two streams:
    //        InStream: This stream is going into Business Central. We can read from it and process its content like we read files in NAV
    //        OutStream: This stream is coming out of Business Central. We can write to the stream like we wrote text into a file
    // So the direction of the stream is in relation to Business Central.
    //
    // In order to import/export a physical file from/to the local client, we use TempBlob functions.
    // 
    // In order to test this code, you will need a text file with some lines of text like this:
    //      Line 1
    //      Line 2
    //      Line 3


    // This function will upload a file that the user picks and load it into InStream and show the content line by line
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
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, 'Select Text file to import', '', 'Text files (*.txt)|*.txt', 'txt');
        // Show File name
        Message('File name: ' + FileName);
        // Read the InStream line by line
        While not ReadInStream.EOS do begin
            ReadInStream.ReadText(TextLine);
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
        // Create the Outstream so we can write to it.
        TempBlob.CreateOutStream(WriteOutStream);
        // We write 3 lines with carriage returns to the Outstream 
        WriteOutStream.WriteText('Exported Line 1');
        WriteOutStream.WriteText();
        WriteOutStream.WriteText('Exported Line 2');
        WriteOutStream.WriteText();
        WriteOutStream.WriteText('Exported Line 3');
        FileName := 'Exportfile.txt';
        // Export the generated file to the local download folder
        FileManagement.BLOBExport(TempBlob, FileName, true);
    end;

    // This is an example how to read an Excel file. We do not process the file, just showing how to use an Instream to read the excel file and
    // read it into ExcelBuffer
    procedure UploadExcelFileinExcelBuffer()
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
        // Let the user pick the Excel file
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, 'Select Excel file to import', '', 'Excel files (*.xlsx)|*.xlsx', 'xlsx');
        // Show File name
        Message('File name: ' + FileName);
        // Read the Sheet name. Notice we use the Stream version for SelectSheetName
        SheetName := TempExcelBuffer.SelectSheetsNameStream(ReadInStream);
        Message('Sheet name: ' + SheetName);
        //  Open the Excel book. We use the Stream version of that call
        TempExcelBuffer.OpenBookStream(ReadInStream, SheetName);
        // Here we read the spreadsheet into ExcelBuffer. Now we can process Excel Buffer
        TempExcelBuffer.ReadSheet();
    end;



}