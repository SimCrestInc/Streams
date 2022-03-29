pageextension 50100 "SIMC STRM Cust List" extends "Customer List"
{
    layout
    {
    }

    actions
    {
        addfirst(processing)
        {
            action("SIMC STRM Upload File")
            {
                Image = Import;
                Caption = 'Upload Text File and Show Content';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    StreamExamples: Codeunit "SIMC STRM Stream Examples";
                begin
                    StreamExamples.UploadLocalFileIntoStream();
                end;
            }
            action("SIMC STRM Download File")
            {
                Image = Export;
                Caption = 'Create and Download Text File';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    StreamExamples: Codeunit "SIMC STRM Stream Examples";
                begin
                    StreamExamples.DownloadLocalFileFromStream();
                end;
            }
            action("SIMC STRM Upload Excel File")
            {
                Image = Import;
                Caption = 'Upload Excel File';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    StreamExamples: Codeunit "SIMC STRM Stream Examples";
                begin
                    StreamExamples.UploadExcelFileIntoExcelBuffer();
                end;
            }
            action("SIMC STRM Upload Blob to Cust")
            {
                Image = Import;
                Caption = 'Upload Binary file to Customer';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    StreamExamples: Codeunit "SIMC STRM Stream Examples";
                begin
                    StreamExamples.UploadBinaryFileToCust(Rec);
                end;
            }
            action("SIMC STRM Download Blob from Cust")
            {
                Image = Import;
                Caption = 'Download Binary file from Customer';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;

                trigger OnAction()
                var
                    StreamExamples: Codeunit "SIMC STRM Stream Examples";
                begin
                    StreamExamples.DownloadBinaryFileFromCust(Rec);
                end;
            }
        }
    }
}