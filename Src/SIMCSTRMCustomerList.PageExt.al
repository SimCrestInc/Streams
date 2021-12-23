pageextension 50100 "SIMC STRM Customer List" extends "Customer List"
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
                Caption = 'Upload File and Show Content';
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
                Caption = 'Create and Download File';
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
                    StreamExamples.UploadExcelFileinExcelBuffer();
                end;
            }
        }
    }
}