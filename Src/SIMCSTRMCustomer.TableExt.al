tableextension 50100 "SIMC STRM Customer" extends Customer
{
    fields
    {
        field(50100; "SIMC STRM Cust Attachment"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Attachment';
        }
    }
}